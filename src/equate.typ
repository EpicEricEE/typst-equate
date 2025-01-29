#import "align.typ": realign
#import "combine.typ": combine, combine-state, combined-lines
#import "common.typ": revoked, equate-state
#import "line.typ": to-lines, numbered

#let nesting-state = state("equate/nesting", 0)

// Parameters of the equate function.
#let equate(number-mode: "line", sub-numbering: false, debug: false, body) = {
  // Validate parameters
  assert(
    number-mode in ("label", "line", "block"),
    message: "invalid number-mode, expected 'label', 'line', or 'block'"
  )
  assert(
    type(sub-numbering) == bool,
    message: "invalid sub-numbering, expected a boolean value"
  )
  assert(
    type(debug) == bool,
    message: "invalid debug, expected a boolean value"
  )

  // Store the current settings in the state.
  equate-state.update(stack => stack + ((
    number-mode: number-mode,
    sub-numbering: sub-numbering
  ),))

  // Prevent figures meant for referencing from being displayed.
  show figure.where(body: [], kind: math.equation): none

  // Show alignment spacers when debugging.
  let spacer = selector.or(
    box.where(body: none, fill: yellow, stroke: stroke(0.4pt)),
    box.where(body: none, fill: green, stroke: stroke(0.4pt))
  )
  show spacer: it => if debug { it } else { hide(it) }
  show spacer: set box(height: 0.4em) if debug

  show math.equation.where(block: true): it => {
    // Don't apply the rule to revoked equations.
    if it.has("label") and it.label == <equate:revoke> { return it }
    // Don't apply the rule to nested equations.
    if nesting-state.get() > 0 { return it }

    let lines = {
      // First, split the equation into lines and extract any labels.
      let (lines, revoked, labels) = array.zip(exact: true,
        ..to-lines(it).map(dictionary.values)
      )

      // Realign the lines considering all lines in the current combine block.
      let consider = combined-lines().map(line => line.body)
      lines = realign(lines, consider: consider)

      // Transpose the data to create a dictionary for each line.
      array.zip(exact: true, lines, revoked, labels)
        .map(((line, revoked, label)) => {
          let line = (body: line.join(), revoked: revoked, label: label)
          line.numbered = numbered(line, number-mode, it)
          line
        })
    }

    if it.numbering != none {
      // Step back counter to keep the same main number as the original equation.
      counter(math.equation).update(n => n - 1)
    }

    if number-mode == "block" {
      // Put all lines in a single equation, but make sure that no lines are
      // labeled, as they can't be numbered individually.
      assert(
        lines.all(line => not line.revoked and line.label == none),
        message: "cannot label individual lines in block numbering mode"
      )

      let numbering = if it.numbering != none {
        (..) => numbering(it.numbering, ..counter(math.equation).get())
      }

      revoked(
        numbering: numbering,
        lines.map(line => line.body).join(linebreak()) + if numbering != none {
          h(0pt) + figure(
            none,
            caption: [],
            kind: math.equation,
            supplement: it.supplement,
            numbering: numbering
          )
        }
      )
      counter(math.equation).update(n => n - 1)
    } else {
      // Put lines in separate equations for per-line numbering.
      grid(
        columns: 1,
        row-gutter: par.leading,
        ..lines.map(line => {
          if line.numbered { counter("equate/line").step() }
          
          // Total number of lines in the equation.
          let total = if combine-state.get().at("numbering", default: false) {
            combined-lines().len()
          } else {
            lines.len()
          }

          let numbering = if line.numbered {
            (..) => {
              let main = counter(math.equation).get().first()
              let sub  = counter("equate/line").get().first()
              let nums = if sub-numbering and total > 1 { (main, sub) } else { (main,) }
              numbering(it.numbering, ..nums) 
            }
          }
          
          revoked(
            numbering: numbering,
            line.body + if line.numbered [
              // Add figure to allow referencing and outlining.
              #h(0pt) #figure(
                none,
                caption: [],
                kind: math.equation,
                supplement: it.supplement,
                numbering: numbering
              ) #line.label
            ],
          )

          if sub-numbering and line.numbered {
            // Step back counter to continue with the same main number in the
            // next line.
            counter(math.equation).update(n => n - 1)
          }
        })
      )
    }

    // After the last line, the counter has to be stepped again, so that the main
    // number is increased for the next equation. When in a combine block, this
    // is done at the end of the block or equation. Otherwise, it is done here.
    if combine-state.get() == (:) {
      counter("equate/line").update(0)
      if sub-numbering and lines.any(line => line.numbered) {
        counter(math.equation).step()
      }
    }
  }

  // Prevent nested equations from messing with the layout.
  show math.equation.where(block: true): it => {
    set math.equation(numbering: none)
    
    nesting-state.update(n => n + 1)
    it
    nesting-state.update(n => n - 1)
  }

  body

  // Remove the current settings from the state.
  equate-state.update(stack => stack.slice(0, -1))
}

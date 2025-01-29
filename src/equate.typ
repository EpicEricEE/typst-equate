#import "align.typ": realign
#import "combine.typ": combine, combine-state, combined-lines
#import "common.typ": revoked, equate-state
#import "process.typ": to-lines, process-line

// Parameters of the equate function.
#let equate(number-mode: "block", sub-numbering: true, debug: false, body) = {
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

    let lines = {
      // First, split the equation into lines and extract any labels.
      let (lines, revoked, labels) = array.zip(exact: true,
        ..to-lines(it).map(line => process-line(line).values()
      ))

      // Realign the lines considering all lines in the current combine block.
      let consider = combined-lines().map(process-line).map(line => line.body)
      lines = realign(lines, consider: consider)

      // Transpose the data to create a dictionary for each line.
      array.zip(exact: true, lines, revoked, labels)
        .map(((line, revoked, label)) => (
          body: line.join(),
          revoked: revoked,
          label: label,
          numbered: (
            (number-mode == "block") or
            (number-mode == "line" and not revoked) or
            (number-mode == "label" and (label != none or (it.has("label") and not revoked)))
          )
        ))
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

      let numbering = (..) => numbering(it.numbering, ..counter(math.equation).get())

      revoked(
        numbering: numbering,
        lines.map(line => line.body).join(linebreak()) + h(0pt) + figure(
          none,
          caption: [],
          kind: math.equation,
          supplement: it.supplement,
          numbering: numbering
        )
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

  body

  // Remove the current settings from the state.
  equate-state.update(stack => stack.slice(0, -1))
}

#set math.equation(numbering: "(1.1)")
#show: equate.with(number-mode: "label")

#combine(numbering: true)[
  Let's start with some content...
  $ &y + b $
  _Look, there's a normal paragraph inbetween, but the alignment *and* numbering continues!_
  $ &x^2 + y \
    &22x - v = 22z $
]

Now the combined equation is done, and we're "back to the root"

$ e^2 = 0 $

$ e^2 &= 0 \ 1+1 &= 2 $ <y>

$ e^2 = 0 $ <z>

#outline(target: figure.where(kind: math.equation))

$ a &= b           &        &=i            \
    &= cases(a, b) &+ x y z &= x $
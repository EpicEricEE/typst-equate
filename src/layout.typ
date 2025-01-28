#import "align.typ": realign
#import "common.typ": combine-state, revoked, to-lines
#import "process.typ": process, is-labeled, get-metadata

/// Validate that the given equation lines make sense with the given settings.
#let validate(eq, lines, sub-numbering, number-mode) = {
  let main-label = if eq.has("label") { eq.label }

  // Cannot have line labels, when lines aren't numbered.
  if number-mode == "block" {
    assert(
      lines.all(line => not is-labeled(line)),
      message: "cannot label lines when `number-mode` is set to \"block\""
    )
  }

  // Cannot have main label when multiple main numbers are shown.
  if not sub-numbering and main-label != none and number-mode != "block" {
    assert(
      lines.len() == 1,
      message: "cannot label main equation when sub-numbering is disabled"
    )
  }
}

/// Layout an equation with the given properties.
#let layout-equation(
  sub-numbering: false,
  number-mode: "line",
  eq
) = {
  let main-number = counter(math.equation).get()

  // Get lines from combined equation, that should be considered for alignment
  // and continued sub-numbering.
  let consider = if combine-state.get().stack == () { () } else {
    let num = combine-state.get().stack.last()
    let line-state = state("equate/combine/" + str(num), ())
    line-state.final()
  }

  let lines = process(
    numbering: eq.numbering,
    supplement: eq.supplement,
    consider: consider,
    to-lines(eq),
  )

  validate(eq, lines, sub-numbering, number-mode)

  // Step back counter, as the original equation should not be counted.
  // When sub-numbering is enabled, this is not necessary, as the counter is
  // stepped back for each line. As the counter should not be stepped back
  // after the last line, this is cancelled out by not stepping back here.
  if not sub-numbering or number-mode == "block" {
    counter(math.equation).update(n => n - 1)
  }

  let realigned = realign(lines, consider: consider)

  if number-mode == "block" {
    revoked(
      numbering: (..) => numbering(eq.numbering, ..main-number),
      realigned.map(array.join).join(linebreak())
    )
  } else {
    grid(
      columns: 1,
      row-gutter: par.leading,
      ..lines.zip(realigned).map(((line, realigned)) => {
        let data = get-metadata(line)
        let numbering = numbering.with(eq.numbering)

        // Whether to show a number for this line at all.
        let show-number = (
          (number-mode == "label" and data.label-number != none) or
          (number-mode == "line" and data.line-number != none)
        )

        let numbering = if show-number {
          // Determine which number to show based on the number mode.
          let second-number = if number-mode == "label" {
            data.label-number
          } else {
            data.line-number
          }

          // Construct the actual number(s) to show.
          let number = if sub-numbering {
            numbering(..data.main-number + if lines.len() > 1 { (second-number,) })
          } else {
            numbering(data.main-number.first() + second-number - 1)
          }

          (..) => number
        }

        revoked(numbering: numbering, realigned.join())

        if sub-numbering and show-number {
          // We need to step back the counter when a sub-number is shown, as
          // the main number should not be incremented then.
          counter(math.equation).update(n => n - 1)
        }
      })
    )
  }
}

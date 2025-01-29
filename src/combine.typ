#import "common.typ": equate-state
#import "line.typ": to-lines, numbered

#let combine-state = state("equate/combine", (:))
#let combine-counter = counter("equate/combine/counter")
#let combine-sub-state() = {
  let num = combine-counter.get().first()
  state("equate/combine/" + str(num), (lines: (), numbered: false))
}

// Retrieve all lines from the current combine-block that should be considered
// during alignment.
#let combined-lines() = {
  if not combine-state.get().at("align", default: false) {
    return ()
  }
  combine-sub-state().final().lines
}

// Combine multiple equations into a single equation.
//
// All equations inside this block will be "combined" into a single equation.
// This means that alignment points and (sub-)numbering can be shared across
// equations (if enabled).
#let combine(body, align: true, numbering: false) = context {
  assert(combine-state.get() == (:), message: "nested combine not supported")
  assert(
    equate-state.get().len() > 0,
    message: "combine block requires the equate rules to be enabled"
  )
  
  combine-counter.step()
  combine-state.update((align: align, numbering: numbering))

  let (sub-numbering, number-mode) = equate-state.get().last()

  show math.equation.where(block: true): it => {
    if it.has("label") and it.label == <equate:revoke> { return it }

    // Push the lines of the current equation into the alignment state.
    let lines = to-lines(it)
    combine-sub-state().update(state => (
      lines: state.lines + lines,
      numbered: state.numbered or lines.any(line => {
        numbered(line, number-mode, it)
      })
    ))

    it

    if (number-mode == "block" or sub-numbering) and not numbering {
      // If numbering is not shared, update the counters at the end of each
      // equation, so that the main number is increased for the next equation.
      counter(math.equation).step()
      counter("equate/line").update(0)
    }
  }

  body

  // If numbering is shared, only update the counters at the end of the block
  // after all equations with the same main number have been processed.
  if (number-mode == "block" or sub-numbering) and numbering {
    // Don't step when no numbered equation in block
    context if combine-sub-state().final().numbered {
      counter(math.equation).step()
    }
    counter("equate/line").update(0)
  }
  
  combine-state.update((:))
}
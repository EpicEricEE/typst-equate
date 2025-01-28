#import "common.typ": equate-state
#import "process.typ": to-lines

#let combine-state = state("equate/combine", (:))
#let combine-counter = counter("equate/combine/counter")

// Retrieve all lines from the current combine-block that should be considered
// during alignment.
#let combined-lines() = {
  if not combine-state.get().at("align", default: false) {
    return ()
  }
  let num = combine-counter.get().first()
  let lines-state = state("equate/combine/" + str(num), ())
  lines-state.final()
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
    let num = combine-counter.get().first()
    state("equate/combine/" + str(num)).update(l => l + lines)

    it

    if sub-numbering and not numbering {
      // If numbering is not shared, update the counters at the end of each
      // equation, so that the main number is increased for the next equation.
      counter(math.equation).step()
      counter("equate/line").update(0)
    }
  }

  body

  combine-state.update((:))

  // If numbering is shared, only update the counters at the end of the block
  // now that all equations have been processed.
  if sub-numbering and numbering {
    // TODO: Don't step when no numbered equation in block
    counter(math.equation).step()
    counter("equate/line").update(0)
  }
}
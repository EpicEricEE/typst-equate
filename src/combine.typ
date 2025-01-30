#let combine-state = state("equate/combine", (:))
#let combine-counter = counter("equate/combine/counter")

// Get the state of the current combine state.
#let combine-sub-state() = {
  if combine-state.get() == (:) { return none }
  let num = combine-counter.get().first()
  state("equate/combine/" + str(num), ())
}

// Get all equations in the current combine block.
#let combined-equations() = {
  let state = combine-sub-state()
  if state == none { return () }
  state.final()
}

// Combine multiple equations into a single equation.
//
// All equations inside this block will be "combined" into a single equation.
// This means that alignment points and (sub-)numbering can be shared across
// equations (if enabled).
#let combine(body, align: true, numbering: false) = context {
  assert(combine-state.get() == (:), message: "nested combine not supported")
  
  combine-counter.step()
  combine-state.update((align: align, numbering: numbering))

  show math.equation.where(block: true): it => {
    if it.has("label") and it.label == <equate:revoke> { return it }
    combine-sub-state().update(state => state + (it,))
    it
  }

  body
  
  combine-state.update((:))
}

#import "common.typ": combine-state

// Any block equation inside this block will conceptually be combined into a
// single equation. This means that alignment points will be shared across
// equations, and the main number will be shared if sub-numbering is enabled.
// 
// Requires the equate show rule to be enabled.
#let combine(
  /// Whether equations in this block should share the same main number.
  sub-numbering: false,
  /// The content whose equations should be combined.
  body
) = {
  combine-state.update(((stack, max)) => (
    stack: stack + (max + 1,),
    max: max + 1,
  ))

  show math.equation.where(block: true): it => {
    // Don't apply the rule to revoked equations.
    if it.has("label") and it.label == <equate:revoke> { return it }

    let num = combine-state.get().stack.last()
    let lines-state = state("equate/combine/" + str(num), ())
    lines-state.update(lines => lines + to-lines(it))

    it

    if sub-numbering and it.numbering != none {
      // Step back numbering to continue with the same main number.
      counter(math.equation).update(n => n - 1)
    }
  }

  body
  
  combine-state.update(((stack, max)) => (
    stack: stack.slice(0, 1),
    max: max,
  ))
}

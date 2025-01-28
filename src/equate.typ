#import "common.typ": nesting-state, setting-state
#import "layout.typ": layout-equation
#import "reference.typ": reference

/// Applies show rules to the given body, so that block equations can span over
/// page boundaries while retaining alignment. The equation number is stepped
/// and displayed at every line, optionally with sub-numbering
#let equate(
  /// Whether individual lines should be numbered separately.
  sub-numbering: false,
  /// How equations or lines should be numbered. Must be either "line", "label",
  /// or "block".
  number-mode: "line",
  /// The content whose equations should be affected by this package.
  body
) = {
  // Validate parameters.
  assert.eq(type(sub-numbering), bool, message: "`sub-numbering` must be a boolean")
  assert(
    number-mode in ("line", "label", "block"),
    message: "`number-mode` must be one of \"line\", \"label\", or \"block\""
  )

  // Store settings in state so they can be accessed in references.
  // We are using a stack so that the settings can be restored after a nested
  // equate call. The last element is popped off after the body is processed.
  setting-state.update(stack => stack + ((
    sub-numbering: sub-numbering,
    number-mode: number-mode,
  ),))

  // Allow passing a label or a reference to the equate function to allow
  // manually applying the "equate-ref" show rule on references.
  if type(body) == label {
    return {
      show ref: reference
      ref(body)
    }
  } else if body.func() == ref {
    return {
      show ref: reference
      body
    }
  }

  show math.equation.where(block: true): it => {
    // Don't apply the rule to revoked equations.
    if it.has("label") and it.label == <equate:revoke> { return it }
    // Don't apply the rule to nested equations.
    if nesting-state.get() > 0 { return it }
    // Don't apply the rule to non-numbered equations.
    if it.numbering == none { return it }

    // Prevent show rules on figures from messing with replaced labels.
    show figure.where(kind: math.equation): it => {
      if it.body == none { return it }
      if it.body.func() != metadata { return it }
    }

    layout-equation(
      sub-numbering: sub-numbering,
      number-mode: number-mode,
      it
    )
  }

  // Update nesting level and disable numbering for nested equations.
  // This show rule has to be applied first, as the equation does not exist
  // anymore after the above show rule is applied.
  show math.equation.where(block: true): it => {
    set math.equation(numbering: none)
    nesting-state.update(n => n + 1)
    it
    nesting-state.update(n => n - 1)
  }

  // Apply the show rule for references, so it works with sub-numbering.
  show ref: reference

  body

  // Pop current settings from the stack.
  setting-state.update(stack => stack.slice(0, -1))
}

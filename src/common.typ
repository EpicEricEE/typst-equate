#let equate-state = state("equate/settings", ())

#let sequence = [].func()

/// A block equation with the revoke label attached to it.
#let revoked(..args) = {
  if args.pos() == () {
    args = arguments(..args.named(), body: none)
  }
  [#math.equation(block: true, numbering: none, ..args) <equate:revoke>]
}

/// Check whether a line should be numbered.
#let numbered(line, number-mode, outer-label) = {
  let (.., revoked, label) = line
  (
    (number-mode == "block") or
    (number-mode == "line" and not revoked) or
    (number-mode == "label" and (label != none or (outer-label and not revoked)))
  )
}

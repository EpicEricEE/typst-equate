#let equate-state = state("equate/settings", ())

#let sequence = [].func()

/// A block equation with the revoke label attached to it.
#let revoked(..args) = {
  if args.pos() == () {
    args = arguments(..args.named(), body: none)
  }
  [#math.equation(block: true, numbering: none, ..args) <equate:revoke>]
}

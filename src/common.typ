#let combine-state = state("equate/combine", (stack: (), max: 0))
#let nesting-state = state("equate/nesting-level", 0)
#let setting-state = state("equate/settings", ())

#let sequence = [].func()

/// A block equation with the revoke label attached to it.
#let revoked(..args) = {
  if args.pos() == () {
    args = arguments(..args.named(), body: none)
  }
  [#math.equation(block: true, ..args) <equate:revoke>]
}

/// Extract the lines of an equation and trim spaces.
#let to-lines(equation) = {
  let lines = if equation.body.func() == sequence {
    equation.body.children.split(linebreak())
  } else {
    ((equation.body,),)
  }

  // Trim spaces at start and end of line.
  let lines = lines.map(line => {
    if line.at(0, default: none) == [ ]  { line = line.slice(1) }
    if line.at(-1, default: none) == [ ] { line = line.slice(0, -1) }
    line
  })

  lines
}

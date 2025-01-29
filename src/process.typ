// Split the body of an equation into lines if it is a multi-line equation.
// Otherwise, return the body as a single line.
#let to-lines(eq) = {
  let lines = if eq.body.func() == [].func() {
    eq.body.children.split(linebreak())
  } else {
    ((eq.body,),)
  }

  // Trim spaces at start and end of line.
  let lines = lines.map(line => {
    if line.at(0, default: none) == [ ]  { line = line.slice(1) }
    if line.at(-1, default: none) == [ ] { line = line.slice(0, -1) }
    line
  })

  lines
}

#let numbered(line, number-mode, outer-label) = {
  let (.., revoked, label) = line
  return (
    (number-mode == "block") or
    (number-mode == "line" and not revoked) or
    (number-mode == "label" and (label != none or (outer-label and not revoked)))
  )
}

/// Extract the "real" label from an equation line (if any) and returns the
/// line without the label, and the extracted label itself.
#let process-line(line) = {
  if (
    line == ()
    or type(line.last()) != content
    or line.last().func() != raw
    or line.last().lang != "typc"
    or line.last().text.match(regex("^<(.+)>$")) == none
  ) {
    return (
      body: line,
      revoked: false,
      label: none
    )
  }

  // Remove the original label and any trailing space.
  let label = label(line.pop().text.slice(1, -1))
  let _ = if line.at(-1, default: none) == [ ] { line.pop() }

  (
    body: line,
    revoked: label == <equate:revoke>,
    label: if label != <equate:revoke> { label },
  )
}

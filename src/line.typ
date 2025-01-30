#import "combine.typ": combined-equations

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

  lines.map(process-line)
}

/// Return whether a given line should be numbered based on the numbering mode
/// and the line's properties.
#let numbered(line, number-mode, parent) = {
  if parent.numbering == none { return false }

  let (.., revoked, label) = line
  if number-mode == "block" {
    // In block numbering mode, only the parent equation is numbered, thus we
    // consider all lines as numbered.
    return true
  }

  if number-mode == "line" {
    return not revoked
  }

  if number-mode == "label" {
    let combined = (combined-equations() + (parent,))
    let lines = combined.map(to-lines).flatten()
    let has-label = combined.any(eq => eq.has("label"))
    return (
      // Always number if this line has a label.
      label != none
      // Number if no other line has a label, but there is an outer label.
      or (has-label and not revoked and lines.all(line => line.label == none))
    )
  }

  false
}

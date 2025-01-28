/// Extract the "real" label from an equation line (if any) and returns the
/// line without the label, and the extracted label itself.
#let extract-label(line) = {
  if line == () { return (line, none) }
  if type(line.last()) != content { return (line, none) }
  if line.last().func() != raw { return (line, none) }
  if line.last().lang != "typc" { return (line, none) }
  let match = line.last().text.match(regex("^<(.+)>$"))
  if match == none { return (line, none) }

  // Remove the original label and any trailing space.
  let _ = line.pop()
  let _ = if line.at(-1, default: none) == [ ] { line.pop() }

  (line, label(match.captures.first()))
}

/// Replace labels in the given equation lines with appropriately labeled
/// hidden figures to allow for referencing.
#let process(
  numbering: none,
  supplement: auto,
  consider: (),
  lines,
) = {
  let labels = lines.enumerate().map(((i, line)) => (i, ..extract-label(line)))

  // Keep track of label number and line number, as they aren't always stepped.
  // TODO: Get starting values from shared alignment state.
  let line-number = 1
  let label-number = 1

  for (i, line, label) in labels {
    // We store all number information in a (hidden) figure, so that we can
    // retrieve it later and use it for referencing.
    let figure = figure(
      kind: math.equation,
      numbering: numbering,
      supplement: supplement,
      metadata((
        main-number: counter(math.equation).get(),
        line-number: if label != <equate:revoke> { line-number },
        label-number: if label not in (none, <equate:revoke>) { label-number },
      ))
    )

    if label not in (none, <equate:revoke>) {
      figure = [#figure#label]
      label-number += 1
    }

    if label != <equate:revoke> {
      line-number += 1
    }

    lines.at(i) = (..line, figure)
  }

  lines
}

/// Get the metadata of a labeled equation line.
#let get-metadata(line) = line.last().body.value

/// Check if an equation line is labeled with a hidden figure.
#let is-labeled(line) = get-metadata(line).label-number != none

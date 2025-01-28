#import "common.typ": revoked

#let align-point = $&$.body.func()

/// Measures the width of the given slice of a line.
#let width(slice) = measure(revoked(slice.join())).width

/// Realigns the given equation lines by emulating the inbuilt alignment
/// algorithm with interspersed horizontal spacings.
#let realign(
  /// Additional lines whose alignment points should be considered.
  consider: (),
  /// The lines to realign.
  lines
) = {
  let lines = consider + lines

  // Short-circuit if no alignment points.
  if lines.all(line => align-point() not in line) {
    return lines.slice(consider.len())
  }

  // Split lines into a fixed-width grid, padding rows with empty content.
  let rows = {
    let rows = lines.map(line => line.split(align-point()))
    let total-columns = calc.max(..rows.map(array.len))
    rows.map(row => row + ((),) * (total-columns - row.len()))
  }

  let columns = array.zip(..rows, exact: true)
  let column-widths = columns.map(column => calc.max(..column.map(width)))
  let multi-column-widths = range(1, columns.len()).map(i => {
    let rows = array.zip(..columns.slice(0, i + 1), exact: true)
    calc.max(..rows.map(row => width(row.join())))
  })

  // Add spacers so that the all cells in a column have the same width.
  rows = rows.map(row => row.enumerate().map(((i, cell)) => {
    let delta = column-widths.at(i) - width(cell)
    let spacer = if delta > 0pt { h(delta) }
    // Align content right or left depending on the column index.
    if calc.even(i) { (spacer, ..cell) } else { (..cell, spacer) }
  }))

  // Update multi-column widths to include spacers. If the new width is smaller
  // than before, keep the larger width to ensure correct spacing.
  columns = array.zip(..rows, exact: true)
  multi-column-widths = range(1, columns.len()).map(i => {
    let rows = array.zip(..columns.slice(0, i + 1), exact: true)
    calc.max(..rows.map(row => calc.max(multi-column-widths.at(i - 1), width(row.join()))))
  })

  // Add more spacers so that all slices of multiple cells have the same width.
  rows = rows.map(row => {
    for i in range(2, columns.len()) {
      let multi-cell = (..row.slice(0, i).join(), h(0pt), ..row.at(i))
      let delta = multi-column-widths.at(i - 1) - width(multi-cell)
      if delta > 0pt {
        // Always add spacer to the left of the cell content, as we only want
        // to fix the spacing between this cell and the previous one.
        row.at(i) = (h(delta), ..row.at(i))
      }
    }
    row
  })

  // Rejoin the rows to form lines, and skip the lines that were only added to
  // consider shared alignment blocks.
  rows.slice(consider.len()).map(row => row.join())
}

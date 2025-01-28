#import "common.typ": setting-state

/// Counting symbols recognized in numbering patterns.
#let counting-symbols = (
  "1", "a", "A", "i", "I", "一", "壹", "あ", "い",
  "ア", "イ", "א", "가", "ㄱ", "*", "①", "⓵"
)

/// Show rule necessary for referencing equation lines, as the number is not
/// stored in a counter, but as metadata in a figure.
#let reference(it) = {
  if it.element == none { return it }
  if it.element.func() != figure { return it }
  if it.element.kind != math.equation { return it }
  if it.element.body == none { return it }
  if it.element.body.func() != metadata { return it }
  
  assert(
    it.element.numbering != none,
    message: "cannot reference equation without numbering."
  )

  // Retrieve settings at the equation's location.
  let (sub-numbering, number-mode) = setting-state.at(it.element.location()).last()
  let data = it.element.body.value
  let numbering = it.element.numbering

  // Display correct number, depending on whether sub-numbering was enabled.
  let second-number = if number-mode == "label" {
    data.label-number
  } else {
    data.line-number
  }

  let nums = if sub-numbering {
    (..data.main-number, second-number)
  } else {
    (data.main-number.first() + second-number - 1,)
  }

  let num = std.numbering(
    if type(numbering) == function { numbering } else {
      // Trim numbering pattern of prefix and suffix characters.
      let prefix-end = numbering.codepoints().position(c => c in counting-symbols)
      let suffix-start = numbering.codepoints().rev().position(c => c in counting-symbols)
      numbering.slice(prefix-end, if suffix-start == 0 { none } else { -suffix-start })
    },
    ..nums
  )

  let supplement = if it.supplement == auto {
    it.element.supplement
  } else if type(it.supplement) == function {
    (it.supplement)(it.element)
  } else {
    it.supplement
  }

  link(
    it.element.location(),
    if supplement not in ([], none) [#supplement~#num] else [#num]
  )
}

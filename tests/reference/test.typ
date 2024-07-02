#import "/src/lib.typ": equate

#set page(width: 6cm, height: auto, margin: 1em)
#show: equate.with(sub-numbering: true)

// Test references to equations with sub-numbering

#set math.equation(numbering: "(1.1)")

$ a + b \
  c + d \
  e + f $ <outer>

$ a + b \
  c + d #<inner> \
  e + f $

#show: equate.with(sub-numbering: false)

$ a + b \
  c + d #<no-sub> \
  e + f $

#show: equate.with(number-mode: "label")

$ a + b \
  c + d #<labelled> \
  e + f $

@outer, @inner, @no-sub, @labelled

See @inner[] and @outer[eq.]

#set ref(supplement: it => {
  if it.label == <inner> {
    "Subequation"
  } else {
    "Equation"
  }
})

@inner, @outer

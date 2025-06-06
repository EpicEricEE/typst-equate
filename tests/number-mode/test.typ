#import "../../src/lib.typ": equate

#set page(width: 6cm, height: auto, margin: 1em)
#show: equate.with(number-mode: "label")

// Test correct counter incrementation with number-mode "label".

#set math.equation(numbering: "(1.1)")

$ a + b #<label> $

$ c + d \
  e + f #<label> \
  g + h \
  i + j #<label> $

$ k + l $

#set math.equation(numbering: "(1a)")

$ m + n \
  o + p $ <label>

$ q + r #<label> \
  s + t $ <label>

$ u + v \
  w + x $ <equate:revoke>

$ y + z \
  1 + 2 #<equate:revoke> \
  3 + 4 $ <label>

#show: equate.with(sub-numbering: true, number-mode: "label")

#set math.equation(numbering: "(1.1)")

$ a + b $ <label>

$ a + b_0 #<label> $

$ c + d \
  e + f #<label> \
  g + h \
  i + j #<label> $

$ k + l $

#set math.equation(numbering: "(1a)")

$ m + n \
  o + p $ <label>

$ q + r #<label> \
  s + t $ <label>

$ u + v \
  w + x $ <equate:revoke>

$ y + z \
  1 + 2 #<equate:revoke> \
  3 + 4 $ <label>

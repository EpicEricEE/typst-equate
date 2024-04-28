#import "/src/lib.typ": equate

#set page(width: 6cm, height: auto, margin: 1em)
#show: equate

// Test correct counter incrementation.

#set math.equation(numbering: "(1.1)")

$ a + b $

$ c + d \
  e + f $

$ g + h $

#set math.equation(numbering: "(1a)")

$ i + j \
  k + l $

$ m + n \
  o + p $ <equate:revoke>

#show: equate.with(sub-numbering: true)

#set math.equation(numbering: "(1.1)")

$ a + b $

$ c + d \
  e + f $

$ g + h $

#set math.equation(numbering: "(1a)")

$ i + j \
  k + l $

$ m + n \
  o + p $ <equate:revoke>

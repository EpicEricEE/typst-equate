#import "/src/lib.typ": equate
#import "/tests/template.typ": template

#show: template
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

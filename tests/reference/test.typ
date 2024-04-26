#import "/src/lib.typ": equate
#import "/tests/template.typ": template

#show: template
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

@outer, @inner, @no-sub

See @inner[] and @outer[eq.]

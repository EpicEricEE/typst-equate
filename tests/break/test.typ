#import "/src/lib.typ": equate
#import "/tests/template.typ": template

#show: template
#show: equate

// Test equations breaking across page boundaries.

#set page(height: 2cm)

$ a + b \
  c - d \
  e + f \
  g = h $

$ a &= b \
    &= d \
    &= f \
  g &= h $

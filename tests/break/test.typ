#import "/src/lib.typ": equate

#set page(width: 6cm, height: auto, margin: 1em)
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

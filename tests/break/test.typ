#import "/src/lib.typ": equate

#set page(width: 6cm, height: 2cm, margin: 1em)
#show: equate

// Test equations breaking across page boundaries.

#show math.equation: set block(breakable: true)

$ a + b \
  c - d \
  e + f \
  g = h $

$ a &= b \
    &= d \
    &= f \
  g &= h $

// Test breakable parameter.

#equate(breakable: false, $
  a + b \
  c - d \
  e + f \
  g = h
$)

#show math.equation: set block(breakable: false)

$ a + b \
  c - d \
  e + f \
  g = h $


#equate(breakable: true, $
  a + b \
  c - d \
  e + f \
  g = h
$)

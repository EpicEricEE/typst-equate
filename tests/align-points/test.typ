#import "/src/lib.typ": equate
#import "/tests/template.typ": template

#show: template
#show: equate

#set page(width: 8cm)

// Test re-implemented alignment algorithm.

$ a + b &= c \
        &= d + e $

$ a + b &= c + d &= e + f \
      g &=       &    + h $

$ a + b &= c + d &&= e + f \
      g &        &&= h $

$ a + b &= c \
      d &    &= e + f $

// Cases below taken from Typst test suite.

$ "a" &= c \
      &= c + 1          & "By definition" \
      &= d + 100 + 1000 \
      &= x              &                 & "Even longer" \
$

$                    & "right" \
  "a very long line" \
  "left" $

$ "right" \
  "a very long line" \
  "left" \ $

$ a &= b & quad c &= d \
  e &= f &      g &= h $

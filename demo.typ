#import "src/equate.typ": *

#set page(height: 4cm)

#set math.equation(numbering: "(1.1)")
#show math.equation.where(block: true): set block(breakable: true)
#show: equate.with(number-mode: "block", sub-numbering: true)

$ a $ <outer>

#lorem(5) \
#lorem(5)

$ a + b &= c +& d &= e \
      f &= g  &   &= h \
     2i &     &   &= i + j \
        &     & j &= i $ <total>

@total

#import "/src/lib.typ": equate
#import "/tests/template.typ": template

#show: template
#show: equate

// Test number positioning with different page margins.

#set math.equation(numbering: "(1)")

#for side in ("left", "right", "x", "inside", "outside") {
  page(margin: ((side): 2cm))[
    $ a + b $

    #set math.equation(number-align: start)
    $ a + b $

    #set text(dir: rtl)
    $ a + b $
  ]
}

// Test break over pages with different margins.

#set page(margin: (inside: 2cm), height: 2cm)

$ a + b \
  c + d \
  e + f \
  g + h $

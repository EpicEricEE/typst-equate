#import "/src/lib.typ": equate

#set page(width: 6cm, height: auto, margin: 1em)
#show: equate

// Test equation sizing when given constraints.

// Unnumbered
#block(width: 50%, fill: yellow, $ a + b $)
#block(width: 50%, fill: yellow, $ c + d \ e + f $)

#h(1cm) #box(width: 40%, fill: yellow, $ g + h $)

#h(1cm) #box(fill: yellow, $ g + h $)

// Numbered
#set math.equation(numbering: "(1)")

#block(width: 50%, fill: yellow, $ a + b $)
#block(width: 50%, fill: yellow, $ c + d \ e + f $)

#h(1cm) #box(width: 40%, fill: yellow, $ g + h $)

#h(1cm) #box(fill: yellow, $ g + h $)

// Columns
#block(height: 2cm, columns(2)[
  $ a + b \
    c + d \
    e + f \
    g + h \
    i + j $
])

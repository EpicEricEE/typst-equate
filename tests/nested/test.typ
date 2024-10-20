#import "/src/lib.typ": equate

#set page(width: 6cm, height: auto, margin: 1em)
#show: equate

// Test handling of nested equations.

$ a + b &= lr(\{#block[$ e \ #block[$ f \ g $] $]) $

#set math.equation(numbering: "(1.1)")

$ a + b &= c \
        &= lr(\{#block[$ e \ f $] + #block[$ g \ h $]) $

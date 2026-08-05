#import "/src/lib.typ": equate

#set page(width: 6cm, height: auto, margin: 1em)
#show: equate

// Test handling of nested equations.

// Workaround for https://github.com/typst/typst/issues/8516
#let centered = box.with(baseline: -50%+0.192em)

$ a + b &= lr(\{#centered[$ e \ #centered[$ f \ g $] $]) $

#set math.equation(numbering: "(1.1)")

$ a + b &= c \
        &= lr(\{#centered[$ e \ f $] + #centered[$ g \ h $]) $

#let vst = $v &= v_0 + a t$
$ vst \
  &= 0 + 9.81 dot 2 $

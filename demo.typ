#import "src/equate.typ": *

#set math.equation(numbering: "(1.1)")
#show: equate.with(number-mode: "block")

#combine(numbering: true)[
  Let's start with some content...
  $ &y + b $
  _Look, there's a normal paragraph inbetween, but the alignment *and* numbering continues!_
  $ &x^2 + y \
    &22x - v = 22z $ <a>
]

Now the combined equation is done, and we're "back to the root"

$ e^2 = 0 $

$ e^2 &= 0 \ 1+1 &= 2 $ <y>

$ e^2 = 0 $ <z>

#outline(target: figure.where(kind: math.equation))

$ a &= b           &        &=i            \
    &= cases(a, b) &+ x y z &= x $

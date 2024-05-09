#import "/src/lib.typ": equate

#set page(width: 6cm, height: auto, margin: 1em)
#set math.equation(numbering: "(1)")

$ a + b \
  c + d $

#equate($
  d + e \
  f + g #<lbl>
$)

@lbl (wrong)

#equate(<lbl>) (correct)

#[
  #show ref: equate
  @lbl (correct)
]

#[
  #show: equate
  @lbl (correct)
]
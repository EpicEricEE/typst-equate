#import "/src/lib.typ": equate, share-align

#set page(width: 6cm, height: auto, margin: 1em)
#show: equate

#share-align[
  $ a + b &= c $
  leads to
  $     c &= b - a $
]

#set math.equation(numbering: "(1.1)")

#share-align[
  $ x + y + z &= w \
        t &= x $

  #figure(
    rect[I interrupt], caption: [Caption]
  )

  $ &= w - u $
]

#import "/src/lib.typ": equate, share-align

#set page(width: 6cm, height: auto, margin: 1em)
#show: equate

// Test correct behavior of shared alignment blocks.

#share-align[
  $ a + b &= c $
  leads to
  $     c &= b - a $
]

#line(length: 100%)

// Test nested shared alignment blocks.

#share-align[
  $ a + b &= c + d $
  Blah blah blah. intertext blah.
  $ a^2 + b^2 &= c^2 $

  $ a + b &= c + d \
    a^2 + b^2 &= c^2 $ <equate:revoke>

  #share-align[
    $ a &= b \
        &= c $
    And because of how `c`'s tend to behave, we then have
    $   &= d $
  ]

  And back to the start
  $ a^n + b^n + c^n &= d^n $
] 

#line(length: 100%)

// Test with numbering.

#set math.equation(numbering: "(1.1)")

#share-align[
  $ x + y + z &= w \
        t &= x $

  #figure(
    rect[I interrupt], caption: [Caption]
  )

  $ &= w - u $
]

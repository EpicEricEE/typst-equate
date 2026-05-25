#import "/src/lib.typ": equate

#set page(width: 6cm, height: auto, margin: 1em)
#set math.equation(numbering: "(1.1)")
#show: equate.with()

// Test stretching
$ abs(vec(a, b)) $
$ norm(vec(a, b)) $
$ lr(chevron.l vec(a, b) chevron.r) $
$ [vec(a, b)] $
$ {vec(a, b) mid(|) a, b in RR} $


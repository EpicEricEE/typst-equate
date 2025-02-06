#import "/src/lib.typ": equate

#set page(width: 6cm, height: auto, margin: 1em)
#show: equate.with(sub-numbering: true)

// Test line numbering with (multi-line) lr elements.

#set math.equation(numbering: "(1.1)")

$ () $
$ (x + y] $
$ lr([x + y]) $
$ lr(1/2|) $

$ a + (b + c) $
$ a + (b + c \
       d + e) $
$ a + (b +& c #<equate:revoke> \
       d +& 1/2 ) $
$ a + lr(size: #1cm, (b +& c mid(|) \
       mid(|) d +& e)) $

$ a + lr(size: #1cm, (b +& c mid(|) \
       mid(|) d +& e)) + f $

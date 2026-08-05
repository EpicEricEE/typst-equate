#import "/src/lib.typ": equate

#set page(width: 6cm, height: auto, margin: 1em)
#show: equate.with(sub-numbering: true)

// Test reference with context-dependent equation numbering.

#set heading(numbering: "1.")
#set math.equation(supplement: none, numbering: (..nums) => {
  numbering("(1.1a)", counter(heading).get().first(), ..nums)
})

= The Reference
See @test and @test-line.

= The Equation
$ x + y = z #<test-line> $ <test>

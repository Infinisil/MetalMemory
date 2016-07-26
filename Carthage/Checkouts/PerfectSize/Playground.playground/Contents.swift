import PerfectSize

//:# PerfectSize
//: Ever wanted to have a type with an exact size? Me neither! But now you can!
//:
//:## Usage
//: Say you want a type that has a size of 9001 bytes, which is clearly over 9000, so it'd take a long time to figure out how to get *exactly* 9001. With this framework it's as simple as:

typealias OVER9000 = D.n9.n0.n0.n1

//:This type has now really a size of over 9000:

sizeof(OVER9000.self)

//:You can also use binary, which doesn't need the ugly characters inbetween the numbers:

typealias MeaningOfLife = B.I.O.I.O.I.O

//:There is a single initializer for every such type which takes a byte value (`UInt8`) with a default value of `0`:

let powerlevel = OVER9000() // All zeroes
let life = MeaningOfLife(byte: 0b00101010)  // Every byte is set to the answer

//:## What can I use this for?
//:Here is the complete list of potential usages for this:
//: - Use `unsafeBitCast` to convert this type to some other type
//: - (TODO)

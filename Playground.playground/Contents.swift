@testable import MetalMemory

var a = GlobalUniform<Int>()

a.value
a.value = 10
a.value

var b = GlobalUniform<Bool>()



b.value
b.value = true
b.value



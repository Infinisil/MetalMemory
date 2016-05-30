//: Playground - noun: a place where people can play

@testable import MetalMemory


var a = GlobalUniform<Int>()

a.memory
a.memory = 10
a.memory

globalMemory.bytes
globalMemory.mem.pointer

var b = GlobalUniform<Bool>()


globalMemory.bytes


globalMemory.mem.pointer.advancedBy(9)


b.memory
b.memory = true
b.memory
import Foundation


class BitVector {

    let bitVector: CFMutableBitVector
    
    init(capacity: Int) {
        self.bitVector = CFBitVectorCreateMutable(nil, CFIndex(capacity))
    }

    var count: Int {
        return CFBitVectorGetCount(self.bitVector)
    }

    func append(bits: [Bool]) {
        let count = CFBitVectorGetCount(self.bitVector)
        CFBitVectorSetCount(self.bitVector, count + bits.count)
        for index in 0 ..< bits.count {
            CFBitVectorSetBitAtIndex(self.bitVector, count + index, CFBit(bits[index]))
        }
    }

    subscript(index: Int) -> Bool {
        get {
            assert(index >= 0 && index < CFBitVectorGetCount(self.bitVector))
            let bitValue = CFBitVectorGetBitAtIndex(bitVector, index)
            return !(bitValue == 0)
        }
        set {
            if index > CFBitVectorGetCount(self.bitVector) {
                CFBitVectorSetCount(self.bitVector, index + 1)
            }
            CFBitVectorSetBitAtIndex(bitVector, index, CFBit(newValue))
        }
    }

    subscript(range: NSRange) -> [Bool] {
        get {
            var bitValues = [Bool]()
            for index in range.location ..< NSMaxRange(range) {
                let bit = CFBitVectorGetBitAtIndex(bitVector, CFIndex(index))
                bitValues.append(bit != 0)
            }
            return bitValues
        }
    }

    func setBitsAtIndex(index: Int, bits: [Bool]) {
        let count = CFBitVectorGetCount(self.bitVector)
        if index + bits.count > count {
            CFBitVectorSetCount(self.bitVector, index + bits.count)
        }

        for offset in 0 ..< bits.count {
            CFBitVectorSetBitAtIndex(bitVector, index + offset, CFBit(bits[offset]))
        }
    }

    func data() -> NSData {
        let counts = Int(CFBitVectorGetCount(self.bitVector))
        assert(CFBitVectorGetCount(self.bitVector) > 0)
        let bytes = Int(ceil((Double(counts) / 8.0)))
        let data = NSMutableData()
        for index in 0 ..< bytes {
            let range = CFRange(location: CFIndex(index * 8), length: 8)
            var bits: UInt8 = 0
            CFBitVectorGetBits(self.bitVector, range, &bits)
            data.append(&bits, length: 1)
        }
        return data
    }
    
    func containsBit(range: NSRange, value: Bool) -> Bool {
        return CFBitVectorContainsBit(self.bitVector, CFRange(range), CFBit(value))
    }
    
    func flipBitAtIndex(index: Int) {
        CFBitVectorFlipBitAtIndex(self.bitVector, index)
    }

    func setAllBits(value: Bool) {
        CFBitVectorSetAllBits(self.bitVector, CFBit(value))
    }

}

extension CFRange {
    init(_ range: NSRange) {
        self = CFRangeMake(range.location, range.length)
    }
}

extension CFBit {
    init(_ bool: Bool) {
        self = CFBit(bool ? 1 : 0)
    }
}

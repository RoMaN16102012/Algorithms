//
//  Array+OptimizedArgMaxMin.swift
//  Algorithms
//
//  Created by Roman Vovk on 12.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

import Foundation
import Accelerate

extension Array where Element == Double {
    public func argmax() -> Index? {
        var elem = 0.0
        var vdspIndex: vDSP_Length = 0
        vDSP_maxviD(self, 1, &elem, &vdspIndex, vDSP_Length(count))
        let idx = Index(vdspIndex)
        return idx
    }
    
    public func argmin() -> Index? {
        var elem = 0.0
        var vdspIndex: vDSP_Length = 0
        vDSP_minviD(self, 1, &elem, &vdspIndex, vDSP_Length(count))
        let idx = Index(vdspIndex)
        return idx
    }
}


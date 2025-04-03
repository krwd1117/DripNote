//
//  Unit.swift
//  DripNote
//
//  Created by 김정완 on 4/3/25.
//

import Foundation

extension Double {
    enum CustomUnit {
        case oz
        case floz
        case fahrenheit
        
        case g
        case ml
        case celcius
    }
    
    func convertTo(to: CustomUnit) -> Double {
        switch to {
        case .oz:
            return self * 0.03527396
        case .floz:
            return self * 0.033814
        case .fahrenheit:
            return (self * 1.8) + 32
        case .g:
            return self / 0.035274
        case .ml:
            return self / 0.033814
        case .celcius:
            return (self - 32) / 1.8
        }
    }
}

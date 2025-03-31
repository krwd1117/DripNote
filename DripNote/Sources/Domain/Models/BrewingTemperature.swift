//
//  BrewingTemperature.swift
//  DripNote
//
//  Created by 김정완 on 3/31/25.
//

import Foundation

public enum BrewingTemperature: String, Codable, CaseIterable, Hashable {
    case hot
    case ice
    
    public var displayName: String {
        switch self {
        case .hot: return "Hot"
        case .ice: return "Ice"
        }
    }
}

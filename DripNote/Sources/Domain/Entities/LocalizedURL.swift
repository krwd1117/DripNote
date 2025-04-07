//
//  LocalizedURL.swift
//  DripNoteDomain
//
//  Created by 김정완 on 4/7/25.
//

import Foundation

public struct LocalizedURL: Codable {
    private var kr: String?
    private var us: String?
    
    public func url() -> URL? {
        guard let urlString else { return nil }
        return URL(string: urlString)
    }
    
    private var urlString: String? {
        switch Locale.current.region?.identifier {
        case "KR":
            return kr
        case "US":
            return us
        default :
            return kr
        }
    }
}

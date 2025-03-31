import Foundation

public enum BrewingMethod: String, Codable, CaseIterable {
    case v60 = "V60"
    case kalita = "칼리타"
    case chemex = "케멕스"
    case aeropress = "에어로프레스"
    case frenchPress = "프렌치프레스"
    case siphon = "사이폰"
    case other = "기타"
    
    public var displayName: String {
        return self.rawValue
    }
} 

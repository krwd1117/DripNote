import Foundation
import FirebaseAnalytics

public enum AnalyticsEvent {
    case brewingToolShopClick(brewingMethod: String, storeURL: String)
    case coffeeBeansShopClick(coffeeName: String, storeURL: String)
    
    var name: String {
        switch self {
        case .brewingToolShopClick:
            return "brewing_tool_shop_click"
        case .coffeeBeansShopClick:
            return "coffee_beans_shop_click"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .brewingToolShopClick(let brewingMethod, let storeURL):
            return [
                "brewing_method": brewingMethod,
                "store_url": storeURL
            ]
        case .coffeeBeansShopClick(let coffeeName, let storeURL):
            return [
                "coffee_name": coffeeName,
                "store_url": storeURL
            ]
        }
    }
}

public final class AnalyticsManager {
    
    public init() {}
    
    public func logEvent(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}

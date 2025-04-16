import Foundation
import FirebaseRemoteConfig

public enum RemoteConfigError: Error {
    case fetchFailed
    case activateFailed
    case missingValue
}

public enum UnitID: String {
    case baristas_grid_cell_unit_id
    case barista_detail_unit_id
    case barsitas_detail_banner_unit_id
    case user_detail_unit_id
    case user_detail_banner_unit_id
    
    var testValue: String {
        switch self {
            // 네이티브 테스트 ID
        case .baristas_grid_cell_unit_id, .barista_detail_unit_id, .user_detail_unit_id:
            return "ca-app-pub-3940256099942544/3986624511"
            
            // 배너 테스트 ID
        case .barsitas_detail_banner_unit_id, .user_detail_banner_unit_id:
            return "ca-app-pub-3940256099942544/2934735716"
        }
    }
}

public func fetchRemoteConfig(type: UnitID) async throws -> String {
    #if DEBUG
    return type.testValue
    #endif
    
    let remoteConfig = RemoteConfig.remoteConfig()
    let status = try await remoteConfig.fetchAndActivate()
    
    guard status == .successFetchedFromRemote || status == .successUsingPreFetchedData else {
        throw RemoteConfigError.activateFailed
    }
    
    let adUnitID = remoteConfig.configValue(forKey: type.rawValue).stringValue
    
    guard !adUnitID.isEmpty else {
        throw RemoteConfigError.missingValue
    }

    return adUnitID
}

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
}

public func fetchRemoteConfig(type: UnitID) async throws -> String {
    #if DEBUG
        return "ca-app-pub-3940256099942544/3986624511" // Test Ad Unit ID
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

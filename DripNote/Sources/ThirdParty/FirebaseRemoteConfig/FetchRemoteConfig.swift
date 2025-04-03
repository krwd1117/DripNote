import Foundation
import FirebaseRemoteConfig

public enum RemoteConfigError: Error {
    case fetchFailed
    case activateFailed
    case missingValue
}

public func fetchRemoteConfig() async throws -> String {
    
    #if DEBUG
        return "ca-app-pub-3940256099942544/3986624511" // Test Ad Unit ID
    #endif
    
    let remoteConfig = RemoteConfig.remoteConfig()
    let status = try await remoteConfig.fetchAndActivate()

    guard status == .successFetchedFromRemote || status == .successUsingPreFetchedData else {
        throw RemoteConfigError.activateFailed
    }
    
    let adUnitID = remoteConfig.configValue(forKey: "native_ad_unit_id").stringValue
    
    guard !adUnitID.isEmpty else {
        throw RemoteConfigError.missingValue
    }

    return adUnitID
}

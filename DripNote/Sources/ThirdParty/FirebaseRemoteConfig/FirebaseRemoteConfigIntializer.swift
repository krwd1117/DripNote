import FirebaseRemoteConfig

public func initializeFirebaseRemoteConfig() {
    let remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 3600 // 1시간 캐시
    remoteConfig.configSettings = settings
}

public var formattedTime: String {
    let totalSeconds = Int(pourTime)
    let minutes = totalSeconds / 60
    let seconds = totalSeconds % 60
    
    return minutes > 0 
        ? String(format: String(localized: "Recipe.Time.MinutesAndSeconds"), minutes, seconds)
        : String(format: String(localized: "Recipe.Time.SecondsOnly"), seconds)
} 
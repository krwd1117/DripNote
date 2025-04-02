import SwiftUI
import WebKit
import YouTubeiOSPlayerHelper

struct YouTubePlayerView: UIViewRepresentable {
    let youtubeLink: URL
    
    var videoID: String? {
        return extractYouTubeID(from: youtubeLink)
    }
    
    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        let playerVars: [String: Any] = [
            "playsinline": 1,  // 인라인 재생
            "controls": 1,     // 컨트롤러 표시
            "autoplay": 0      // 자동재생 여부 (0: 비활성)
        ]
        if let videoID {
            playerView.load(withVideoId: videoID, playerVars: playerVars)
        }
        return playerView
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {}
}

// MARK: - URL에서 동영상 ID 추출 함수
fileprivate func extractYouTubeID(from url: URL) -> String? {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
        return nil
    }
    
    // 예시 1) https://www.youtube.com/watch?v=동영상ID
    if let queryItems = components.queryItems {
        for item in queryItems {
            if item.name == "v", let videoID = item.value {
                return videoID
            }
        }
    }
    
    // 예시 2) https://youtu.be/동영상ID
    if let host = components.host, host.contains("youtu.be") {
        let videoID = components.path.replacingOccurrences(of: "/", with: "")
        return videoID.isEmpty ? nil : videoID
    }
    
    return nil
}

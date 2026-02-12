import SwiftUI

struct WaveShape: Shape {
    var progress: CGFloat
    var waveHeight: CGFloat
    var phase: CGFloat
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let progressWidth = width * progress
        
        // 시작점을 오른쪽 하단에서 시작
        path.move(to: CGPoint(x: width, y: height))
        // 오른쪽 상단으로 이동
        path.addLine(to: CGPoint(x: width, y: 0))
        
        // 오른쪽에서 왼쪽으로 파동 모양 그리기
        for y in stride(from: 0, through: height, by: 2) {
            let relativeY = y / 50.0
            let sine = sin(relativeY + phase)
            let x = progressWidth + sine * waveHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        return path
    }
}

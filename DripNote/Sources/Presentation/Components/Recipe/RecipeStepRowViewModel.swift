import SwiftUI
import DripNoteDomain

final class RecipeStepRowViewModel<Step: BrewingStepProtocol>: ObservableObject {
    @AppStorage("useMetricVolume") private var useMetricVolume = true
    @Published private(set) var isTimerRunning: Bool = false
    @Published private(set) var remainingTime:Double = 0
    @Published private(set) var timer: Timer?
    @Published private(set) var wavePhase:CGFloat = 0
    @Published private var notificationCenter: UNUserNotificationCenter?
    
    @Published private(set) var step: Step
    
    init(step: Step) {
        self.step = step
    }
    
    var metricVolume: String {
        String(
            format: "%0.2f %@",
            useMetricVolume ? step.pourAmount : step.pourAmount.convertTo(to: .floz),
            String(localized: useMetricVolume ? "Unit.Milliliter" : "Unit.Floz")
        )
    }
    
    var seconds: String {
        String(
            format: String(localized: "Recipe.Time.SecondsOnly"),
            Int(remainingTime > 0 ? remainingTime : step.pourTime)
        )
    }
    
    var waveProgress: Double {
        remainingTime / step.pourTime
    }
    
    var showPourTime: Bool {
        return step.pourTime > 0
    }
    
    func toggleTimer() {
        remainingTime = step.pourTime
        wavePhase = 0
        
        if isTimerRunning {
            // 실행 중이면 중단
            timer?.invalidate()
            timer = nil
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if self.remainingTime > 0 {
                    // 남은 시간 감소
                    self.remainingTime -= 0.1
                } else {
                    // 남은 시간이 0에 도달
                    self.timer?.invalidate()
                    self.timer = nil
                    self.isTimerRunning = false
                    self.scheduleTimerNotification(after: 0.1)
                }
            }
        }
        
        isTimerRunning = !isTimerRunning
    }
    
    // 물결 애니메이션을 위한 수치 업데이트
    func updateWavePhase(value: CGFloat) {
        wavePhase = value
    }
    
    func removeNotificationCenter() {
        notificationCenter = nil
    }
    
    /// 타이머 종료 시 사용자에게 로컬 알림을 예약하는 함수입니다.
    private func scheduleTimerNotification(after timeInterval: TimeInterval) {
        notificationCenter = UNUserNotificationCenter.current()
        
        // 사용자에게 알림 권한 요청
        notificationCenter?.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, error in
            guard let self else { return }
            
            if granted {
                // 알림 내용 설정
                let content = UNMutableNotificationContent()
                content.title = "#\(self.step.pourNumber)번 째 푸어링이 끝났습니다."
                content.sound = .default
                
                // 지정한 시간 후 알림 트리거 설정 (타이머 시간에 맞춰 수정 가능)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                
                let request = UNNotificationRequest(identifier: "TimerFinished", content: content, trigger: trigger)
                
                // 알림 요청 추가
                notificationCenter?.add(request) { error in
                    if let error = error {
                        print("알림 추가 실패: \(error)")
                    }
                }
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }
    }
}

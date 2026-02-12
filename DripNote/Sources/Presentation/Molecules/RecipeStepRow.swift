import SwiftUI
import DripNoteDomain

public struct RecipeStepRow<Step: BrewingStepProtocol>: View {
    @StateObject var viewModel: RecipeStepRowViewModel<Step>
    
    public init(step: Step) {
        self._viewModel = StateObject(wrappedValue: RecipeStepRowViewModel(step: step))
    }
    
    /// 뷰의 UI를 구성하는 body 프로퍼티입니다.
    public var body: some View {
        ZStack(alignment: .leading) {
            // 기본 배경
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Custom.accentBrown.color.opacity(0.1))
            
            // 타이머 배경 및 진행률 표시
            if viewModel.isTimerRunning {
                GeometryReader { geometry in
                    WaveShape(
                        progress: viewModel.waveProgress,
                        waveHeight: 4,
                        phase: viewModel.wavePhase
                    )
                    .fill(Color.Custom.secondaryBackground.color.opacity(0.7))
                    .onAppear {
                        withAnimation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false)
                        ) {
                            viewModel.updateWavePhase(value: .pi * 2)
                        }
                    }
                }
            }
            
            // 컨텐츠 영역
            HStack(alignment: .center) {
                // 순서 번호
                Text("#\(viewModel.step.pourNumber)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color.Custom.darkBrown.color)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 6) {
                    // 물 양
                    Label {
                        Text(viewModel.metricVolume)
                            .font(.system(size: 14))
                    } icon: {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color.Custom.accentBrown.color.opacity(0.8))
                    }
                    .foregroundColor(Color.Custom.accentBrown.color)
                    
                    // 설명 텍스트 (있을 경우)
                    if !viewModel.step.desc.isEmpty {
                        Text(viewModel.step.desc)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                // 타이머 버튼 (푸어 시간이 있을 때)
                if viewModel.showPourTime {
                    
                    Spacer(minLength: 16)
                    
                    Button(action: {
                        viewModel.toggleTimer()
                    }) {
                        HStack(spacing: 4) {
                            Label {
                                Text(viewModel.seconds)
                                    .font(.system(size: 14, weight: .medium))
                            } icon: {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 12))
                            }
                            
                            Image(systemName: viewModel.isTimerRunning ? "stop.fill" : "play.fill")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(Color.Custom.accentBrown.color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.Custom.accentBrown.color.opacity(0.08))
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .frame(minHeight: 60)
        .cornerRadius(12)
        .shadow(
            color: Color.black.opacity(0.03),
            radius: 6,
            x: 0,
            y: 1
        )
        .onDisappear {
            viewModel.removeNotificationCenter()
        }
    }
}
#Preview {
    let step = BrewingStep(
        pourNumber: 1,
        pourAmount: 20,
        pourTime: 30,
        desc: "물을 천천히 부어주세요. 커피가 잘 추출되도록 중앙부터 시계방향으로 둥글게 부어주세요."
    )
    
    return VStack {
        RecipeStepRow(step: step)
            .padding()
        
        Spacer()
    }
}

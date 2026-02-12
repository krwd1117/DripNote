import SwiftUI
import DripNoteCore

public struct SplashView: View {
    @StateObject private var viewModel: SplashViewModel
    
    public init(viewModel: SplashViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            Color.Custom.secondaryBackground.color.ignoresSafeArea()
            
//            VStack {
//                Spacer()
//                Image("AppIconImage")
//                    .resizable()
//                    .frame(width: 256, height: 256)
//                Spacer()
//            }
//            .frame(maxHeight: .infinity)
//            .ignoresSafeArea()
        }
        .task {
            withAnimation {
                viewModel.setup()
            }
        }
    }
} 

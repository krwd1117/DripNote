import SwiftUI
import DripNoteCore

public struct SplashView: View {
    @StateObject private var viewModel: SplashViewModel
    
    public init(viewModel: SplashViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            Color.Custom.secondaryBackground.color
                .ignoresSafeArea()
        }
    }
} 

import SwiftUI
import DripNoteCore

public struct SplashView: View {
    @StateObject private var viewModel: SplashViewModel
    
    public init(viewModel: SplashViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("DripNote")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Your Daily Note Taking App")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
    }
} 

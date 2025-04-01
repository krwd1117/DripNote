import SwiftUI
import MessageUI

public struct SettingsView: View {
    @StateObject private var coordinator = SettingsCoordinator()
    @State private var showingMailView = false
    @State private var showingMailError = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            ZStack {
                Color.Custom.primaryBackground.color
                    .ignoresSafeArea()
                
                VStack {
                    List {
                        Section {
                            Button {
                                if MFMailComposeViewController.canSendMail() {
                                    showingMailView = true
                                } else {
                                    showingMailError = true
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "envelope.fill")
                                    Text("문의하기")
                                }
                            }
                            .foregroundColor(Color.Custom.darkBrown.color)

                        }
                        
                        Section {
                            HStack {
                                Text("Version")
                                    .foregroundColor(Color.Custom.darkBrown.color)
                                Spacer()
                                Text(Bundle.main.appVersion)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .tint(Color.Custom.darkBrown.color)
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: SettingsCoordinator.Route.self) { route in
                coordinator.view(for: route)
            }
            .sheet(isPresented: $showingMailView) {
                CustomMailView(isShowing: $showingMailView)
            }
            .alert("이메일을 보낼 수 없습니다", isPresented: $showingMailError) {
                Button("확인", role: .cancel) {}
            } message: {
                Text("기기에서 이메일 설정을 확인해주세요.")
            }
        }
    }
}

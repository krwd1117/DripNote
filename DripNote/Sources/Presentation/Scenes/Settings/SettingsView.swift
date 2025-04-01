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
                                    Text("Settings.Contact")
                                }
                            }
                            .foregroundColor(Color.Custom.darkBrown.color)
                        }
                        
                        Section {
                            HStack {
                                Text("Settings.Version")
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
            .navigationTitle(String(localized: "Settings.Title"))
            .navigationBarTitleDisplayMode(.inline)
            .tint(Color.Custom.darkBrown.color)
            .navigationDestination(for: SettingsCoordinator.Route.self) { route in
                coordinator.view(for: route)
            }
            .sheet(isPresented: $showingMailView) {
                CustomMailView(isShowing: $showingMailView)
            }
            .alert(String(localized: "Settings.EmailError.Title"), isPresented: $showingMailError) {
                Button(String(localized: "Settings.EmailError.Confirm"), role: .cancel) {}
            } message: {
                Text("Settings.EmailError.Message")
            }
        }
    }
}

import SwiftUI
import MessageUI

public struct SettingsView: View {
    @AppStorage("useMetricWeight") var useMetricWeight: Bool = true
    @AppStorage("useMetricVolume") private var useMetricVolume: Bool = true
    @AppStorage("useMetricTemperature") private var useMetricTemperature: Bool = true
    
    @ObservedObject private var coordinator = SettingsCoordinator()
    
    @State private var showingMailView = false
    @State private var showingMailError = false
    @State private var showingUnitSheet = false
    
    public init(coordinator: SettingsCoordinator) {
        self.coordinator = coordinator
    }
    
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
                            Button {
                                showingUnitSheet = true
                            } label: {
                                HStack {
                                    Image(systemName: "ruler")
                                        .foregroundColor(Color.Custom.darkBrown.color)
                                    Text("Settings.UnitSettings")
                                    Spacer()
                                    Group {
                                        Text(useMetricWeight ? "g" : "oz")
                                        Text("/")
                                        Text(useMetricVolume ? "ml" : "fl oz")
                                        Text("/")
                                        Text(useMetricTemperature ? "°C" : "°F")
                                    }
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                }
                            }
                        } header: {
                            Text("Settings.Preferences")
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
            .sheet(isPresented: $showingUnitSheet) {
                UnitSelectionSheet()
            }
            .alert(String(localized: "Settings.EmailError.Title"), isPresented: $showingMailError) {
                Button(String(localized: "Settings.EmailError.Confirm"), role: .cancel) {}
            } message: {
                Text("Settings.EmailError.Message")
            }
        }
    }
}

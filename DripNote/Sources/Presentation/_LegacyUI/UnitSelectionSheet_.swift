import SwiftUI

struct UnitSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss

    @AppStorage("useMetricWeight") var useMetricWeight: Bool = true
    @AppStorage("useMetricVolume") private var useMetricVolume: Bool = true
    @AppStorage("useMetricTemperature") private var useMetricTemperature: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.Custom.primaryBackground.color
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        unitCard(
                            title: "Settings.Weight",
                            icon: "scalemass",
                            isMetric: $useMetricWeight,
                            metricUnit: "Settings.MetricWeight",
                            imperialUnit: "Settings.ImperialWeight",
                            metricSymbol: "g",
                            imperialSymbol: "oz"
                        )
                        
                        unitCard(
                            title: "Settings.Volume",
                            icon: "drop.fill",
                            isMetric: $useMetricVolume,
                            metricUnit: "Settings.MetricVolume",
                            imperialUnit: "Settings.ImperialVolume",
                            metricSymbol: "ml",
                            imperialSymbol: "fl oz"
                        )
                        
                        unitCard(
                            title: "Settings.Temperature",
                            icon: "thermometer.medium",
                            isMetric: $useMetricTemperature,
                            metricUnit: "Settings.MetricTemperature",
                            imperialUnit: "Settings.ImperialTemperature",
                            metricSymbol: "°C",
                            imperialSymbol: "°F"
                        )
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
            }
            .navigationTitle("Settings.UnitSettings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.height(500)])
    }
    
    private func unitCard(
        title: LocalizedStringKey,
        icon: String,
        isMetric: Binding<Bool>,
        metricUnit: LocalizedStringKey,
        imperialUnit: LocalizedStringKey,
        metricSymbol: String,
        imperialSymbol: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Label {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.Custom.darkBrown.color)
            } icon: {
                Image(systemName: icon)
                    .foregroundColor(Color.Custom.darkBrown.color)
            }
            
            HStack(spacing: 12) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isMetric.wrappedValue = true
                    }
                } label: {
                    unitOption(
                        text: metricUnit,
                        symbol: metricSymbol,
                        isSelected: isMetric.wrappedValue
                    )
                }
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isMetric.wrappedValue = false
                    }
                } label: {
                    unitOption(
                        text: imperialUnit,
                        symbol: imperialSymbol,
                        isSelected: !isMetric.wrappedValue
                    )
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Custom.secondaryBackground.color)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private func unitOption(
        text: LocalizedStringKey,
        symbol: String,
        isSelected: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(text)
                .font(.system(.subheadline, weight: .medium))
                .foregroundColor(isSelected ? Color.Custom.darkBrown.color : .secondary)
            Text(symbol)
                .font(.system(.caption, weight: .regular))
                .foregroundColor(isSelected ? Color.Custom.darkBrown.color.opacity(0.8) : .secondary.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.Custom.darkBrown.color.opacity(0.1) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    isSelected ? Color.Custom.darkBrown.color : Color.secondary.opacity(0.2),
                    lineWidth: isSelected ? 1.5 : 1
                )
        )
        .contentShape(Rectangle())
    }
}

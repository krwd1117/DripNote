import SwiftUI

struct UnitInputSlider: View {
    let title: String
    let unit: String
    let range: ClosedRange<Double>
    let step: Double
    let placholder: String
    let valueFormatter: ((Double) -> String)?
    
    @Binding var value: Double
    @State private var stringValue: String = ""
    
    init(
        title: String,
        unit: String,
        range: ClosedRange<Double>,
        step: Double,
        placholder: String,
        value: Binding<Double>,
        valueFormatter: ((Double) -> String)? = nil
    ) {
        self.title = title
        self.unit = unit
        self.range = range
        self.step = step
        self.placholder = placholder
        self._value = value
        self.valueFormatter = valueFormatter
    }
    
    private func formatValue(_ value: Double) -> String {
        if let formatter = valueFormatter {
            return formatter(value)
        }
        return value.truncatingRemainder(dividingBy: 1) == 0 ?
        String(format: "%.0f", value) :
        String(format: "%.1f", value)
    }
    
    var body: some View {
        VStack {
            HStack {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("*")
                        .foregroundColor(Color.Custom.warmTerracotta.color)
                        .font(.footnote)
                        .bold()
                    
                    Text(title)
                        .font(.footnote)
                        .foregroundColor(Color.Custom.darkBrown.color)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                HStack {
                    TextField(placholder, text: $stringValue)
                        .keyboardType(.decimalPad)
                        .frame(width: 100)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: stringValue) { _, newValue in
                            if let newDouble = Double(newValue),
                               newDouble != value,
                               range.contains(newDouble) {
                                value = newDouble
                            }
                        }
                    Text(unit)
                        .foregroundColor(Color.Custom.darkBrown.color)
                }
            }
            
            Slider(value: $value, in: range, step: step)
                .tint(Color.Custom.accentBrown.color)
                .onChange(of: value) { _, newValue in
                    let newValueString = formatValue(newValue)
                    if newValueString != stringValue {
                        stringValue = newValueString
                    }
                }
        }
        .onAppear {
            stringValue = formatValue(value)
        }
    }
}

import SwiftUI
import DripNoteDomain

public struct RecipeNotesSection: View {
    let notes: String
    
    public init(notes: String) {
        self.notes = notes
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("메모")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.Custom.darkBrown.color)
            
            Text(notes)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(12)
    }
} 
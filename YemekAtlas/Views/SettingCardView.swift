import SwiftUI

struct SettingsCardView: View {
    let titleKey: LocalizedStringKey
    let description: LocalizedStringKey  // Dinamik veri sadece String olarak tutulur
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(titleKey)  // Yerelleştirilmiş başlık
                    .font(.headline)
                Text(description)  // Yerelleştirilmiş açıklama
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5)
    }
}

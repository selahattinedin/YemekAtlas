import SwiftUI

struct GradientButtonView: View {
    let icon: String
    let title: LocalizedStringKey
    let startColor: Color
    let endColor: Color
    let action: () -> Void
    
    init(
        icon: String,
        title: LocalizedStringKey,
        startColor: Color = .orange,
        endColor: Color = .red,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.startColor = startColor
        self.endColor = endColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(colors: [startColor, endColor],
                             startPoint: .leading,
                             endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 27.5))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        }
    }
}

#Preview {
    GradientButtonView(icon: "", title: "", action: {})
}

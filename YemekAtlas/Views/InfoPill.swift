import SwiftUI

struct InfoPill: View {
    let icon: String
    let text: LocalizedStringKey
    let subtext: LocalizedStringKey
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.orange)
                .frame(width: 70, height: 90)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .frame(width: 60, height: 75)
            
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(.black)
                    .font(.title2)
                
                Text(text)
                    .fontWeight(.bold)
                    .font(.footnote)
                
                Text(subtext)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

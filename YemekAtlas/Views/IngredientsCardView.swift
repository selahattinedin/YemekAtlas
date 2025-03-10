import SwiftUI

struct IngredientCard: View {
    let ingredient: Ingredient
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(ingredient.imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color("foodbackcolor") : Color.clear, lineWidth: 3)
                    )
                    .padding(5)
                
                Text(LocalizedStringKey(ingredient.name))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? Color("foodbackcolor") : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(8)
            .background(isSelected ? Color("foodbackcolor").opacity(0.1) : Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

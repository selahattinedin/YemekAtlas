import SwiftUI
import Kingfisher

struct IngredientSelectionView: View {
    @StateObject private var viewModel = IngredientsViewModel()
    @Binding var searchText: String
    @Environment(\.dismiss) var dismiss
    private let mainColor = Color("foodbackcolor")
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    
    var body: some View {
        VStack(spacing: 0) {
            // 📌 Burada marul.png görselini ekledik!
            if let imageUrl = viewModel.marulImageUrl {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
            } else {
                ProgressView("Yükleniyor...")
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.categories) { category in
                        CategoryButton(
                            name: category.name,
                            isSelected: viewModel.selectedCategory == category.name,
                            action: {
                                viewModel.selectedCategory = category.name
                                viewModel.updateFilteredIngredients()
                            }
                        )
                    }
                }
                .padding()
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.filteredIngredients) { ingredient in
                        IngredientCard(
                            ingredient: ingredient,
                            isSelected: viewModel.selectedIngredients.contains(ingredient.name)
                        ) {
                            viewModel.objectWillChange.send()
                            if viewModel.selectedIngredients.contains(ingredient.name) {
                                viewModel.selectedIngredients.remove(ingredient.name)
                            } else {
                                viewModel.selectedIngredients.insert(ingredient.name)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Button(action: {
                searchText = Array(viewModel.selectedIngredients).joined(separator: ", ")
                dismiss()
            }) {
                Text("Malzemeleri Ekle")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(mainColor)
                    .cornerRadius(15)
            }
            .padding()
        }
    }
}

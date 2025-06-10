import SwiftUI
import Foundation



struct ChefSpecialsView: View {
    @ObservedObject private var localeManager = LocaleManager.shared

    var specialRecipes: [Recipe] {
        [
            Recipe(
                name: localeManager.localizedString(forKey: "margherita_pizza"),
                ingredients: [
                    localeManager.localizedString(forKey: "flour_250g"),
                    localeManager.localizedString(forKey: "water_150ml"),
                    localeManager.localizedString(forKey: "yeast_5g"),
                    localeManager.localizedString(forKey: "salt_pinch"),
                    localeManager.localizedString(forKey: "mozzarella_200g"),
                    localeManager.localizedString(forKey: "tomato_sauce_100g"),
                    localeManager.localizedString(forKey: "fresh_basil")
                ],
                calories: 270,
                protein: 12,
                carbohydrates: 33,
                fat: 10,
                allergens: [
                    localeManager.localizedString(forKey: "gluten"),
                    localeManager.localizedString(forKey: "dairy")
                ],
                instructions: localeManager.localizedString(forKey: "margherita_pizza_instructions"),
                imageURL: "Pizza",
                clock: 20
            ),
            Recipe(
                name: localeManager.localizedString(forKey: "sushi"),
                ingredients: [
                    localeManager.localizedString(forKey: "sushi_rice_200g"),
                    localeManager.localizedString(forKey: "rice_vinegar_50ml"),
                    localeManager.localizedString(forKey: "sugar_1tsp"),
                    localeManager.localizedString(forKey: "salt_1tsp"),
                    localeManager.localizedString(forKey: "nori_seaweed"),
                    localeManager.localizedString(forKey: "salmon_200g"),
                    localeManager.localizedString(forKey: "avocado_slices")
                ],
                calories: 180,
                protein: 15,
                carbohydrates: 30,
                fat: 5,
                allergens: [
                    localeManager.localizedString(forKey: "fish")
                ],
                instructions: localeManager.localizedString(forKey: "sushi_instructions"),
                imageURL: "Sushi",
                clock: 30
            ),
            Recipe(
                name: localeManager.localizedString(forKey: "hamburger"),
                ingredients: [
                    localeManager.localizedString(forKey: "hamburger_bun"),
                    localeManager.localizedString(forKey: "ground_beef_150g"),
                    localeManager.localizedString(forKey: "cheddar_slice"),
                    localeManager.localizedString(forKey: "tomato_slices"),
                    localeManager.localizedString(forKey: "lettuce_leaf"),
                    localeManager.localizedString(forKey: "condiments")
                ],
                calories: 450,
                protein: 25,
                carbohydrates: 40,
                fat: 20,
                allergens: [
                    localeManager.localizedString(forKey: "gluten"),
                    localeManager.localizedString(forKey: "dairy")
                ],
                instructions: localeManager.localizedString(forKey: "hamburger_instructions"),
                imageURL: "Hamburger",
                clock: 20
            ),
            Recipe(
                name: localeManager.localizedString(forKey: "tacos"),
                ingredients: [
                    localeManager.localizedString(forKey: "tortillas_2"),
                    localeManager.localizedString(forKey: "chicken_breast_150g"),
                    localeManager.localizedString(forKey: "corn_50g"),
                    localeManager.localizedString(forKey: "tomato_50g"),
                    localeManager.localizedString(forKey: "onion_50g"),
                    localeManager.localizedString(forKey: "taco_seasoning_1tsp")
                ],
                calories: 250,
                protein: 20,
                carbohydrates: 30,
                fat: 8,
                allergens: [
                    localeManager.localizedString(forKey: "gluten")
                ],
                instructions: localeManager.localizedString(forKey: "tacos_instructions"),
                imageURL: "Tacos",
                clock: 15
            ),
            Recipe(
                name: localeManager.localizedString(forKey: "pad_thai"),
                ingredients: [
                    localeManager.localizedString(forKey: "rice_noodles_200g"),
                    localeManager.localizedString(forKey: "shrimp_100g"),
                    localeManager.localizedString(forKey: "soy_sauce_2tbsp"),
                    localeManager.localizedString(forKey: "fish_sauce_1tbsp"),
                    localeManager.localizedString(forKey: "egg_1"),
                    localeManager.localizedString(forKey: "peanuts_50g")
                ],
                calories: 380,
                protein: 22,
                carbohydrates: 50,
                fat: 12,
                allergens: [
                    localeManager.localizedString(forKey: "soy"),
                    localeManager.localizedString(forKey: "fish"),
                    localeManager.localizedString(forKey: "egg"),
                    localeManager.localizedString(forKey: "peanuts")
                ],
                instructions: localeManager.localizedString(forKey: "pad_thai_instructions"),
                imageURL: "PadThai",
                clock: 25
            )
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(localeManager.localizedString(forKey: "chefs_specials"))
                    .font(.title2.bold())
                    .foregroundColor(.orange)

                Spacer()

                Image(systemName: "arrow.right")
                    .foregroundColor(.orange)
                    .transition(.opacity)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(specialRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipesCardView(recipe: recipe)
                        }
                    }
                }
                .padding(.horizontal)
            }

            HStack(spacing: 4) {
                Spacer()
                ForEach(0..<3) { i in
                    Circle()
                        .fill(i == 0 ? Color.orange : Color.gray.opacity(0.5))
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.horizontal)
            .padding(.top, 4)
        }
        .padding(.top, 16)
        .environment(\.locale, localeManager.locale)
    }
}

#Preview {
    ChefSpecialsView()
}

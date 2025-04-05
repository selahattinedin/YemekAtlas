import SwiftUI

struct ChefSpecialsView: View {
    @ObservedObject private var localeManager = LocaleManager.shared
    @State private var showScrollIndicator = true

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
                
                // Kaydırma göstergesi ikonları
                Image(systemName: "chevron.left")
                    .foregroundColor(.gray)
                Image(systemName: "chevron.right")
                    .foregroundColor(.orange)
                    .padding(.trailing, 4)
                
                // Alternatif olarak metin şeklinde ipucu
                // Text(localeManager.localizedString(forKey: "scroll_for_more"))
                //     .font(.caption)
                //     .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            ZStack(alignment: .trailing) {
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
                
                // Sağ kenar gradyanı - daha fazla içerik olduğunu göstermek için
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 30)
                .allowsHitTesting(false) // Kullanıcı etkileşimini engelleme
                
                // Animasyonlu sağa kaydırma oku (opsiyonel)
                if showScrollIndicator {
                    Image(systemName: "hand.point.left.fill")
                        .foregroundColor(.orange)
                        .padding(8)
                        .background(Circle().fill(Color.white.opacity(0.8)))
                        .shadow(radius: 2)
                        .padding(.trailing, 8)
                        .onAppear {
                            // 3 saniye sonra göstergeyi kaldır
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showScrollIndicator = false
                                }
                            }
                        }
                }
            }
        }
        .padding(.top, 16)
        .environment(\.locale, localeManager.locale)
    }
}

#Preview {
    ChefSpecialsView()
}

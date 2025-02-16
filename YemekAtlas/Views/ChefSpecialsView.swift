//
//  ChefSpecialsView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 25.01.2025.
//

import SwiftUI

struct ChefSpecialsView: View {
    let specialRecipes: [Recipe] = [
        Recipe(
            name: "Margherita Pizza",
            ingredients: [
                "250 g un",
                "150 ml su",
                "5 g maya",
                "1 tutam tuz",
                "200 g mozzarella peyniri",
                "100 g domates sosu",
                "Taze fesleğen yaprakları"
            ],
            calories: 270,
            protein: 12,
            carbohydrates: 33,
            fat: 10,
            allergens: ["Gluten", "Süt ürünleri"],
            instructions: """
            1. Un, su, maya ve tuzu karıştırarak pürüzsüz bir hamur hazırlayın.
            2. Hamuru 30 dakika dinlendirin.
            3. Hamuru açıp üzerine domates sosu sürün.
            4. Mozzarella peynirini ekleyin ve fırında 220°C'de 10-12 dakika pişirin.
            5. Taze fesleğen yaprakları ile süsleyerek servis yapın.
            """,
            imageURL: "Pizza",
            clock: 20
        ),
        Recipe(
            name: "Sushi",
            ingredients: [
                "200 g suşi pirinci",
                "50 ml pirinç sirkesi",
                "1 tatlı kaşığı şeker",
                "1 çay kaşığı tuz",
                "Nori yosunu",
                "200 g somon",
                "Avokado dilimleri"
            ],
            calories: 180,
            protein: 15,
            carbohydrates: 30,
            fat: 5,
            allergens: ["Balık"],
            instructions: """
            1. Pirinci yıkayın ve kaynatarak pişirin.
            2. Pirinç sirkesi, şeker ve tuzu karıştırıp sıcak pirince ekleyin.
            3. Nori yosununun üzerine pirinci ince bir tabaka halinde yayın.
            4. Somon ve avokado dilimlerini ekleyerek rulo yapın.
            5. Dilimleyip servis edin.
            """,
            imageURL: "Sushi",
            clock: 30
        ),
        Recipe(
            name: "Hamburger",
            ingredients: [
                "1 hamburger ekmeği",
                "150 g dana kıyma",
                "1 dilim cheddar peyniri",
                "2 dilim domates",
                "1 yaprak marul",
                "Ketçap ve mayonez"
            ],
            calories: 450,
            protein: 25,
            carbohydrates: 40,
            fat: 20,
            allergens: ["Gluten", "Süt ürünleri"],
            instructions: """
            1. Dana kıymayı yuvarlayarak köfte şekline getirin ve tavada pişirin.
            2. Hamburger ekmeğini ikiye bölerek ısıtın.
            3. Alt ekmeğin üzerine marul, domates dilimleri, pişen köfte ve cheddar peyniri ekleyin.
            4. Ketçap ve mayonezle tatlandırın, üst ekmeği kapatın.
            """,
            imageURL: "Hamburger",
            clock: 20
        ),
        Recipe(
            name: "Tacos",
            ingredients: [
                "2 adet tortilla",
                "150 g tavuk göğsü",
                "50 g mısır",
                "50 g domates",
                "50 g soğan",
                "1 tatlı kaşığı taco baharatı"
            ],
            calories: 250,
            protein: 20,
            carbohydrates: 30,
            fat: 8,
            allergens: ["Gluten"],
            instructions: """
            1. Tavuk göğsünü küçük parçalara bölün ve taco baharatı ile marine edin.
            2. Tavukları tavada pişirin.
            3. Tortillaların içine tavuk, mısır, domates ve soğan ekleyin.
            4. Dilerseniz üzerine sos ekleyerek servis yapın.
            """,
            imageURL: "Tacos",
            clock: 15
        ),
        Recipe(
            name: "Pad Thai",
            ingredients: [
                "200 g pirinç eriştesi",
                "100 g karides",
                "2 yemek kaşığı soya sosu",
                "1 yemek kaşığı balık sosu",
                "1 adet yumurta",
                "50 g yer fıstığı"
            ],
            calories: 380,
            protein: 22,
            carbohydrates: 50,
            fat: 12,
            allergens: ["Soya", "Balık", "Yumurta", "Yer fıstığı"],
            instructions: """
            1. Pirinç eriştesini haşlayıp süzün.
            2. Tavada yumurtayı çırparak pişirin.
            3. Karides, soya sosu ve balık sosunu ekleyerek karıştırın.
            4. Haşlanmış erişteyi tavaya ekleyin.
            5. Üzerine yer fıstığı serpip servis yapın.
            """,
            imageURL: "PadThai",
            clock: 25
        )
    ]

    var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Şefin Spesiyeli")
                    .font(.title2.bold())
                    .foregroundColor(.orange)
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
            }
            .padding(.top, 16)
        }
    }

#Preview {
    ChefSpecialsView()
}

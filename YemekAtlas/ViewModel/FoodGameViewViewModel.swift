//
//  FoodGameViewViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 14.04.2025.
//

import Foundation
import SwiftUI

class FoodGameViewViewModel: ObservableObject {
    
    @Published var foodList: [Food] = [
            Food(name: "Adana Kebap", image: "adana_kebap", description: "Acılı kıyma kebabı"),
            Food(name: "İskender", image: "iskender", description: "Döner, tereyağı ve domates sosu"),
            Food(name: "Mantı", image: "manti", description: "Türk usulü ravioli"),
            Food(name: "Lahmacun", image: "lahmacun", description: "İnce hamur üzerine kıyma"),
            Food(name: "Baklava", image: "baklava", description: "Katlı hamur tatlısı"),
            Food(name: "Künefe", image: "kunefe", description: "Peynirli kadayıf tatlısı"),
            Food(name: "Karnıyarık", image: "karniyarik", description: "Kıymalı patlıcan yemeği"),
            Food(name: "Sarma", image: "sarma", description: "Üzüm yaprağında pirinç")
        ]
        
        @Published var currentChampion: Food?
        @Published var currentChallenger: Food?
        @Published var finalWinner: Food?
        @Published var matchingComplete = false
        
        func startGame() {
            foodList.shuffle()
            currentChampion = foodList.removeFirst()
            currentChallenger = foodList.removeFirst()
        }

        func selectWinner(_ winner: Food) {
            currentChampion = winner
            if !foodList.isEmpty {
                currentChallenger = foodList.removeFirst()
            } else {
                finalWinner = winner
                matchingComplete = true
            }
        }

        func resetGame() {
            foodList = [
                Food(name: "Adana Kebap", image: "adana_kebap", description: "Acılı kıyma kebabı"),
                Food(name: "İskender", image: "iskender", description: "Döner, tereyağı ve domates sosu"),
                Food(name: "Mantı", image: "manti", description: "Türk usulü ravioli"),
                Food(name: "Lahmacun", image: "lahmacun", description: "İnce hamur üzerine kıyma"),
                Food(name: "Baklava", image: "baklava", description: "Katlı hamur tatlısı"),
                Food(name: "Künefe", image: "kunefe", description: "Peynirli kadayıf tatlısı"),
                Food(name: "Karnıyarık", image: "karniyarik", description: "Kıymalı patlıcan yemeği"),
                Food(name: "Sarma", image: "sarma", description: "Üzüm yaprağında pirinç"),
            ]
            currentChampion = nil
            currentChallenger = nil
            finalWinner = nil
            matchingComplete = false
        }
    }

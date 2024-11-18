//
//  YemekAtlasApp.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 19.10.2024.
//

import SwiftUI
import FirebaseCore

@main
struct YemekAtlasApp: App {
    @State var showPreviewPage = true
    
    
    init(){
        FirebaseApp.configure()
        
    }
    var body: some Scene {
        WindowGroup {
            if showPreviewPage{
                FirstView()
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now()+3){
                            showPreviewPage = false
                        }
                    }
            } else{
                MainView()
            }
        }
    }
}

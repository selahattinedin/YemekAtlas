//
//  RegisterView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 19.10.2024.
//

import SwiftUI

struct RegisterView: View {
    
  @StateObject  var viewModel = RegisterViewViewModel()
    
    var body: some View {
        NavigationStack{
                    VStack {
                        Spacer()
                        
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Hoşgeldiniz")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text("Kayıt olmak için devam edin")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            
                            
                            ZStack {
                                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 100,height: 100)
                                }
                                .offset(x: 10, y: 1)
                            
                        }
                        .padding(.horizontal)
                        
                        if !viewModel.errorMessage.isEmpty{
                            Text(viewModel.errorMessage)
                                .foregroundStyle(.red)
                        }
                        
                       
                        TextField("Tam isminizi giriniz ", text: $viewModel.name)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                    
                       TextField("Email", text: $viewModel.email)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .autocapitalization(.none)
                        
                
                        SecureField("Şifre", text: $viewModel.password)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                       
                        HStack {
                            Button(action: {
                                viewModel.agreeToTerms.toggle()
                            }) {
                                Image(systemName: viewModel.agreeToTerms ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(viewModel.agreeToTerms ? .pink : .gray)
                                }
                                            
                                Text("I agree to the")
                                    .foregroundColor(.gray)
                                            
                                    NavigationLink(destination: AgreementView()) {
                                                Text("Terms of Service")
                                                    .foregroundColor(.blue)
                                    }
                        }
                                        
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                    
                        Button(action: {
                            viewModel.register()
                        }) {
                            Text("Giriş yap")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.pink)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        Spacer()
                        
                        
                        HStack {
                            Text("Zaten bir hesabın var mı?")
                                .foregroundColor(.gray)
                                NavigationLink(destination: LoginView()) {
                                    Text("Giriş yap")
                                        .foregroundColor(.pink)
                                            }
                               
                            
                        }
                        .padding(.bottom, 20)
                    }
                    .background(Color.white.edgesIgnoringSafeArea(.all))
                }
            }

             }

        
    


#Preview {
    RegisterView()
}

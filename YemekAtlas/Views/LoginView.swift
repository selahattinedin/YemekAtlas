//
//  Selahattin Edin
//  YemekAtlas
//
//  Created by Selahattin EDİN on 20.10.2024.
//

import SwiftUI

struct LoginView: View {

    @StateObject var viewModel = LoginViewViewModel()
        
        var body: some View {
            NavigationStack{
                VStack {
                    Spacer()
                    HeaderView()
                    
                    if !viewModel.errorMessage.isEmpty{
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                    }
                    HStack {
                        Image(systemName: "envelope.fill") 
                            .foregroundColor(.gray)
                        TextField("Email", text: $viewModel.email)
                    }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .autocapitalization(.none)
                    
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        if viewModel.isPasswordVisible {
                            TextField("Şifre", text: $viewModel.password)
                        } else {
                            SecureField("Şifre", text: $viewModel.password)
                            }
                            Button(action: {
                                viewModel.isPasswordVisible.toggle()
                            }) {
                                Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.pink)
                            }
                    }
                    
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: RegisterView()){
                            Text("Forgot Password?")
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                    }
                    .padding(.top, 10)
                    
                    
                    Button(action: {
                        // Action
                    }) {
                        Text("Sign in with Google")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.pink)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.pink, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                   
                    HStack {
                        Text("Create new account?")
                            .foregroundColor(.gray)
                            NavigationLink(destination: RegisterView()) {
                                Text("Sign Up")
                                    .foregroundColor(.pink)
                                        }
                                    }
                    .padding(.bottom, 20)
                    
                    Button(action: {
                        viewModel.login()
                    }) {
                        Text("Login")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
    }

    #Preview {
    LoginView()
}
                        
                    

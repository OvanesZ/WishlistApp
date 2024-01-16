//
//  AuthenticationView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 18.11.2023.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift


struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    
    var body: some View {
        ZStack {
            VStack {
                
                // MARK: - Кнопка анонимной авторизациию. В данном случае не используется.
                /*
                 Button(action: {
                 Task {
                 do {
                 try await viewModel.signInAnonymous()
                 showSignInView = false
                 } catch {
                 print(error)
                 }
                 }
                 }, label: {
                 Text("Sign In Anonymously")
                 .font(.headline)
                 .foregroundColor(.white)
                 .frame(height: 55)
                 .frame(maxWidth: .infinity)
                 .background(Color.orange)
                 .cornerRadius(10)
                 })
                 .frame(height: 55)
                 */
                VStack {
                    Text("WISHLIST")
                        .font(Font.custom("Gloock-Regular", size: 48))
                        .foregroundColor(.white)
                    
                    
                    
                    Image("logo_wishlist")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                }
                
                
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Войти/Зарегистрироваться через email")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                
                
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal)) {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }
                .cornerRadius(10)
                
                
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signInApple()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }, label: {
                    SignInWithAppleButtonviewRepresentable(type: .default, style: .black)
                        .allowsHitTesting(false)
                })
                .frame(height: 55)
                .cornerRadius(10)
                
                
                
                Spacer()
            }
            .padding()
            //            .navigationTitle("Авторизация")
        }
        .background {
            Image("bg_wishlist")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .aspectRatio(contentMode: .fill)
        }
    }
}



struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
        
    }
}

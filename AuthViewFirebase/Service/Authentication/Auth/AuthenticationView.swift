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
    @State private var isShowSignInEmailView = false
    
    
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
                
                Button {
                    isShowSignInEmailView.toggle()
                } label: {
                    Text("Войти/Зарегистрироваться через email")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
//                        .background(Color.orange)
                        .background(Color("testColor"))
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $isShowSignInEmailView) {
                    SignInEmailView(showSignInView: $showSignInView)
                }
//                .sheet(isPresented: $isShowSignInEmailView) {
//                    SignInEmailView(showSignInView: $showSignInView)
//                }
                
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal)) {
                    Task {
                        do {
//                            UserDefaults.standard.setValue(true, forKey: "NewUser")
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
                            UserDefaults.standard.setValue(true, forKey: "NewUser")
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
                
                ZStack(alignment: .center) {
                    Text("Нажимая на кнопку, вы принимаете \(Text("[пользовательское соглашение](https://ya.ru)").underline()) и даете согласие на обработку ваших персональных данных на условиях \(Text("[политики конфиденциальности](https://wishlistapp.tb.ru/privacypolicy)").underline()).")
                        .tint(.black)
                        .font(.caption)
//                        .frame(width: .infinity, alignment: .leading)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                }
            }
            .padding()
            
            
            
        }
        .background {
            Image("bg_wishlist")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .aspectRatio(contentMode: .fill)
        }
        .task {
            try? await viewModel.getAllUsers()
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

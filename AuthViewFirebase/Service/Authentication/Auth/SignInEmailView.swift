//
//  SignInEmailView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 18.11.2023.
//

import SwiftUI


struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    @State private var isAuth = false
    @State private var blur = 0
    
    var body: some View {
        
        VStack {
            
            
            Text("WISHLIST")
                .font(Font.custom("Gloock-Regular", size: 48))
                .foregroundColor(.white)
                .blur(radius: CGFloat(blur))
            
            
            
            Image("logo_wishlist")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .blur(radius: CGFloat(blur))
            
            TextField("", text: $viewModel.email, prompt: Text("Почта").foregroundColor(.gray))
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .foregroundStyle(.black)
            
                
            
            SecureField("", text: $viewModel.password, prompt: Text("Пароль").foregroundColor(.gray))
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .textContentType(.password)
                .foregroundStyle(.black)

            if isAuth {
                SecureField("", text: $viewModel.confirmPassword, prompt: Text("Повторите пароль").foregroundColor(.gray))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .textContentType(.newPassword)
                    .foregroundStyle(.black)
            }
            
            // Действие на авторизацию и регистрацию в одной кнопке. При желании можно сделать две разные кнопки.
            
            if isAuth {
                Button {
                    Task {
                        do {
                            UserDefaults.standard.setValue(true, forKey: "NewUser")
                            try await viewModel.signUp()
                            showSignInView = viewModel.isBindingShow
                            return
                        } catch {
                            print(error.localizedDescription)
                            viewModel.alertMessage = error.localizedDescription
                            viewModel.isAlertShow.toggle()
                            viewModel.password = ""
                            viewModel.confirmPassword = ""
                        }
                    }
                    
                } label: {
                    Text("Зарегистрироваться")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(10)
                }
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
            } else {
                Button {
                    Task {
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            return
                        } catch {
                            print(error.localizedDescription)
                            viewModel.alertMessage = error.localizedDescription
                            viewModel.isAlertShow.toggle()
                            viewModel.password = ""
                        }
                    }
                } label: {
                    Text("Войти")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(10)
                }
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
            }
            
            
            
            
            
            
            if isAuth {
                Button(action: {
                    
                    withAnimation(.easeInOut(duration: 0.6)) {
                        self.blur = 0
                        isAuth.toggle()
                    }
                }, label: {
                    Text("Уже зарегистрированы?")
                        .foregroundStyle(Color.white)
                        .font(.subheadline.bold())
                })
                .padding()
            } else {
                Button(action: {
                   
                    withAnimation(.easeInOut(duration: 0.6)) {
                        self.blur = 3
                        isAuth.toggle()
                    }
                }, label: {
                    Text("Нет аккаунта?")
                        .foregroundStyle(Color.white)
                        .font(.subheadline.bold())
                })
                .padding()
            }
            
            Spacer()
            
            
        }
        .padding()
        .background {
            Image("bg_wishlist")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .aspectRatio(contentMode: .fill)
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.isAlertShow) {
            Button("OK") {
                
            }
        }
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInEmailView(showSignInView: .constant(false))
    }
}



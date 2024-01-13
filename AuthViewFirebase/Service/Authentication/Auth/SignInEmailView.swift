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
            
            TextField("Почта", text: $viewModel.email)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .textCase(.lowercase)
//                .textContentType(.emailAddress)
            
            SecureField("Пароль", text: $viewModel.password)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
//                .textContentType(.newPassword)

            if isAuth {
                SecureField("Повторите пароль", text: $viewModel.confirmPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
            
            // Действие на авторизацию и регистрацию в одной кнопке. При желании можно сделать две разные кнопки.
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text(isAuth ? "Зарегистрироваться" : "Войти")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(isAuth ? LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(10)
            }
            .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.confirmPassword.isEmpty)
            
            
            
            
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
//        .navigationTitle(isAuth ? "Вход" : "Регистрация").font(.title.bold()).foregroundStyle(Color.white)
        
        
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInEmailView(showSignInView: .constant(false))
    }
}

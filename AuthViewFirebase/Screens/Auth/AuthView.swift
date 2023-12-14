//
//  ContentView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 19.08.2023.
//

import SwiftUI
import Combine
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

@MainActor
final class AuthenticationsViewModel: ObservableObject {

    func signInGoogle() async throws {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }

        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }

        let accessToken = gidSignInResult.user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: accessToken)

        AuthService.shared.signInWithGoogle(credential: credential) { result in
            switch result {
            case .success(_):
                print("good")
            case .failure(let error):
                print(error)
            }
        }

    }
}

struct AuthView: View {
    
    @StateObject private var viewModel = AuthenticationsViewModel()
    
    @State private var login = ""
    @State private var password = ""
    @State private var verifyPassword = ""
    @State private var isAuth = false
    @State private var isTabViewShow = false
    @State private var isShowAlert = false
    @State private var alertMessage = ""
    @State var shouldShowLogo: Bool = true
    
    private let keyboardPublisher = Publishers.Merge(
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification in true } ,
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { notification in false }
    ).eraseToAnyPublisher()
    
    var body: some View {
        
        
        
        VStack {
            
            
            
            if shouldShowLogo {
                Image("logo_wishlist")
                    .resizable()
                    .frame(width: 220, height: 220)
                    .clipShape(Circle())
                    .blur(radius: isAuth ? 6 : 0)
                    .padding(.top, -95)
            }
            
            Text(isAuth ? "Регистрация" : "Авторизация")
                .padding(8)
                .padding(.horizontal, 30)
                .font(.largeTitle)
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(20)
            
            TextField("Email", text: $login)
                .textFieldStyle(.roundedBorder)
                .cornerRadius(12)
                .padding(8)
                .padding(.horizontal, 12)
                .shadow(color: .orange, radius: 5)
                .keyboardType(.emailAddress)
            
            SecureField("Введите пароль", text: $password)
                .textFieldStyle(.roundedBorder)
                .cornerRadius(12)
                .padding(8)
                .padding(.horizontal, 12)
                .shadow(color: .orange, radius: 5)
            
            if isAuth {
                SecureField("Повторите пароль", text: $verifyPassword)
                    .textFieldStyle(.roundedBorder)
                    .cornerRadius(12)
                    .padding(8)
                    .padding(.horizontal, 12)
                    .shadow(color: .orange, radius: 5)
            }
            
            Button {
                if !isAuth {
                    print("Авторизация через Firebase")
                    
                    AuthService.shared.signIn(email: self.login, password: self.password) { result in
                        switch result {
                        case .success(_):
                            isTabViewShow.toggle()
                        case .failure(let error):
                            alertMessage = "Ошибка авторизации: \(error.localizedDescription)"
                            isShowAlert.toggle()
                        }
                    }
                    
                } else {
                    print("Registration")
                    
                    
                    guard password == verifyPassword else {
                        self.alertMessage = "Пароли не совпадают!"
                        self.isShowAlert.toggle()
                        return
                    }
                    
                    AuthService.shared.signUp(email: self.login, password: self.password) { result in
                        switch result {
                        case .success(let user):
                            
                            alertMessage = "Вы зарегитсрировались с email \(user.email ?? "")"
                            self.isShowAlert.toggle()
                            self.login = ""
                            self.password = ""
                            self.verifyPassword = ""
                            self.isAuth.toggle()
                        case .failure(let error):
                            
                            alertMessage = "Ошибка регистрации! \(error.localizedDescription)"
                            self.isShowAlert.toggle()
                        }
                    }
                    
                    
                }
            } label: {
                Text(isAuth ? "Зарегистрироваться" : "Войти")
                    .foregroundColor(Color.white)
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(10)
            .buttonStyle(.bordered)
            
           
            
            
            Button {
                isAuth.toggle()
            } label: {
                Text(isAuth ? "Уже есть аккаунт" : "Нет аккаунта?")
            }
            .padding()
            .alert(alertMessage, isPresented: $isShowAlert) {
                Button {
                    
                } label: {
                    Text("OK!")
                }

            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        isTabViewShow.toggle()
                    } catch {
                        print(error)
                    }
                }
            }
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Image("bg")
//            .resizable()
//            .ignoresSafeArea()
//            .blur(radius: isAuth ? 6 : 0))
        .animation(Animation.easeInOut(duration: 0.4), value: isAuth)
        .fullScreenCover(isPresented: $isTabViewShow) {
            
//            let mainTabBarViewModel = MainTabBarViewModel(user: AuthService.shared.currentUser!)
            
//            MainTabBar(viewModel: mainTabBarViewModel)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onReceive(self.keyboardPublisher) { isKeyboardShow in
            withAnimation(.easeIn(duration: 0.3)) {
                self.shouldShowLogo = !isKeyboardShow
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

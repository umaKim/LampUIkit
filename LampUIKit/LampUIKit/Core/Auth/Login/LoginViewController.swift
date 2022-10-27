//
//  LoginViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//
import KakaoSDKUser
import KakaoSDKAuth
import CryptoKit
import Combine
import FirebaseAuth
import AuthenticationServices
import GoogleSignIn
import Firebase
import UIKit
import StoreKit

class LoginViewController: BaseViewController<LoginView, LoginViewModel> {
    
    private var currentNonce: String?
    private let skStoreProductViewController = SKStoreProductViewController()
    
    override func loadView() {
        super.loadView()
        self.view = contentView.baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        skStoreProductViewController.delegate = self
    }
    
    //MARK: - Bind
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                HapticManager.shared.feedBack(with: .heavy)
                switch action {
                case .apple:
                    self.startSignInWithAppleFlow()
                    
                case .gmail:
                    self.startGmailLogin()
                    
                case .kakao:
                    self.startKakaoLogin()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[weak self] notification in
                guard let self = self else {return }
                switch notification {
                case .changeRootViewController(let uid):
                    self.changeRootViewcontroller(with: uid)
                    
                case .presentCreateNickName:
                    self.present(CreateNickNameViewController(CreateNickNameView(), CreateNickNameViewModel()),
                                 transitionType: .fromTop,
                                 animated: true,
                                 pushing: true)
                    
                case .presentInitialSetpage:
                    self.present(
                        InitialSetPageViewController(InitialSetPageView(), InitialSetPageViewModel()),
                        transitionType: .fromTop,
                        animated: true,
                        pushing: true)
                    
                case .showMessage(let message):
                    self.presentUmaDefaultAlert(title: "ServerError", message: message)
                }
            }
            .store(in: &cancellables)
    }
    
    private func changeRootViewcontroller(with uid: String) {
        changeRoot(MainViewController(MainView(), MainViewModel()))
    }
    
    private func checkIfUserAlreadyExist(with uid: String) {
        viewModel.checkUserExist(uid)
    }
}

//MARK: - SKStoreProductViewControllerDelegate
extension LoginViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        skStoreProductViewController.dismiss(animated: true)
    }
}

//MARK: - Apple
extension LoginViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

//MARK: - ASAuthorizationControllerDelegate
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) {[weak self] authResult, error in
                guard let self = self else {return}
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                ///Main 화면으로 보내기
                guard let uid = authResult?.user.uid else {return }
                self.viewModel.setUserAuthType(.apple)
                self.checkIfUserAlreadyExist(with: uid)
            }
        }
    }
}

//MARK: - ASAuthorizationControllerPresentationContextProviding
extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

//MARK: - gmail
extension LoginViewController {
    func startGmailLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [weak self] user, error in
            
            if let error = error { return }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) {[weak self] result, error in
                guard let self = self else {return}
                // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
                if let error = error {
                    self.presentUmaDefaultAlert(title: error.localizedDescription)
                    return
                }
                
                guard let uid = result?.user.uid else {return }
                self.viewModel.setUserAuthType(.google)
                self.checkIfUserAlreadyExist(with: uid)
            }
        }
    }
}


//MARK: - KAKAO
extension LoginViewController {
    func startKakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {[weak self] (oauthToken, error) in
                guard let self = self else {return}
                if let error = error {
                    self.presentUmaDefaultAlert(title: error.localizedDescription)
                }
                else {
                    self.getUserInfo()
                }
            }
            
        }
        else {
            UserApi.shared.loginWithKakaoAccount {[weak self] token, error in
                guard let self = self else {return}
                if let error = error {
                    self.presentUmaDefaultAlert(title: error.localizedDescription)
                }
                else {
                    self.getUserInfo()
                }
            }
        }
    }
    
    private func getUserInfo() {
        UserApi.shared.me() {[weak self] (user, error) in
            guard let self = self else {return}
            if let error = error {
                self.presentUmaDefaultAlert(title: "\(error.localizedDescription)")
            }
            else {
                guard let id = user?.id else {return }
                self.viewModel.setUserAuthType(.kakao)
                self.checkIfUserAlreadyExist(with: "\(id)")
            }
        }
    }
}

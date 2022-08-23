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

class LoginViewController: UIViewController {
    
    private let contentView = LoginView()
    private let viewModel: LoginViewModel
    
    init(vm: LoginViewModel) {
        self.viewModel = vm
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = contentView
    }
    
    private var cancellables: Set<AnyCancellable>
    
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
    }
    
    private func bind() {
        contentView.actionPublisher.sink { action in
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
    }
    
    private func changeRootViewcontroller(with uid: String) {
        NetworkService.shared.setToken(uid)
        self.changeRoot(MainViewController(MainViewModel()))
    }
    
    private func checkIfUserAlreadyExist(with uid: String) {
        NetworkService.shared.checkUserExist(uid) { res in
            if res.isSuccess {
                //TODO: - move to mainView
                if res.nicknameExist ?? false {
                    self.changeRootViewcontroller(with: uid)
                } else {
                    self.present(CreateNickNameViewController(CreateNickNameViewModel()), transitionType: .fromTop, animated: true, pushing: true)
                }
                
            } else {
                //TODO: - move to QuizView
                self.present(
                    InitialSetPageViewController(vm: InitialSetPageViewModel()),
                    transitionType: .fromTop,
                    animated: true,
                    pushing: true)
            }
        }
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
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                ///Main 화면으로 보내기
                
                guard let uid = authResult?.user.uid else {return }
                NetworkService.shared.setUserAuthType(.firebase)
                self.checkIfUserAlreadyExist(with: uid)
            }
        }
    }
}

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
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            if let error = error { return }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) {result, error in
                // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
                if let error = error {
                    print(error)
                    return
                }
                
                guard let uid = result?.user.uid else {return }
                NetworkService.shared.setUserAuthType(.firebase)
                self.checkIfUserAlreadyExist(with: uid)
            }
        }
    }
}


//MARK: - KAKAO
extension LoginViewController {
    func startKakaoLogin() {
        // ✅ 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    self.getUserInfo()
                }
            }
        }
        else {
            self.presentUmaDefaultAlert(title: "Install Kakao App")
        }
    }
    
    // ✅ 사용자 정보를 성공적으로 가져오면 화면전환 한다.
    private func getUserInfo() {
        
        // ✅ 사용자 정보 가져오기
        UserApi.shared.me() {(user, error) in
            if let error = error {
                self.presentUmaDefaultAlert(title: "\(error.localizedDescription)")
            }
            else {
                guard let id = user?.id else {return }
                NetworkService.shared.setUserAuthType(.kakao)
                self.checkIfUserAlreadyExist(with: "\(id)")
            }
        }
    }
}

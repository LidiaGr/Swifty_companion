//
//  LoginViewController.swift
//  swifty_companion
//
//  Created by Temple Tarsha on 10/21/21.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
	var apiConnection : ApiConnection?
  private(set) var isLoading = false
    
	// MARK: - Private properties
	
    private let button = UIButton()
    private let logo = UIImageView(image: UIImage(named: "logo"))
    
	private var spinner: UIActivityIndicatorView! = {
        let loginSpinner = UIActivityIndicatorView(style: .large)
        loginSpinner.color = .white
        loginSpinner.translatesAutoresizingMaskIntoConstraints = false
        loginSpinner.hidesWhenStopped = true
        return loginSpinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        self.apiConnection = ApiConnection(apiDelegate: self)
        
		print(Bundle.allBundles)
		
        setupLogo()
        setupButton()
        setupSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
	
	// MARK: - Private methods
	
		private func presentAlert(_ title: String, message: String) {
		  let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		  alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		  present(alert, animated: true, completion: nil)
		}
		
		private func setupLogo() {
			view.addSubview(logo)
			logo.translatesAutoresizingMaskIntoConstraints = false
			
			logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
			logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		}
		
		private func setupSpinner() {
			view.addSubview(spinner)
			spinner.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20).isActive = true
			spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		}
		
		private func setupButton() {
			button.setTitle("Login", for: .normal)
			button.backgroundColor = UIColor(hexString: "#00babc")
			button.setTitleColor(UIColor.white, for: .normal)
			button.layer.cornerRadius = 5
			button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
			
			view.addSubview(button)
			button.translatesAutoresizingMaskIntoConstraints = false
			button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
			button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
			button.widthAnchor.constraint(equalToConstant: 300).isActive = true
			button.heightAnchor.constraint(equalToConstant: 50).isActive = true
			
		}
  
    func buttonEnabled(value: Bool) {
      if value == true {
        button.isEnabled = true
        button.alpha = 1
      } else {
        button.isEnabled = false
        button.alpha = 0.5
      }
    }
		
		@objc private func buttonPressed() {
			
			spinner.startAnimating()
			buttonEnabled(value: false)
	//        apiConnection?.login()
      
      
      guard let signInURL =
        NetworkRequest.RequestType.signIn.networkRequest()?.url
      else {
        print("Could not create the sign in URL .")
        return
      }
      
      let callbackURLScheme = NetworkRequest.callbackURLScheme
      let authenticationSession = ASWebAuthenticationSession(
        url: signInURL,
        callbackURLScheme: callbackURLScheme) { [weak self] callbackURL, error in
          // 1
          guard
            error == nil,
            let callbackURL = callbackURL,
            // 2
            let queryItems = URLComponents(string: callbackURL.absoluteString)?
              .queryItems,
            // 3
            let code = queryItems.first(where: { $0.name == "code" })?.value,
            // 4
            let networkRequest =
              NetworkRequest.RequestType.codeExchange(code: code).networkRequest()
          else {
            // 5
            print("An error occurred when attempting to sign in.")
            return
          }
          
          self?.isLoading = true
          networkRequest.start(responseType: String.self) { result in
            switch result {
            case .success:
              self?.getUser()
            case .failure(let error):
              print("Failed to exchange access code for tokens: \(error)")
            }
          }
          
      }
      authenticationSession.presentationContextProvider = self
//      authenticationSession.prefersEphemeralWebBrowserSession = true
      
      
      if !authenticationSession.start() {
        print("Failed to start ASWebAuthenticationSession")
      }
		}
  
    func appeared() {
      // Try to get the user in case the tokens are already stored on this device
      getUser()
    }

    private func getUser() {
      isLoading = true

      NetworkRequest
        .RequestType
        .getUser
        .networkRequest()?
        .start(responseType: User.self) { [weak self] result in
          switch result {
          case .success:
            self?.spinner.stopAnimating()
            let vc = ViewController()
            self?.navigationController?.pushViewController(vc, animated: false)
          case .failure(let error):
            print("Failed to get user, or there is no valid/active session: \(error.localizedDescription)")
          }
          self?.isLoading = false
        }
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession)
  -> ASPresentationAnchor {
    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
    return window ?? ASPresentationAnchor()
  }
}

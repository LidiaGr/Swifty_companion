//
//  LoginViewController.swift
//  swifty_companion
//
//  Created by Temple Tarsha on 10/21/21.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
  private(set) var dataLoaded = false {
    willSet {
      if newValue != dataLoaded {
        stackView.arrangedSubviews.forEach { $0.isHidden = false }
      }
    }
  }
  
  private(set) var isLoading = false {
    willSet {
      if newValue == true {
        spinner.startAnimating()
        loginButton.isHidden = true
        buttonEnabled(button: searchButton, value: false)
      } else {
        spinner.stopAnimating()
        buttonEnabled(button: searchButton, value: true)
      }
    }
  }
  
  private(set) var tokenExpired = false
  
  // MARK: - Private properties
  
  private let loginButton = UIButton()
  private let searchButton = UIButton()
  private let textField = TextField()
  private let logo = UIImageView(image: UIImage(named: "logo"))
  
  let stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.distribution = .fillProportionally
    stack.axis = .vertical
    stack.spacing = 15
    return stack
  }()
  
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
    
    setupLogo()
    setupLoginButton()
    setupSpinner()
    setupStackView()
    setupTextField()
    setupSearchButton()
    
    resetToEmptyState()
  }
  
  // MARK: - Private methods
  
  private func resetToEmptyState() {
    stackView.arrangedSubviews.forEach { $0.isHidden = true }
  }
  
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
    spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }
  
  private func setupLoginButton() {
    loginButton.setTitle("Login", for: .normal)
    loginButton.backgroundColor = UIColor(hexString: "#00babc")
    loginButton.setTitleColor(UIColor.white, for: .normal)
    loginButton.layer.cornerRadius = 5
    loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    
    view.addSubview(loginButton)
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    loginButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
  
  func buttonEnabled(button: UIButton, value: Bool) {
    if value == true {
      button.isEnabled = true
      button.alpha = 1
    } else {
      button.isEnabled = false
      button.alpha = 0.5
    }
  }
  
  private func setupSearch() {
    setupStackView()
    setupTextField()
    setupSearchButton()
  }
  
  func setupStackView() {
    view.addSubview(stackView)
    stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
  }
  
  func setupTextField() {
    textField
      .attributedPlaceholder = NSAttributedString(string: "Enter username",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
    textField.textAlignment = .left
    textField.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    textField.layer.borderColor = UIColor(hexString: "#00babc").cgColor
    textField.layer.borderWidth = 1
    textField.layer.cornerRadius = 5
    textField.textColor = UIColor.white
    textField.borderStyle = .roundedRect
    textField.autocorrectionType = UITextAutocorrectionType.no
    textField.keyboardType = UIKeyboardType.default
    textField.returnKeyType = UIReturnKeyType.done
    textField.clearButtonMode = UITextField.ViewMode.whileEditing
    textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    textField.delegate = self
    
    textField.addTarget(self, action: #selector(searchButtonPressed), for: .editingDidEndOnExit)
    
    stackView.addArrangedSubview(textField)
  }
  
  func setupSearchButton() {
    searchButton.setTitle("Search", for: .normal)
    searchButton.backgroundColor = UIColor(hexString: "#00babc")
    searchButton.setTitleColor(UIColor.white, for: .normal)
    searchButton.layer.cornerRadius = 5
    searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
    
    stackView.addArrangedSubview(searchButton)
  }
}


// MARK: - Networking

extension LoginViewController {
  @objc func searchButtonPressed() {
    isLoading = true
    
    let username = textField.text?.lowercased() ?? ""
    NetworkRequest
      .RequestType
      .findUser(username: username)
      .networkRequest()?
      .start(responseType: User.self) { [weak self] result in
        switch result {
        case .success(let response):
          self?.presentUserProfile(user: response.object)
        case .failure(let error):
          self?.presentAlert(username, message: "User not found")
          print("Failed to find user, or there is no valid/active session: \(error.localizedDescription)")
        }
        self?.isLoading = false
      }
  }
  
  @objc private func loginButtonPressed() {
    if NetworkRequest.accessToken != nil && tokenExpired == false {
      appeared()
      return
    }
    
    guard let signInURL = NetworkRequest.RequestType.signIn.networkRequest()?.url else {
      print("Could not create the sign in URL .")
      return
    }
    
    let callbackURLScheme = NetworkRequest.callbackURLScheme
    let authenticationSession = ASWebAuthenticationSession(
      url: signInURL,
      callbackURLScheme: callbackURLScheme) { [weak self] callbackURL, error in
        guard
          error == nil,
          let callbackURL = callbackURL,
          let queryItems = URLComponents(string: callbackURL.absoluteString)?
            .queryItems,
          let code = queryItems.first(where: { $0.name == "code" })?.value,
          let networkRequest =
            NetworkRequest.RequestType.codeExchange(code: code).networkRequest()
        else {
          print("An error occurred when attempting to sign in.")
          return
        }
        
        self?.isLoading = true
        networkRequest.start(responseType: String.self) { result in
          switch result {
          case .success:
            self?.getAuthorizedUser()
          case .failure(let error):
            print("Failed to exchange access code for tokens: \(error)")
          }
        }
      }
    
    authenticationSession.presentationContextProvider = self
    authenticationSession.prefersEphemeralWebBrowserSession = true
    
    if !authenticationSession.start() {
      print("Failed to start ASWebAuthenticationSession")
    }
  }
  
  func appeared() {
    // Get the user in case the tokens are already stored on this device
    getAuthorizedUser()
  }
  
  private func getAuthorizedUser() {
    isLoading = true
    
    NetworkRequest
      .RequestType
      .getAuthorizedUser
      .networkRequest()?
      .start(responseType: User.self) { [weak self] result in
        switch result {
        case .success(let response):
          self?.tokenExpired = false
          self?.presentUserProfile(user: response.object)
        case .failure(let error):
          self?.tokenExpired = true
          self?.loginButton.isHidden = false
          self?.loginButton.setTitle("Retry", for: .normal)
          print("Failed to get user, or there is no valid/active session: \(error.localizedDescription)")
        }
        self?.isLoading = false
      }
  }
  
  private func presentUserProfile(user: User) {
    let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    vc.user = user
    self.present(vc, animated: true) { [weak self] in
      self?.dataLoaded = true
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

extension LoginViewController : UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    // get the current text, or use an empty string if that failed
    let currentText = textField.text ?? ""
    
    // attempt to read the range they are trying to change, or exit if we can't
    guard let stringRange = Range(range, in: currentText) else { return false }
    
    // add their new text to the existing text
    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
    
    // make sure the result is under 16 characters
    return updatedText.count <= 20
  }
}

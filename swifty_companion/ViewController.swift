//
//  ViewController.swift
//  day04
//
//  Created by Lidia Grigoreva on 23.06.2021.
//

import UIKit

class ViewController: UIViewController {
    var apiConnection : ApiConnection?
    
    let button = UIButton()
    let textField = UITextField()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    var spinner: UIActivityIndicatorView! = {
        let loginSpinner = UIActivityIndicatorView(style: .large)
        loginSpinner.color = .black
        loginSpinner.translatesAutoresizingMaskIntoConstraints = false
        loginSpinner.hidesWhenStopped = true
        return loginSpinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        self.apiConnection = ApiConnection(apiDelegate: self)
        navigationItem.title = "Intra 42"
        
        setupStackView()
        setupTextField()
        setupButton()
        setupSpinner()
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func setupTextField() {
        textField.placeholder = "Enter username"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.delegate = self
        
        stackView.addArrangedSubview(textField)
    }
    
    func setupSpinner() {
        view.addSubview(spinner)
        spinner.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupButton() {
        button.setTitle("Search", for: .normal)
        button.backgroundColor = UIColor.systemGray
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        stackView.addArrangedSubview(button)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        spinner.startAnimating()
        apiConnection?.getTokenAndMakeRequest(username: textField.text?.lowercased() ?? "")
    }
}

extension ViewController : APIIntra42Delegate {
    func processData(data: User) {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            print(data)
        }
    }
    
    func errorOccured(error: NSError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "User '\(error.userInfo["username"] ?? "")' not found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog(error.localizedDescription)
            }))
            self.present(alert, animated: true, completion: nil)
            self.spinner.stopAnimating()
        }
    }
}

extension ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return updatedText.count <= 16
    }
}


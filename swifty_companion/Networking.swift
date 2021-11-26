//
//  ApiConnection.swift
//  swifty_companion
//
//  Created by Lidia Grigoreva on 29.07.2021.
//

import Foundation
import UIKit

class ApiConnection {
  // TODO: save token in Keychain
    private var token = String()
    private let UID = "1dcd2fe1f58d430c8fc484b4ca8900cbcf3c7843c9ce879095592577e7973979"
    private let SECRET = "3ca74e73ede4504afa8ca14f54cb57823e16dfc397141c6978c7f1cb1387add7"
    weak var delegate : APIIntra42Delegate?
    
    init(apiDelegate: APIIntra42Delegate?) {
        self.delegate = apiDelegate
    }
    
  func getToken() {
      if token.isEmpty {
          let url = URL(string: "https://api.intra.42.fr/oauth/token".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
          let data = ["grant_type":"client_credentials", "client_id":"\(UID)", "client_secret":"\(SECRET)"]
          
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.httpBody = try? JSONSerialization.data(withJSONObject: data)
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          
          let session = URLSession.shared
          session.dataTask(with: request) { (data, response, error) in
              if let err = error {
                  print(err)
                  return
              }
              guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                  print(response!)
                  return
              }
              if let recievedData = data {
                  do {
                      let json = try JSONSerialization.jsonObject(with: recievedData) as! Dictionary<String, AnyObject>
                      guard let currentToken = json["access_token"] as? String else { return }
                      self.token = currentToken
                      print("Token successfully received")
                  } catch let err {
                      print(err)
                  }
              }
          }.resume()
      }
  }
  
    func getTokenAndMakeRequest(username: String) {
        if token.isEmpty {
            let url = URL(string: "https://api.intra.42.fr/oauth/token".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
            let data = ["grant_type":"client_credentials", "client_id":"\(UID)", "client_secret":"\(SECRET)"]
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: data)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let err = error {
                    print(err)
                    return
                }
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    print(response!)
                    return
                }
                if let recievedData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: recievedData) as! Dictionary<String, AnyObject>
                        guard let currentToken = json["access_token"] as? String else { return }
                        self.token = currentToken
                        print("Token successfully received")
                        self.findUser(username: username)
                    } catch let err {
                        print(err)
                    }
                }
            }.resume()
        } else {
            findUser(username: username)
        }
    }
    
    private func findUser(username: String) {
        if !username.isEmpty {
            let url = URL(string: "https://api.intra.42.fr/v2/users/\(username)"
                            .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let err = error {
                    print(err)
                  // TODO: show alert error when no internet or smth else
                    return
                }
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    let code = (response as? HTTPURLResponse)?.statusCode
                    if code == 401 {
                        self.token.removeAll()
                        self.getTokenAndMakeRequest(username: username)
                    } else {
                        print ("Alert")
                        self.delegate?.errorOccured(error: NSError(domain: "https://api.intra.42.fr/v2/users/\(username)", code: code ?? 400, userInfo: ["username": "\(username)"]))
                    }
                    return
                }
                if let recievedData = data {
                    do {
                        let user = try JSONDecoder().decode(User.self, from: recievedData)
                        self.delegate?.processData(data: user)
                    } catch let err {
                        print(err)
                    }
                }
            }.resume()
        } else {
            self.delegate?.errorOccured(error: NSError(domain: "https://api.intra.42.fr/v2/users/\(username)", code: 404 , userInfo: ["username": "\(username)"]))
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


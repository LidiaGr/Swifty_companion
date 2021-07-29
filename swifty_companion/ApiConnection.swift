//
//  ApiConnection.swift
//  swifty_companion
//
//  Created by Lidia Grigoreva on 29.07.2021.
//

import Foundation
import UIKit

class ApiConnection {
    private var token = String()
    private let UID = "be7059d0939c5aa48803d0c69f6372a85794ac39ab90814f338766f9e25c4f4a"
    private let SECRET = "27d4796f7fc88b986b6d0052a13560d3719950157344d21456a5bd5016a387ea"
    weak var delegate : APIIntra42Delegate?
    
    init(apiDelegate: APIIntra42Delegate?) {
        self.delegate = apiDelegate
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


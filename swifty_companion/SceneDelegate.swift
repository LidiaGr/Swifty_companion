//
//  SceneDelegate.swift
//  day04
//
//  Created by Lidia Grigoreva on 23.06.2021.
//

import UIKit

var Token : String? = nil

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let rootVC = ViewController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navVC = UINavigationController(rootViewController: rootVC)
        window.rootViewController = navVC
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        self.getAccessToken { token in
            Token = token
            print("Token successfully received")
            self.rootVC.updateUI()
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func getAccessToken(completion: @escaping (String) -> () ) {
        let UID = "be7059d0939c5aa48803d0c69f6372a85794ac39ab90814f338766f9e25c4f4a"
        let SECRET = "27d4796f7fc88b986b6d0052a13560d3719950157344d21456a5bd5016a387ea"
        let url = URL(string: "https://api.intra.42.fr/oauth/token".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        let data = ["grant_type":"client_credentials", "client_id":"\(UID)", "client_secret":"\(SECRET)"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
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
                    completion(currentToken)
                } catch let err {
                    print(err)
                }
            }
        }
        
        dataTask.resume()
    }
    
}


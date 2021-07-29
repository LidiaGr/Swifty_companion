//
//  ProfileViewController.swift
//  swifty_companion
//
//  Created by Lidia Grigoreva on 28.07.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    let login = UILabel()
    let level = UILabel()
    let wallet = UILabel()
    let location = UILabel()
    let avatar = UIImage()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = "Profile"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

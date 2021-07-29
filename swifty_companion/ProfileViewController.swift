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
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Profile"
        navigationController?.navigationBar.tintColor = UIColor(hexString: "#009294")
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
    }
    

}

//
//  ProfileViewController.swift
//  swifty_companion
//
//  Created by Lidia Grigoreva on 28.07.2021.
//

import UIKit

class ProfileViewController: UIViewController {
  var user: User!
  
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var contentView: UIView!
  
  @IBOutlet private weak var avatar: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var wallet: UILabel!
  @IBOutlet private weak var evalPoints: UILabel!
  @IBOutlet private weak var lvl: UILabel!
  @IBOutlet private weak var avaliable: UILabel!
  @IBOutlet private weak var location: UILabel!
  @IBOutlet private weak var campus: UILabel!
  
  @IBOutlet private weak var projectsTable: UITableView!
  @IBOutlet private weak var skillsTable: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.setNavigationBarHidden(false, animated: false)
    self.title = "Profile"
    navigationController?.navigationBar.tintColor = UIColor(hexString: "#009294")
    
    view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
    
    displayProfileData()
    setupProjectsTable()
  }
}

extension ProfileViewController {
  func displayProfileData() {
    avatar.load(url: URL(string: user.image_url)!)
    avatar.layer.cornerRadius = avatar.frame.size.width / 2
    
    nameLabel.text = user.displayname
    wallet.text = String(user.wallet)
    evalPoints.text = String(user.correction_point)
    var index = user.cursus_users.count - 1
    lvl.text = "Level " + String(user.cursus_users[index].level)
    
    if user.location != nil  {
      avaliable.text = "Available"
      location.text = user.location
    }
    
    index = user.campus.count - 1
    campus.text = user.campus[index].name
  }
}

extension ProfileViewController {
  func setupProjectsTable() {
    projectsTable.delegate = self
    projectsTable.dataSource = self
    projectsTable.register(CustomCell.self, forCellReuseIdentifier: "projectCell")
  }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return user.projects_users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! CustomCell
    cell.awakeFromNib()
    let theVisit = user.projects_users[indexPath.row]
    cell.setProjectValue(value: theVisit.project.name)
    cell.setFinalMark(value: theVisit.final_mark)
    return cell
  }
}

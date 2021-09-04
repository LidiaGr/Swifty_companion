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
  
  private let identifier = "CustomCell"
  private var projectsInLastCursus = [Project]()
  
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
    projectsTable.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    
    projectsTable.backgroundColor = UIColor(hexString: "#202026").withAlphaComponent(0.85)
    projectsTable.separatorColor = UIColor(hexString: "#01A2A4")
    projectsTable.separatorStyle = .singleLine
    projectsTable.rowHeight = 44
    
    projectsInLastCursusSetup()
  }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
  
  func projectsInLastCursusSetup() {
    let id = user.projects_users[0].cursus_ids
    for project in user.projects_users {
      if project.final_mark != nil && project.cursus_ids == id {
        projectsInLastCursus.append(project)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return projectsInLastCursus.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CustomCell
    let theProject = projectsInLastCursus[indexPath.row]
    cell.setupStatus(status: theProject.status)
    cell.setupFinalMark(value: theProject.final_mark)
    cell.setupProjectName(value: theProject.project.name)
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = UIColor.clear
  }
}

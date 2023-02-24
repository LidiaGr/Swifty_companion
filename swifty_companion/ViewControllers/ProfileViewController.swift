//
//  ProfileViewController.swift
//  swifty_companion
//
//  Created by Lidia Grigoreva on 28.07.2021.
//

import UIKit

class ProfileViewController: UIViewController {
  var user: User!
  
  // MARK: - Private properties
  
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
  
  @IBOutlet private weak var lvlLineBack: UIView!
  @IBOutlet private weak var lvlLineFront: UIView!
  
  private let identifierProject = "CustomProjectCell"
  private let identifierSkill = "CustomSkillCell"
  private var projectsInLastCursus = [Project]()
  private var userLvl: Double = 0.0
  
  // MARK: - Overriden
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
    
    displayProfileData()
    setupProjectsTable()
    setupSkillsTable()
  }
}

// MARK: - Private methods

extension ProfileViewController {
  private func displayProfileData() {
    avatar.load(url: URL(string: user.image.link)!)
    avatar.layer.cornerRadius = avatar.frame.size.width / 2
    
    nameLabel.text = user.displayname
    wallet.text = String(user.wallet)
    evalPoints.text = String(user.correction_point)
    var index = user.cursus_users.count - 1
    userLvl = user.cursus_users[index].level
    lvl.text = "Level " + String(userLvl)
    
    if user.location != nil  {
      avaliable.text = "Available"
      location.text = user.location
    }
    
    index = user.campus.count - 1
    campus.text = user.campus[index].name
    
    setupLvlLine()
  }
  
  private func setupLvlLine() {
    let widthPercent = CGFloat(userLvl.truncatingRemainder(dividingBy: 1) * 100)
    let width = (UIScreen.main.bounds.width - 40) * widthPercent / 100
    lvlLineFront.widthAnchor.constraint(equalToConstant: width).isActive = true
  }
}

extension ProfileViewController {
  private func setupProjectsTable() {
    projectsTable.delegate = self
    projectsTable.dataSource = self
    projectsTable.register(UINib(nibName: identifierProject, bundle: nil), forCellReuseIdentifier: identifierProject)
    
    projectsTable.backgroundColor = UIColor(hexString: "#202026").withAlphaComponent(0.85)
    projectsTable.separatorColor = UIColor(hexString: "#01A2A4")
    projectsTable.separatorStyle = .singleLine
    projectsTable.rowHeight = 44
    
    projectsInLastCursusSetup()
  }
  
  private func setupSkillsTable() {
    skillsTable.delegate = self
    skillsTable.dataSource = self
    skillsTable.register(UINib(nibName: identifierSkill, bundle: nil), forCellReuseIdentifier: identifierSkill)
    
    skillsTable.backgroundColor = UIColor(hexString: "#202026").withAlphaComponent(0.85)
    skillsTable.separatorColor = UIColor(hexString: "#01A2A4")
    skillsTable.separatorStyle = .singleLine
    skillsTable.rowHeight = 44
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
  
  private func projectsInLastCursusSetup() {
    if !user.projects_users.isEmpty {
      let id = user.projects_users[0].cursus_ids
      for project in user.projects_users {
        if project.final_mark != nil && project.cursus_ids == id && project.project.parent_id == nil {
          projectsInLastCursus.append(project)
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView {
    
    case projectsTable:
      return projectsInLastCursus.count
      
    default:
      let index = user.cursus_users.count - 1
      return user.cursus_users[index].skills.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    
    case projectsTable:
      let cell = tableView.dequeueReusableCell(withIdentifier: identifierProject, for: indexPath) as! CustomProjectCell
      let theProject = projectsInLastCursus[indexPath.row]
      cell.setupStatus(status: theProject.validated)
      cell.setupFinalMark(value: theProject.final_mark)
      cell.setupProjectName(value: theProject.project.name)
      return cell
      
    default:
      let index = user.cursus_users.count - 1
      let cell = tableView.dequeueReusableCell(withIdentifier: identifierSkill, for: indexPath) as! CustomSkillCell
      cell.selectionStyle = .none
      let theSkill = user.cursus_users[index].skills[indexPath.row]
      cell.setupSkillLvl(value: theSkill.level)
      cell.setupSkillName(value: theSkill.name)
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = UIColor.clear
  }
}


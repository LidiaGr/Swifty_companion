//
//  CustomSkillCell.swift
//  swifty_companion
//
//  Created by Temple Tarsha on 9/11/21.
//

import UIKit

final class CustomSkillCell: UITableViewCell {
  // MARK: IBOutlets
  @IBOutlet private weak var skillName: UILabel!
  @IBOutlet private weak var skillLvl: UILabel!
  
  // MARK: Private Usage Properties
  
  // MARK: Overriden properties
  
  // MARK: Overriden methods
  
  override func awakeFromNib() {
    super.awakeFromNib()
    resetToEmptyState()
    initialSetup()
  }
  
  // MARK: Interface
  
  func resetToEmptyState() {}
  
  func setupSkillName(value: String) {
    skillName.text = value.lowercased()
    
  }
  
  func setupSkillLvl(value: Double) {
    skillLvl.text = String(format: "%.2f", value)
  }
  
  // MARK: Private actions
  
  private func initialSetup() {
    skillName.text = ""
    skillLvl.text = ""
    [skillName, skillLvl].forEach { $0?.textColor = UIColor(hexString: "#5cb85c") }
  }
}

//
//  CustomCell.swift
//  swifty_companion
//
//  Created by L.Grigoreva on 03.09.2021.
//

import UIKit

final class CustomCell: UITableViewCell {
  // MARK: IBOutlets
  @IBOutlet private weak var project: UILabel!
  @IBOutlet private weak var finalMark: UILabel!
  
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
  
  func setProjectValue(value: String) {
    project.text = value
  }
  
  func setFinalMark(value: Int?) {
    guard let mark = value else { return }
      finalMark.text = String(mark)
  }
  
  // MARK: Private actions
  
  private func initialSetup() {
    project.text = ""
    finalMark.text = ""
  }
  
  
}

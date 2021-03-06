//
//  CustomCell.swift
//  swifty_companion
//
//  Created by L.Grigoreva on 03.09.2021.
//

import UIKit

final class CustomProjectCell: UITableViewCell {
  // MARK: IBOutlets
  @IBOutlet private weak var projectName: UILabel!
  @IBOutlet private weak var finalMark: UILabel!
  
  // MARK: Private Usage Properties
  enum Status {
    case success
    case failure
  }
  
  private var stat = Status.success
  private var color = UIColor()
  
  // MARK: Overriden properties
  
  // MARK: Overriden methods

  override func awakeFromNib() {
    super.awakeFromNib()
    resetToEmptyState()
    initialSetup()
  }
  
  // MARK: Interface

  func resetToEmptyState() {}
  
  func setupStatus(status: Bool?) {
    guard let status = status else { return }
    stat = status == true ? Status.success : Status.failure
    
    switch stat {
    case .success: color = UIColor(hexString: "#39D88F")
    case .failure: color = UIColor(hexString: "#D8636F")
    }
  }
  
  func setupProjectName(value: String) {
    projectName.text = value.lowercased()
    projectName.textColor = color
  }
  
  func setupFinalMark(value: Int?) {
    guard let mark = value else { return }
    switch stat {
    case .success: finalMark.text = "✓ " + String(mark)
    case .failure: finalMark.text = "✗ " + String(mark)
    }
    finalMark.textColor = color
  }
  
  // MARK: Private actions
  
  private func initialSetup() {
    projectName.text = ""
    finalMark.text = ""
  }
}

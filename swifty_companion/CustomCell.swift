//
//  CustomCell.swift
//  day04
//
//  Created by Lidia Grigoreva on 24.06.2021.
//

import UIKit

class CustomCell : UITableViewCell {
    let dateLable : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLable : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hostLable : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(dateLable)
        self.contentView.addSubview(timeLable)
        self.contentView.addSubview(hostLable)
        
        //Horizontal Position for each label
        dateLable.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        dateLable.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        timeLable.leadingAnchor.constraint(equalTo: dateLable.leadingAnchor).isActive = true
        timeLable.trailingAnchor.constraint(equalTo: dateLable.trailingAnchor).isActive = true
        hostLable.leadingAnchor.constraint(equalTo: dateLable.leadingAnchor).isActive = true
        hostLable.trailingAnchor.constraint(equalTo: dateLable.trailingAnchor).isActive = true
        
        //Vertical Position for each label
        dateLable.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.topAnchor, multiplier: 1).isActive = true
        contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: hostLable.lastBaselineAnchor, multiplier: 1).isActive = true
        
        timeLable.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: dateLable.lastBaselineAnchor, multiplier: 1).isActive = true
        hostLable.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: timeLable.lastBaselineAnchor, multiplier: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


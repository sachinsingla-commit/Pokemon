//
//  AbilityCell.swift
//  Pokemon
//
//  Created by Sachin's Macbook Pro on 14/06/21.
//

import UIKit
class AbilityCell: UITableViewCell {
    let abilityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        abilityLabel.frame = CGRect(x: 20, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        addSubview(abilityLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

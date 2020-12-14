//
//  ProjectTableViewCell.swift
//  Project Scheduler
//
//  Created by Sue Ni on 12/5/20.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    var nameLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //93, 120, 163
        let lightBlue = UIColor(red: 93/255, green: 120/255, blue: 163/255, alpha: 1.00)
        //227, 182, 154
        let lightBrown = UIColor(red: 227/255, green: 182/255, blue: 154/255, alpha: 1.00)
        contentView.backgroundColor = lightBlue
        contentView.layer.cornerRadius = 5

        selectionStyle = .none

        nameLabel = UILabel()
        nameLabel.textColor = lightBrown
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 30)
        contentView.addSubview(nameLabel)
        
        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {

        let padding: CGFloat = 20
        //let width: CGFloat = 80
        let height: CGFloat = 80

        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: height)
        ])
        
        
    }

    func configure(for Project:Project) {
        nameLabel.text = Project.name
    }

    

}

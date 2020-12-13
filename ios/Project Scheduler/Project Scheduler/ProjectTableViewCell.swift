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

        selectionStyle = .none

        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 30)
        contentView.addSubview(nameLabel)
        
        setupConstraints()
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

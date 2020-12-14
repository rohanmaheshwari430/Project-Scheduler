//
//  TaskTableViewCell.swift
//  Project Scheduler
//
//  Created by Ethan Yu on 12/13/20.
//
import UIKit

class TaskTableViewCell: UITableViewCell {
    var nameLabel: UILabel!
    var deadlineLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        selectionStyle = .blue
        
        nameLabel = UILabel()
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 15)
        contentView.addSubview(nameLabel)
        
        deadlineLabel = UILabel()
        deadlineLabel.textColor = .black
        deadlineLabel.textAlignment = .left
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        deadlineLabel.font = .systemFont(ofSize: 10)
        contentView.addSubview(deadlineLabel)
        
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints(){
        
        let padding: CGFloat = 10
        let padding1: CGFloat = 20
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding1),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 15),
            
            deadlineLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            deadlineLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            deadlineLabel.heightAnchor.constraint(equalToConstant: 10)
        ])
        
    }
    
    func configure(for Task: Task) {
        nameLabel.text = "Task: " + Task.name
        deadlineLabel.text = "Deadline: " + Task.deadline
    }

}

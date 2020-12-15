//
//  AddTaskViewController.swift
//  Project Scheduler
//
//  Created by Ethan Yu on 12/13/20.
//

import UIKit

class AddTaskViewController: UIViewController {
    var nameLabel: UILabel!
    var name: UITextField!
    var deadlineLabel: UILabel!
    var deadline: UITextField!
    var contentLabel: UILabel!
    var content: UITextView!
    var addButton: UIButton!
    var memberLabel:UILabel!
    var member:UITextField!
    var email:UITextField!
    var addUserButton:UIButton!
    var Users:[String:String]!
    var projectId:Int!
    var taskId:Int!
    weak var delegate: TaskDelegate?
    
    init(delegate: TaskDelegate?, id:Int) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.projectId = id
        self.Users = [:]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lightBlue = UIColor(red: 93/255, green: 120/255, blue: 163/255, alpha: 1.00)
        let lightGreen = UIColor(red: 121/255, green: 219/255, blue: 116/255, alpha: 1.00)
        view.backgroundColor = lightBlue
        self.title = "Add Task"
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 25)
        nameLabel.textColor = .lightGray
        nameLabel.text = "TITLE:"
        nameLabel.textAlignment = .right
        view.addSubview(nameLabel)
        
        name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: 30)
        name.borderStyle = .roundedRect
        name.layer.cornerRadius = 5.0
        name.layer.borderWidth = 0.7
        name.backgroundColor = lightBlue
        name.clearButtonMode = UITextField.ViewMode.whileEditing
        name.textColor = .white
        name.textAlignment = .center
        //name.placeholder = "Name of Task"
        view.addSubview(name)
        
        deadlineLabel = UILabel()
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        deadlineLabel.font = .systemFont(ofSize: 25)
        deadlineLabel.text = "DEADLINE:"
        deadlineLabel.textAlignment = .right
        deadlineLabel.textColor = .lightGray
        view.addSubview(deadlineLabel)
        
        deadline = UITextField()
        deadline.translatesAutoresizingMaskIntoConstraints = false
        deadline.font = .systemFont(ofSize: 30)
        deadline.borderStyle = .roundedRect
        deadline.layer.cornerRadius = 5.0
        deadline.layer.borderWidth = 0.7
        deadline.backgroundColor = lightBlue
        deadline.clearButtonMode = UITextField.ViewMode.whileEditing
        deadline.textColor = .white
        deadline.textAlignment = .center
        deadline.placeholder = "mm/dd/yy"
        view.addSubview(deadline)
        
        contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = .systemFont(ofSize: 25)
        contentLabel.text = "NOTE:"
        contentLabel.textColor = .lightGray
        //contentLabel.textAlignment = .left
        view.addSubview(contentLabel)
        
        content = UITextView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.font = .systemFont(ofSize: 15)
        content.layer.cornerRadius = 5.0
        content.layer.borderWidth = 0.7
        content.backgroundColor = lightBlue
        content.clipsToBounds = true
        content.textAlignment = .left
        content.textColor = .white
        view.addSubview(content)
        
        addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("  ADD  ", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = lightGreen
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.borderWidth = 0.8
        addButton.layer.cornerRadius = 8
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        view.addSubview(addButton)
        
        memberLabel = UILabel()
        memberLabel.translatesAutoresizingMaskIntoConstraints = false
        memberLabel.font = .systemFont(ofSize: 25)
        memberLabel.textColor = .lightGray
        memberLabel.text = "User:"
        memberLabel.textAlignment = .right
        view.addSubview(memberLabel)
        
        member = UITextField()
        member.translatesAutoresizingMaskIntoConstraints = false
        member.font = .systemFont(ofSize: 30)
        member.borderStyle = .roundedRect
        member.layer.cornerRadius = 5.0
        member.layer.borderWidth = 0.7
        member.backgroundColor = lightBlue
        member.clearButtonMode = UITextField.ViewMode.whileEditing
        member.textColor = .white
        member.textAlignment = .center
        member.placeholder = "Name"
        view.addSubview(member)
        
        email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.font = .systemFont(ofSize: 30)
        email.borderStyle = .roundedRect
        email.layer.cornerRadius = 5.0
        email.layer.borderWidth = 0.7
        email.backgroundColor = lightBlue
        email.clearButtonMode = UITextField.ViewMode.whileEditing
        email.textColor = .white
        email.textAlignment = .center
        email.placeholder = "Email"
        view.addSubview(email)
        
        addUserButton = UIButton()
        addUserButton.translatesAutoresizingMaskIntoConstraints = false
        addUserButton.setTitle("  ADD MEMBER ", for: .normal)
        addUserButton.setTitleColor(.white, for: .normal)
        addUserButton.backgroundColor = lightGreen
        addUserButton.layer.borderColor = UIColor.black.cgColor
        addUserButton.layer.borderWidth = 0.8
        addUserButton.layer.cornerRadius = 8
        addUserButton.addTarget(self, action: #selector(addUser), for: .touchUpInside)
        view.addSubview(addUserButton)
        
        setupConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    func setupConstraints(){
        let height: CGFloat = 30
        let leftPadding: CGFloat = 50
        let topPadding: CGFloat = 100
        let padding1: CGFloat = 30
        let padding2: CGFloat = 50
        let padding3: CGFloat = 20
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding2),
            //nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: height),
            nameLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -padding2),

            name.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            name.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: padding1),
            name.heightAnchor.constraint(equalToConstant: height),
            name.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding3),

            deadlineLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding1),
            //deadlineLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            deadlineLabel.heightAnchor.constraint(equalToConstant: height),
            deadlineLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            deadline.topAnchor.constraint(equalTo: deadlineLabel.topAnchor),
            deadline.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            deadline.heightAnchor.constraint(equalToConstant: height),
            deadline.trailingAnchor.constraint(equalTo: name.trailingAnchor),

            contentLabel.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor, constant: padding1),
            contentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            contentLabel.heightAnchor.constraint(equalToConstant: height),
            contentLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -padding2),

            content.topAnchor.constraint(equalTo: contentLabel.topAnchor),
            content.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            content.heightAnchor.constraint(equalToConstant: height * 5.0),
            content.trailingAnchor.constraint(equalTo: name.trailingAnchor),

            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -topPadding),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: height),
            
            memberLabel.topAnchor.constraint(equalTo: content.bottomAnchor, constant: padding1),
            memberLabel.heightAnchor.constraint(equalToConstant: height),
            memberLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: -padding1),
            member.topAnchor.constraint(equalTo: memberLabel.bottomAnchor, constant: padding1),
            member.leadingAnchor.constraint(equalTo: memberLabel.leadingAnchor),
            member.heightAnchor.constraint(equalToConstant: height),
            member.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            email.topAnchor.constraint(equalTo: member.bottomAnchor, constant: padding1),
            email.leadingAnchor.constraint(equalTo: member.leadingAnchor),
            email.heightAnchor.constraint(equalToConstant: height),
            email.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            addUserButton.topAnchor.constraint(equalTo: email.bottomAnchor, constant: padding1),
            addUserButton.leadingAnchor.constraint(equalTo: memberLabel.trailingAnchor, constant: padding2),
            addUserButton.heightAnchor.constraint(equalToConstant: height)
        ])
        
    }
    
    @objc func add(){
        if let text = name.text, text != "", let deadlineText = deadline.text, let contentText = content.text {
            delegate?.createTask(title: text, deadline: deadlineText, body:contentText, users: Users)
            dismiss(animated: true, completion: nil)
        }else{
            let alertController = UIAlertController(title: "Alert", message: "The name of the task cannot be empty.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .default) {_ in }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @objc func addUser(){
        if let text = member.text, text != "", let text1 = email.text, text1 != "" {
            Users[text] = text1
            member.text = ""
            email.text = ""
        }else{
            let alertController = UIAlertController(title: "Alert", message: "The name or email cannot be empty.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .default) {_ in }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  AddViewController.swift
//  Project Scheduler
//
//  Created by Sue Ni on 12/5/20.
//

import UIKit

class AddViewController: UIViewController {
    var name: UITextField!
    var content: UITextView!
    var nameLabel:UILabel!
    weak var delegate: SaveDelegate?
    
    init(delegate: SaveDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lightBlue = UIColor(red: 93/255, green: 120/255, blue: 163/255, alpha: 1.00)
        view.backgroundColor = lightBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "CREATE", style: .plain, target: self, action: #selector(add))
        //121, 219, 116
        let lightGreen = UIColor(red: 121/255, green: 219/255, blue: 116/255, alpha: 1.00)
        navigationItem.rightBarButtonItem?.tintColor = lightGreen
        name = UITextField()
        content = UITextView()
        setUpTextField(textField: name, size: 30)
        name.placeholder = "Name of Project"
        name.layer.borderWidth = 1
        name.backgroundColor = lightBlue
        name.textColor = .white
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = lightBlue
        content.layer.borderWidth = 1
        //textField.textAlignment = .center
        content.font = .systemFont(ofSize: 15)
        content.layer.cornerRadius = 5.0;
        content.clipsToBounds = true;
        content.textColor = .white
        
        view.addSubview(content)
        nameLabel = UILabel()
        nameLabel.text = "Project Description(Optional):"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.textColor = .white
        view.addSubview(nameLabel)
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    
    func setUpTextField(textField:UITextField, size:Int){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5.0;
        //textField.textAlignment = .center
        textField.font = .systemFont(ofSize: CGFloat(size))
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        view.addSubview(textField)
    }
    
    func setupConstraints() {
        // textField constraints
        let anchor1:CGFloat = 50
        let anchor2:CGFloat = 50
        let height:CGFloat = 50
        //let size:CGFloat = 200
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: anchor1),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: anchor2),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -anchor2),
            name.heightAnchor.constraint(equalToConstant: height),
            
            nameLabel.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: anchor1),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            content.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: anchor2),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -anchor2),
            content.heightAnchor.constraint(equalToConstant: height*3)
            ])

    }
    
    @objc func add() {
        if let text = name.text, text != ""{
            delegate?.save(title: text, description: content.text)
        }else{
            let alertController = UIAlertController(title: "Alert", message: "The name of the project cannot be empty.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .default) {_ in }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

}

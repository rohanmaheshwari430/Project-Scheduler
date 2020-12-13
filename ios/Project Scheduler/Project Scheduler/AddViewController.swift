//
//  AddViewController.swift
//  Project Scheduler
//
//  Created by Sue Ni on 12/5/20.
//

import UIKit

class AddViewController: UIViewController {
    var name: UITextField!
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
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(add))
        name = UITextField()
        setUpTextField(textField: name)
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    
    func setUpTextField(textField:UITextField){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 30)
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
            name.heightAnchor.constraint(equalToConstant: height)
            ])

    }
    
    @objc func add() {
        if let text = name.text{
            delegate?.save(newName: text)
        }else{
            let alertController = UIAlertController(title: "Alert", message: "The name of the project cannot be empty.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .default) {_ in }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

}

//
//  ProjectViewController.swift
//  Project Scheduler
//
//  Created by Ethan Yu on 12/13/20.
//

import UIKit

protocol TaskDelegate: class {
    func createTask(title: String, deadline: String, body: String, users: [String: String])
}

class ProjectViewController: UIViewController {
    
    var tableView: UITableView!
    var titleLabel: UILabel!
    var name: UITextField!
    var contentLabel: UILabel!
    var content: UITextView!
    var addTaskButton: UIButton!
    
    let reuseIdentifier = "CellReuse"
    let cellHeight: CGFloat = 55
    var tasks: [Task]!
    var project: Project!
    var id: Int!
    var taskid: Int!
    weak var delegate: ProjectDelegate?

    init(delegate: ProjectDelegate?, project: Project, id: Int) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.project = project
        self.id = id
        self.tasks = []
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lightBlue = UIColor(red: 93/255, green: 120/255, blue: 163/255, alpha: 1.00)
        //128, 176, 224
        //let lightBlue1 = UIColor(red: 128/255, green: 176/255, blue: 224/255, alpha: 1.00)
        let lightBrown = UIColor(red: 227/255, green: 182/255, blue: 154/255, alpha: 1.00)
        view.backgroundColor = lightBlue
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = cellHeight
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 25)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.text = "TITLE:"
        view.addSubview(titleLabel)
        
        name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: 30)
        name.borderStyle = .roundedRect
        name.layer.cornerRadius = 5.0
        name.layer.borderWidth = 1.5
        name.backgroundColor = lightBlue
        name.clearButtonMode = UITextField.ViewMode.whileEditing
        name.textColor = .white
        name.textAlignment = .center
        view.addSubview(name)
        
        contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = .systemFont(ofSize: 25)
        contentLabel.textColor = .white
        contentLabel.textAlignment = .left
        contentLabel.text = "CONTENT:"
        view.addSubview(contentLabel)
        
        content = UITextView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.font = .systemFont(ofSize: 20)
        //content.borderStyle = .roundedRect
        content.layer.cornerRadius = 5.0
        content.layer.borderWidth = 1.5
        content.backgroundColor = lightBlue
        //content.clearButtonMode = UITextField.ViewMode.whileEditing
        content.textColor = .white
        //content.textAlignment = .center
        view.addSubview(content)
        
        addTaskButton = UIButton()
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.setTitle(" + ADD TASK ", for: .normal)
        addTaskButton.setTitleColor(lightBrown, for: .normal)
        addTaskButton.backgroundColor = .white
        addTaskButton.layer.borderColor = lightBrown.cgColor
        addTaskButton.layer.borderWidth = 1
        addTaskButton.layer.cornerRadius = 8
        addTaskButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        view.addSubview(addTaskButton)

        // Do any additional setup after loading the view.
        setupConstraints()
        getProject()
        getTasks()
    }
    
    func setupConstraints(){
        //let topPadding: CGFloat = 50
        let leftAnchor: CGFloat = 20
        let padding1: CGFloat = 15
        let labelHeight: CGFloat = 25
        let fieldHeight: CGFloat = 120
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            name.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding1),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding1),
            name.heightAnchor.constraint(equalToConstant: labelHeight*2),
            name.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding1),
            
            contentLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: padding1),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            content.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: padding1),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding1),
            content.heightAnchor.constraint(equalToConstant: fieldHeight),
            content.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding1),
            
            addTaskButton.topAnchor.constraint(equalTo: content.bottomAnchor, constant: padding1),
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.heightAnchor.constraint(equalToConstant: labelHeight),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: addTaskButton.bottomAnchor, constant: padding1),
            //tableView.heightAnchor.constraint(equalToConstant: //view.heightAnchor / 2.0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func getProject() {
        
        NetworkManager.getProject(id: id) { project in
            self.project = project
        }
        name.text = project.title
        content.text = project.description
    }
    
    private func getTasks() {
        
        NetworkManager.getTasks(id: id) { tasks in
            self.tasks = tasks
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    @objc func addTask() {
        let newAddTaskViewController = AddTaskViewController(delegate: self, id: id)
        present(newAddTaskViewController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            if let titleText = name.text, titleText != "", let contentText = content.text {
                delegate?.save(title: titleText, description: contentText, id: id)
            }else{
                let alertController = UIAlertController(title: "Alert", message: "The name of the project cannot be empty.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Done", style: .default) {_ in }
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
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

extension ProjectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TaskTableViewCell
        let task = tasks[indexPath.row]
        cell.configure(for: task)
        return cell
    }
}

extension ProjectViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}

extension ProjectViewController: TaskDelegate {
    func createTask(title: String, deadline: String, body: String, users: [String : String]) {

        NetworkManager.createTask(id: self.id, title: title, deadline: deadline, body: body) { taskid in
            self.taskid = taskid
            print(self.taskid)
        }
        for (name, email) in users {
            print(taskid)
            print(self.taskid)
            NetworkManager.createUser(id: taskid , user: name, email: email) { result in
                let userCreated = result
                
                if userCreated {
                    print("created user " + name)
                }
                
            }
            
        }
    }
    
}





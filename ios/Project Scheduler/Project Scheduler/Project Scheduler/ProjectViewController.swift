//
//  ProjectViewController.swift
//  Project Scheduler
//
//  Created by Ethan Yu on 12/13/20.
//

import UIKit

protocol TaskDelegate: class {
    func saveTask(taskName: String, taskDeadline: String, taskContent: String)
}

class ProjectViewController: UIViewController {
    
    var tableView: UITableView!
    var titleLabel: UILabel!
    var name: UITextField!
    var contentLabel: UILabel!
    var content: UITextView!
    var addTaskButton: UIButton!
    
    let reuseIdentifier = "CellReuse"
    let cellHeight: CGFloat = 80
    var tasks: [Task]!
    var project: Project!
    var id: Int!
    weak var delegate: ProjectDelegate?

    init(delegate: ProjectDelegate?, project: Project, id: Int) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.project = project
        self.id = id
        self.tasks = project.Tasks
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lightBlue = UIColor(red: 93/255, green: 120/255, blue: 163/255, alpha: 1.00)
        let lightBrown = UIColor(red: 227/255, green: 182/255, blue: 154/255, alpha: 1.00)
        view.backgroundColor = lightBlue
        title = project.name
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = cellHeight
        tableView.register(TaskTableViewCell.self
            , forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 25)
        titleLabel.textColor = .lightGray
        titleLabel.textAlignment = .left
        titleLabel.text = "Title:"
        view.addSubview(titleLabel)
        
        name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: 30)
        name.backgroundColor = lightBlue
        name.clearButtonMode = UITextField.ViewMode.whileEditing
        name.textColor = .white
        name.textAlignment = .left
        name.text = project.name
        view.addSubview(name)
        
        contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = .systemFont(ofSize: 25)
        contentLabel.textColor = .lightGray
        contentLabel.textAlignment = .left
        contentLabel.text = "Content:"
        view.addSubview(contentLabel)
        
        content = UITextView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.font = .systemFont(ofSize: 30)
        content.backgroundColor = lightBlue
        content.isEditable = true
        content.textColor = .white
        content.textAlignment = .left
        content.text = project.content
        view.addSubview(content)
        
        addTaskButton = UIButton()
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.setTitle("Add Task", for: .normal)
        addTaskButton.setTitleColor(lightBrown, for: .normal)
        addTaskButton.backgroundColor = lightBlue
        addTaskButton.layer.borderColor = lightBrown.cgColor
        addTaskButton.layer.borderWidth = 0.8
        addTaskButton.layer.cornerRadius = 8
        addTaskButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        view.addSubview(addTaskButton)
        
        setupConstraints()

        // Do any additional setup after loading the view.
    }
    
    func setupConstraints(){
        let topPadding: CGFloat = 30
        let leftAnchor: CGFloat = 20
        let padding1: CGFloat = 15
        let labelHeight: CGFloat = 25
        let fieldHeight: CGFloat = 120
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            titleLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            name.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding1),
            name.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding1),
            name.heightAnchor.constraint(equalToConstant: labelHeight),
            contentLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: padding1),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            contentLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            content.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: padding1),
            content.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding1),
            content.heightAnchor.constraint(equalToConstant: fieldHeight),
            addTaskButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: padding1),
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.heightAnchor.constraint(equalToConstant: labelHeight),
            addTaskButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @objc func addTask() {
        let newAddTaskViewController = AddTaskViewController(delegate: self)
        present(newAddTaskViewController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            if let titleText = name.text, titleText != "", let contentText = content.text {
                
                delegate?.save(newName: titleText, newContent: contentText, newTasks: tasks, id: id)
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
    func saveTask(taskName: String, taskDeadline: String, taskContent: String) {
        let entryTask = Task(name: taskName, deadline: taskDeadline, content: taskContent)
        tasks.append(entryTask)
        tableView.reloadData()
    }
    
}





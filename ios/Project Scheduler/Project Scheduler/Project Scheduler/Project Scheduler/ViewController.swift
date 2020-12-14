//
//  ViewController.swift
//  Project Scheduler
//
//  Created by Sue Ni on 12/5/20.
//

import UIKit

protocol SaveDelegate: class {
    func save(newName: String, newContent:String)
}

protocol ProjectDelegate: class {
    func save(newName: String, newContent: String, newTasks: [Task], id: Int)
}
class ViewController: UIViewController {
    var tableView: UITableView!

    let reuseIdentifier = "CellReuse"
    let cellHeight: CGFloat = 80
    var Projects: [Project]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //title = "Projects"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+ NEW PROJECT", style: .plain, target: self, action: #selector(add))
        //181, 147, 125
        let darkBrown = UIColor(red: 181/255, green: 147/255, blue: 125/255, alpha: 1.00)
        navigationItem.rightBarButtonItem?.tintColor = darkBrown
        Projects = []
        
        // Initialize tableView!
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = cellHeight
        
        tableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)

        setupConstraints()
    }
    
    func setupConstraints() {
//        Setup the constraints for our views
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func add() {
        let vc = AddViewController(delegate:self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Projects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProjectTableViewCell
        let project = Projects[indexPath.row]
        cell.configure(for: project)
        return cell
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = Projects[indexPath.row]
        let newProjectViewController = ProjectViewController(delegate: self, project: project, id: indexPath.row)
        navigationController?.pushViewController(newProjectViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Projects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
}
extension ViewController: SaveDelegate {
    func save(newName: String, newContent:String) {
        let entry = Project(name: newName,content: newContent)
        Projects.append(entry)
        tableView.reloadData()
    }
}

extension ViewController: ProjectDelegate {
    func save(newName: String, newContent: String, newTasks: [Task], id: Int) {
        Projects[id].name = newName
        Projects[id].content = newContent
        Projects[id].Tasks = newTasks
        tableView.reloadData()
    }
}

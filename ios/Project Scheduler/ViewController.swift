//
//  ViewController.swift
//  Project Scheduler
//
//  Created by Sue Ni on 12/5/20.
//

import UIKit

protocol SaveDelegate: class {
    func save(title: String, description:String)
}

protocol ProjectDelegate: class {
    func save(title: String, description: String, id: Int)
}
class ViewController: UIViewController {
    var tableView: UITableView!

    let reuseIdentifier = "CellReuse"
    let cellHeight: CGFloat = 80
    var Projects: [Project]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //title = "Projects"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+ NEW PROJECT", style: .plain, target: self, action: #selector(add))
        //181, 147, 125
        let darkBrown = UIColor(red: 181/255, green: 147/255, blue: 125/255, alpha: 1.00)
        navigationItem.rightBarButtonItem?.tintColor = darkBrown
        
        // Initialize tableView!
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = cellHeight
        
        tableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        getProjects()
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
    
    func getProjects() {
        NetworkManager.getProjects { projects in
            self.Projects = projects
            print(self.Projects)
            self.tableView.reloadData()
        }
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
        let newProjectViewController = ProjectViewController(delegate: self, project: project, id: project.id)
        navigationController?.pushViewController(newProjectViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let id = Projects[indexPath.row].id
            NetworkManager.deleteProject(id: id) { result in
                let projectDeleted = result
                if projectDeleted {
                    print("Project deleted")
                }
                
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
}
extension ViewController: SaveDelegate {
    func save(title: String, description:String) {
        NetworkManager.createProject(title: title, description: description) { result in
            let tableLoad = result
            if tableLoad {
                print("Created project")
            }
            self.getProjects()
            self.tableView.reloadData()
            
        }
        navigationController?.popViewController(animated: true)
        
    }
}

extension ViewController: ProjectDelegate {
    func save(title: String, description: String, id: Int) {
        NetworkManager.updateProject(id: id, title: title, description: description) { result in
            let projectSave = result
            if projectSave {
                print("Saved Project")
            }
            self.getProjects()
            self.tableView.reloadData()
        }
    }
}

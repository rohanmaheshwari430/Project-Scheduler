//
//  NetworkManager.swift
//  Project Scheduler
//
//  Created by Ethan Yu on 12/14/20.
//

import Foundation
import Alamofire
// Change pod file and install for ios 14

class NetworkManager {
    
    private static let host = "https://project-scheduler-app.herokuapp.com"
    
    static func getProjects(completion: @escaping ([Project]) -> Void) {
        let endpoint = "\(host)/api/projects/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let projectsData = try? jsonDecoder.decode(ProjectsDataResponse.self, from: data) {
                    let projects = projectsData.data
                    
                    completion(projects)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getProject(id: Int, completion: @escaping (Project) -> Void) {
        let endpoint = "\(host)/api/projects/\(id)/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let project = try? jsonDecoder.decode(Project.self, from: data) {
                    // Instructions: Use completion to handle response
                    completion(project)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getTasks(id: Int, completion: @escaping ([Task]) -> Void) {
        let endpoint = "\(host)/api/projects/\(id)/tasks/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let tasksData = try? jsonDecoder.decode(TasksDataResponse.self, from: data) {
                    let tasks = tasksData.data
                    completion(tasks)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getTask(id: Int, completion: @escaping (Task) -> Void) {
        let endpoint = "\(host)/api/tasks/\(id)/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let task = try? jsonDecoder.decode(Task.self, from: data) {
                    // Instructions: Use completion to handle response
                    completion(task)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func updateProject(id: Int, title: String, description: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "title" : title,
            "description" : description
        ]
        let endpoint = "\(host)/api/projects/\(id)/"
        AF.request(endpoint, method: .patch, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    static func updateTask(id: Int, title: String, body: String, deadline: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "title": title,
            "body": body,
            "deadline": deadline
        ]
        let endpoint = "\(host)/api/tasks/\(id)/"
        AF.request(endpoint, method: .patch, parameters: parameters, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result {
            case .success(let data):
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        
    }
    
    static func deleteProject(id: Int, completion: @escaping (Bool) -> Void) {
        let endpoint = "\(host)/api/projects/\(id)/"
        AF.request(endpoint, method: .delete).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    static func deleteTask(id: Int, completion: @escaping (Bool) -> Void) {
        let endpoint = "\(host)/api/tasks/\(id)/"
        AF.request(endpoint, method: .delete).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    static func deleteUser(userid: Int, taskid: Int, completion: @escaping (Bool) -> Void) {
        let endpoint = "\(host)/api/tasks/\(taskid)/users/\(userid)/"
        AF.request(endpoint, method: .delete).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    static func createProject(title: String, description: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "title": title,
            "description": description
        ]
        let endpoint = "\(host)/api/projects/"
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    static func createTask(id: Int, title: String, deadline: String, body: String, completion: @escaping (Int) -> Void) {
        let parameters: [String: Any] = [
            "title": title,
            "deadline": deadline,
            "body": body
        ]
        print(id)
        let endpoint = "\(host)/api/tasks/\(id)/"
        print(parameters)
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            print("1")
            switch response.result {
            case .success(let data):
                print("2")
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let task = try? jsonDecoder.decode(Task.self, from: data) {
                    // Instructions: Use completion to handle response
                    print("3")
                    let result = task.id
                    print(result)
                    print("success")
                    completion(result)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            print("4")
        }
    }
    
    static func createUser(id: Int, user: String, email: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "user": user,
            "email": email
        ]
        let endpoint = "\(host)/api/tasks/\(id)/users/"
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}

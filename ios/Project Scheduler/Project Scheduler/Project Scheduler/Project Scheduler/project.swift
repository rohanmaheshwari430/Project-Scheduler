//
//  project.swift
//  Project Scheduler
//
//  Created by Sue Ni on 12/5/20.
//

import Foundation

class Project{
    var name:String
    var content:String
    //var users:String
    var Tasks:[Task]
    
    init(name:String, content:String) {
        self.name = name
        self.Tasks = []
        self.content = content
       // self.users =
    }
    
    func addTask(task:Task){
        Tasks.append(task)
    }
}

//
//  project.swift
//  Project Scheduler
//
//  Created by Sue Ni on 12/5/20.
//

import Foundation

class Project{
    var name:String
    var Tasks:[Task]
    
    init(name:String) {
        self.name = name
        self.Tasks = []
    }
    
    func addTask(task:Task){
        Tasks.append(task)
    }
}

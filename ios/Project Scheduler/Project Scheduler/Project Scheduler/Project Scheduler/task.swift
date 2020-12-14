//
//  task.swift
//  Project Scheduler
//
//  Created by Sue Ni on 12/11/20.
//

import Foundation

class Task{
    var name:String
    var deadline:String
    var content:String
    
    init(name:String, deadline:String, content:String) {
        self.name = name
        self.deadline = deadline
        self.content = content
    }
}

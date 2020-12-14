//
//  project.swift
//  Project Scheduler
//
//  Created by Sue Ni on 12/5/20.
//

import Foundation

class Project{
    var id: Int
    var title:String
    var description:String
    var users:[User]
    var tasks:[Task]
    
    init(title:String, description:String) {
        self.title = title
        self.tasks = []
        self.description = description
        self.users =
    }
}

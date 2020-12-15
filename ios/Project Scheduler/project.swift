//
//  project.swift
//  Project Scheduler
//
//  Created by Sue Ni on 12/5/20.
//

import Foundation

struct ProjectsDataResponse: Codable {
    
    var data: [Project]
    
}

struct Project: Codable {
    var id: Int
    var title:String
    var description:String
    var users:[Int]
    var tasks:[Task]
}

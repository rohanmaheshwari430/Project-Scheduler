//
//  task.swift
//  Project Scheduler
//
//  Created by Sue Ni on 12/11/20.
//

import Foundation

struct TasksDataResponse: Codable {
    var data: [Task]
}

struct Task: Codable{
    
    var id: Int
    var title: String
    var body: String
    var deadline: String
    var projectId: String

}


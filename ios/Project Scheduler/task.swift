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
    var body: String
    var deadline: String
    var id: Int
    //var projectId: Int
    var title: String
}


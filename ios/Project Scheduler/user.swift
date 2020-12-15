//
//  user.swift
//  Project Scheduler
//
//  Created by Ethan Yu on 12/14/20.
//

import Foundation

struct UsersDataResponse: Codable {
    
    var users: [User]
    
}
struct User: Codable {
    
    var id: Int
    var name: String
    var email: String
    var projects: [Project]
    var tasks: [Task]
    
}

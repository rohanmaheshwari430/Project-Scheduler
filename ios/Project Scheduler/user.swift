//
//  user.swift
//  Project Scheduler
//
//  Created by Ethan Yu on 12/14/20.
//

import Foundation

class User {
    var name:String
       var content:String
       var users:[User]
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

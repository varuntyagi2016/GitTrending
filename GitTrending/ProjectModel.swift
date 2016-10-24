//
//  ProjectModel.swift
//  reactSwift
//
//  Created by Varun Tyagi on 21/10/16.
//  Copyright © 2016 Varun Tyagi. All rights reserved.
//

import UIKit

class ProjectModel:NSObject {
    
    var projectName: String
    var Stars: Int
    var Forks: Int
    var projectDescription : String = ""
    var developerName :String
    var developerDescription : String = ""
    var devloperImage : String

    
    init(json: NSDictionary) {

        
        self.projectName = json.valueForKey("full_name") as! String! ?? ""
        self.Stars = json.valueForKey("stargazers_count") as! Int!
        self.Forks = json.valueForKey("forks_count") as! Int!
       // self.projectDescription = json.valueForKey("description") as! String! ?? ""
        if let descriptionStr = json["description"] as? String {
            //Here you received string 'category'
            self.projectDescription = descriptionStr
            self.developerDescription = descriptionStr
        }
        
      //  self.developerDescription =  json.valueForKey("description") as! String! ?? ""
        self.developerName = json.valueForKey("name") as! String!
        self.devloperImage = json.objectForKey("owner")?.valueForKey("avatar_url") as! String! ?? ""
    }
       
    
    
}


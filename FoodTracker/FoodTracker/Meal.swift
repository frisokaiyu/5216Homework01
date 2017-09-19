//
//  Meal.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log


class Meal: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var creationTime: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("items")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let creationTime = "creation time"
       
    }
    
    //MARK: Initialization
    
    init?(name: String, creationTime: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        
        // Initialize stored properties.
        self.name = name
        self.creationTime = creationTime
        
    }

    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(creationTime, forKey: PropertyKey.creationTime)
    
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let creationTime = aDecoder.decodeObject(forKey: PropertyKey.creationTime) as? String
        
        
        // Must call designated initializer.
        self.init(name: name, creationTime: creationTime!)
        
    }
}

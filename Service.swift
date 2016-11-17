//
//  Service.swift
//  Splittable_Test
//
//  Created by Daniel Robertson on 16/11/2016.
//  Copyright © 2016 Daniel Robertson. All rights reserved.
//

import UIKit

struct Service {
    var sortOrder: Int!
    var name: String!
    var imageURL: String!
    var url: String!
    var id: String!

    //Initialising with a dictionary - each param of the ServiceImage object then comes from the value for each key in the passed dictionary
    //init can return nil
    init?(dictionary: [String:Any]) {
        guard let sortOrder = dictionary["sort_order"] as? String else {
            return nil
        }
        self.sortOrder = Int(sortOrder)
        
        guard let id = dictionary["id"] as? String else {
            return nil
        }
        self.id = id
        
        guard let imageURL = dictionary["image_url"] as? String else {
            return nil
        }
        self.imageURL = imageURL
        
        guard let url = dictionary["url"] as? String else {
            return nil
        }
        self.url = url
        
        guard let name = dictionary["name"] as? String else {
            return nil
        }
        self.name = name
    }
    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encode(self.sortOrder, forKey: "sort_Order")
//        aCoder.encode(self.name, forKey: "name")
//        aCoder.encode(self.imageURL, forKey: "image_url")
//        aCoder.encode(self.id, forKey: "id")
//    }
//    
//    init?(coder aDecoder: NSCoder) {
//        self.sortOrder = aDecoder.decodeObject(forKey: "sort_order") as? Int
//        self.name = aDecoder.decodeObject(forKey: "name") as? String
//        self.imageURL = aDecoder.decodeObject(forKey: "image_url") as? String
//        self.id = aDecoder.decodeObject(forKey: "id") as? String
//    }
}

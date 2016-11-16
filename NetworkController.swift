//
//  NetworkController.swift
//  Splittable_Test
//
//  Created by Daniel Robertson on 16/11/2016.
//  Copyright © 2016 Daniel Robertson. All rights reserved.
//

import UIKit

class NetworkController: NSObject {
 
    var objects = [Service]()
    
    func performRequestTo(URLPath: String, completion:  @escaping ([Service]) -> (Void)) {
        let url: URL = URL(string: URLPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                print("error: \(error)")
                return
            }
            
            //try doing this, or perform catch statement
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: [])
                if let arrayFromJSON = jsonDict as? [[String:Any]] {
                    self.objects = arrayFromJSON.flatMap({ (item) -> Service? in
                        //creates new array, mapping each item to type ServiceImage. flatmap = any nils returned aren't included in array
                        return Service(dictionary: item)
                    })
                }
            }
            catch let error {
                print("Error: \(error)")
            }
            completion(self.objects)
        }
        task.resume()
    }
}

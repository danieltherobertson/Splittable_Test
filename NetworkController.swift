//
//  NetworkController.swift
//  Splittable_Test
//
//  Created by Daniel Robertson on 16/11/2016.
//  Copyright © 2016 Daniel Robertson. All rights reserved.
//

import UIKit

class NetworkController: NSObject {
 
    var services = [Service]()
    
    func performRequestTo(URLPath: String, completion: @escaping ([Service]) -> (Void)) {
        let url: URL = URL(string: URLPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                print("error: \(error)")
                
//                do { let loadedData = self.loadData()
//                completion(loadedData!)
//                } catch let error {
//                    print("Error:\(error)")
//                }
                return
            }
            
            //try doing this, or perform catch statement
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: [])
                if let arrayFromJSON = jsonDict as? [[String:Any]] {
                    self.services = arrayFromJSON.flatMap({ (item) -> Service? in
                        //creates new array, mapping each item to type ServiceImage.
                        return Service(dictionary: item)
                    })
                }
            }
            catch let error {
                print("Error: \(error)")
            }
            print("Network request complete!")
            completion(self.services)
        }
       // self.save(data: services)
        task.resume()
    }
    
//    func save(data: [Service]) {
//        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let writePath = directory.appendingPathComponent("/services.json")
//        
//        let dataToSave = NSKeyedArchiver.archivedData(withRootObject: data)
//        do {  try dataToSave.write(to: writePath) } catch let error { print("Error: \(error)") }
//    }
//    
//    func loadData() -> [Service]? {
//        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//        let readPath = directory.appending("/services.json")
//        
//        let fileMangager = FileManager.default
//        if fileMangager.fileExists(atPath: readPath) {
//            let data = NSData(contentsOfFile: readPath) as! Data
//            print("READ PATH: \(readPath)")
//            let savedServices = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Service]
//            print("SAVED SERVICES: \(savedServices)")
//            return savedServices
//        } else {
//            return nil
//        }
//    }
}

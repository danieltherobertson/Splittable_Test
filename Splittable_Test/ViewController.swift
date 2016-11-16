//
//  ViewController.swift
//  Splittable_Test
//
//  Created by Daniel Robertson on 16/11/2016.
//  Copyright © 2016 Daniel Robertson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    let networkController = NetworkController()
    let url = "https://sheetsu.com/apis/v1.0/aaf79d4763af"
    var servicesData = [Service]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkController.performRequestTo(URLPath: url) { (results) -> (Void) in
            self.servicesData = results.sorted(by:{ (serviceA, serviceB) -> Bool in
                return serviceA.sortOrder < serviceB.sortOrder
            })
            print("\n MEMES \n \(self.servicesData)")
        }
        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return servicesData.count
    }
}


extension UIViewController: UICollectionViewDelegateFlowLayout {
    
}


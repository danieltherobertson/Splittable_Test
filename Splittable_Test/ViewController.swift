//
//  ViewController.swift
//  Splittable_Test
//
//  Created by Daniel Robertson on 16/11/2016.
//  Copyright © 2016 Daniel Robertson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    let networkController = NetworkController()
    let url = "https://sheetsu.com/apis/v1.0/aaf79d4763af"
    var servicesData = [Service]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
        
        networkController.performRequestTo(URLPath: url) { (results) -> (Void) in
            self.servicesData = results.sorted(by:{ (serviceA, serviceB) -> Bool in
                return serviceA.sortOrder < serviceB.sortOrder
            })
            print("\n MEMES \n \(self.servicesData)")
            
            OperationQueue.main.addOperation {
                self.servicesCollectionView.reloadData()
            }
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}

extension ViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as! ServiceCell
        
        cell.backgroundColor = .red
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicesData.count
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 200)
    }
}




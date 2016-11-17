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
    var activeURL = ""
    
    let splittableYellow = UIColor(red: 239/255, green: 186/255, blue: 52/255, alpha: 1.0)
    let splittableRed = UIColor(red: 219/255, green: 96/255, blue: 91/255, alpha: 1.0)
    let splittableBlue = UIColor(red: 98/255, green: 188/255, blue: 236/255, alpha: 1.0)
    let splittableGreen = UIColor(red: 19/255, green: 91/255, blue: 167/255, alpha: 1.0)
    var splittableColours = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   UIApplication.shared.statusBarStyle = .lightContent

        
        splittableColours.append(splittableYellow);splittableColours.append(splittableRed);splittableColours.append(splittableBlue);splittableColours.append(splittableGreen)
        
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
        
        view.backgroundColor = UIColor(red: 52/255, green: 55/255, blue: 63/255, alpha: 1.0)
        servicesCollectionView.backgroundColor = .clear
        
        networkController.performRequestTo(URLPath: url) { (results) -> (Void) in
            self.servicesData = results.sorted(by:{ (serviceA, serviceB) -> Bool in
                return serviceA.sortOrder < serviceB.sortOrder
            })
          //  print("\n MEMES \n \(self.servicesData)")
            
            OperationQueue.main.addOperation {
                self.servicesCollectionView.reloadData()
            }
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowWebView"{
            let destinationViewController = segue.destination as! UINavigationController
            let targetController = destinationViewController.topViewController as! WebViewController
            print("URL BEING SENT IS:\(activeURL)")
            targetController.url = activeURL
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as! ServiceCell
        
        if indexPath.row < servicesData.count {
            cell.serviceName.text = servicesData[indexPath.row].name
            cell.url = servicesData[indexPath.row].url
            
            
           let urlString = String(servicesData[indexPath.row].imageURL)
            
            do { var myImage = try UIImage(data: NSData(contentsOf: NSURL(string:urlString!) as! URL) as Data)
                cell.serviceImage.image = myImage
            } catch let error {
                print("Error: \(error)")
            }
            
            cell.backgroundColor = splittableColours[indexPath.row % 4]
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 2.5
            cell.layer.borderColor = UIColor.white.cgColor
        }

        cell.serviceName.textColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicesData.count
    }
}



extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 150)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeCell = collectionView.cellForItem(at: indexPath) as! ServiceCell
        print(activeCell.serviceName.text)
        activeURL = activeCell.url
        performSegue(withIdentifier: "segueShowWebView", sender: self)
    }
}




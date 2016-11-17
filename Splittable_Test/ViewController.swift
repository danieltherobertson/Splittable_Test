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
    @IBOutlet weak var loadingServicesLabel: UILabel!
    let networkController = NetworkController()
    let url = "https://sheetsu.com/apis/v1.0/aaf79d4763af"
    var servicesData = [Service]()
    var activeURL = ""
    var activeServiceName = ""
    
    let splittableYellow = UIColor(red: 239/255, green: 186/255, blue: 52/255, alpha: 1.0)
    let splittableRed = UIColor(red: 219/255, green: 96/255, blue: 91/255, alpha: 1.0)
    let splittableBlue = UIColor(red: 98/255, green: 188/255, blue: 236/255, alpha: 1.0)
    let splittableGreen = UIColor(red: 19/255, green: 91/255, blue: 167/255, alpha: 1.0)
    var splittableColours = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splittableColours.append(splittableYellow);splittableColours.append(splittableRed);splittableColours.append(splittableBlue);splittableColours.append(splittableGreen)
        
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
        servicesCollectionView.contentInset.top = 20
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        view.backgroundColor = UIColor(red: 52/255, green: 55/255, blue: 63/255, alpha: 1.0)
        servicesCollectionView.backgroundColor = .clear
        
        // ---> PERFORM NETWORK REQUEST, RELOAD COLLECTIONVIEW ON COMPLETION <---
        networkController.performRequestTo(URLPath: url) { (results) -> (Void) in
            self.servicesData = results.sorted(by:{ (serviceA, serviceB) -> Bool in
                return serviceA.sortOrder < serviceB.sortOrder
            })

            OperationQueue.main.addOperation {
                self.loadingServicesLabel.isHidden = true
                self.servicesCollectionView.reloadData()
            }
        }
        
        // ---> SCHEDULE API POLLING <---
        let reloadData = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: "updataData" , userInfo: nil, repeats: true)
    }
    
    func updataData() {
        networkController.performRequestTo(URLPath: url) { (results) -> (Void) in
            self.servicesData = results.sorted(by:{ (serviceA, serviceB) -> Bool in
                return serviceA.sortOrder < serviceB.sortOrder
            })
            
            OperationQueue.main.addOperation {
                self.servicesCollectionView.reloadData()
            }
        }
    }
    
    // ---> SETUP PASSING URL FOR SEGUE TO WEBVIEW <---
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowWebView"{
            let destinationViewController = segue.destination as! WebViewController
            print("URL BEING SENT IS: \(activeURL)")
            destinationViewController.urlString = activeURL
            destinationViewController.navigationTitle = activeServiceName
            destinationViewController.navigationItem.hidesBackButton = false
        }
    
    }
}

// ---> SETUP DATA IN CELLS, SET NUMBER OF CELLS <---
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as! ServiceCell
        
        if indexPath.row < servicesData.count {
            cell.serviceName.text = servicesData[indexPath.row].name
            
            if servicesData[indexPath.row].url == "" {
                cell.serviceURL.text = nil
                cell.url = ""
            }
            // ---> Correct URLs with misspelling of 'Bizby' <---
            if servicesData[indexPath.row].url.contains("bizby")  {
                let fullURL = self.servicesData[indexPath.row].url!.replacingOccurrences(of: "bizby", with: "bizzby")
                let shorternedURL = fullURL.replacingOccurrences(of: "https://www.bizzby.com", with: "...")
                cell.serviceURL.text = shorternedURL
                cell.url = fullURL
                
            } else {
                let fullURL = self.servicesData[indexPath.row].url!
                let shorternedURL = fullURL.replacingOccurrences(of: "https://www.bizzby.com", with: "...")
                cell.serviceURL.text = shorternedURL
                cell.url = fullURL
            }
 
           let urlString = String(servicesData[indexPath.row].imageURL)
            
            do { var myImage = try UIImage(data: NSData(contentsOf: NSURL(string:urlString!) as! URL) as Data)
                cell.serviceImage.image = myImage
            } catch let error {
                print("Error: \(error)")
            }
            
            cell.backgroundColor = splittableColours[indexPath.row % 4]
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 2.5
            cell.layer.borderColor = UIColor(red: 218/255, green:223/255 , blue: 247/255, alpha: 1.0).cgColor
        }

        cell.serviceName.textColor = .white
        cell.serviceURL.textColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicesData.count
    }
}

// ---> SETUP CELL SPACING AND SIZE <---
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 5, 0, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 160, height: 150)
    }
}

// ---> SETUP CELL SELECTION <---
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeCell = collectionView.cellForItem(at: indexPath) as! ServiceCell
        
        if activeCell.url == "" {
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            activeURL = activeCell.url
            activeServiceName = activeCell.serviceName.text!
            performSegue(withIdentifier: "segueShowWebView", sender: self)
        }
    }
}




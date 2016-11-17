//
//  ServiceCell.swift
//  Splittable_Test
//
//  Created by Daniel Robertson on 16/11/2016.
//  Copyright © 2016 Daniel Robertson. All rights reserved.
//

import UIKit

class ServiceCell: UICollectionViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var serviceURL: UILabel!
    
    var url: String!
}

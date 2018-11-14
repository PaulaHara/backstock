//
//  Product.swift
//  Backstock
//
//  Created by paula on 2018-11-13.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import CoreData

@objc(Product)
class Product: NSManagedObject {
    
    func setupProperties(image: Data, productName: String, barCode: String, quantity: Int16) {
        self.image = image
        self.productName = productName
        self.barCode = barCode
        self.quantity = quantity
        
    }
}

//
//  ProductTableViewCell.swift
//  Backstock
//
//  Created by Paula on 11/14/18.
//  Copyright © 2018 paula. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBarCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func update(with product: Product) {
        productNameLabel.text = product.productName
        productBarCodeLabel.text = product.barCode
    }
    
}

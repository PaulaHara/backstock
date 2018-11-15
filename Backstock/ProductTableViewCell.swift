//
//  ProductTableViewCell.swift
//  Backstock
//
//  Created by Paula on 11/14/18.
//  Copyright © 2018 paula. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBarCodeLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func update(with product: Product) {
        if let image = product.image {
            productImage.image = UIImage(data: image)
        }
        productNameLabel.text = product.productName
        productBarCodeLabel.text = product.barCode
        productQuantityLabel.text = "\(product.quantity)"
    }
    
}

//
//  ProductTableViewController.swift
//  Backstock
//
//  Created by paula on 2018-11-13.
//  Copyright © 2018 paula. All rights reserved.
//

import UIKit
import CoreData

class ProductTableViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var productTable: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var products = [Product]()
    
    func setupProducts() {
        if let managedObject = managedObjectContext {
            let product = Product(context: managedObject)
            let producImage = UIImage(named: "pink_donut")!
            let imageData = producImage.pngData()
            product.setupProperties(image: imageData!, productName: "Produto Test", barCode: "1234245234", quantity: 10)
            
            let product2 = Product(context: managedObject)
            let producImage2 = UIImage(named: "red_donut")!
            let imageData2 = producImage2.pngData()
            product2.setupProperties(image: imageData2!, productName: "Raposinha", barCode: "78688567474", quantity: 20)
            
            saveContext()
        }
    }
    
    fileprivate func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        image.draw(in: CGRect(origin: .zero, size: CGSize(width: newWidth, height: newHeight)))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
//        productTable.dataSource = self
//        productTable.delegate = self
//
//        setupProducts()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        productTable.setEditing(editing, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadAllProducts()
        
        if let index = self.productTable.indexPathForSelectedRow {
            self.productTable.deselectRow(at: index, animated: animated)
        }
    }
    
    // MARK: Core Data
    fileprivate func loadAllProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            products = try managedObjectContext.fetch(fetchRequest)
            productTable.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    fileprivate func saveContext() {
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    fileprivate func delete(product: Product) {
        managedObjectContext.delete(product)
        saveContext()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addProduct" {
            if let destination = segue.destination as? AddProductViewController {
                destination.delegate = self
                destination.managedObjectContext = self.managedObjectContext
            }
        }
        else if segue.identifier == "editProduct" {
            if let destination = segue.destination as? AddProductViewController {
                destination.delegate = self
                destination.managedObjectContext = self.managedObjectContext
                
                if let indexPath = productTable.indexPathForSelectedRow {
                    destination.product = products[indexPath.row]
                }
            }
        }
    }
}

extension ProductTableViewController: UITableViewDataSource {
    // MARK: Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductTableViewCell
        
        let product = products[indexPath.row]
        
        cell.update(with: product)
        cell.showsReorderControl = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            delete(product: products[indexPath.row])
            products.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = products.remove(at: sourceIndexPath.row)
        products.insert(movedEmoji, at: destinationIndexPath.row)
        
        tableView.reloadData()
    }
}
extension ProductTableViewController: AddProductViewControllerDelegate {
    
    func addProduct(_ product: Product) {
        saveContext()
    }
}

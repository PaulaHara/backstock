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
    @IBOutlet var productTableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var emojis = [Product]()
    
    func setupEmojis() {
        let emoji = Product(context: managedObjectContext)
        let producImage = UIImage(named: "cesar.jpg")!
        let imageData = producImage.pngData()
        
        emoji.setupProperties(image: imageData!, productName: "Produto Test", barCode: "1234245234", quantity: 10)
        
        let emoji2 = Product(context: managedObjectContext)
        emoji2.setupProperties(image: imageData!, productName: "Raoisinha", barCode: "78688567474", quantity: 20)
        
        saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        productTableView.dataSource = self
        productTableView.delegate = self
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        productTableView.setEditing(editing, animated: animated)
    }
    
    // MARK: Core Data
    fileprivate func loadAllEmojis() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            emojis = try managedObjectContext.fetch(fetchRequest)
            productTableView.reloadData()
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
    
    fileprivate func delete(emoji: Product) {
        managedObjectContext.delete(emoji)
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
                
                if let indexPath = productTableView.indexPathForSelectedRow {
                    destination.emoji = emojis[indexPath.row]
                }
            }
        }
    }
}

extension ProductTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let emoji = emojis.remove(at: sourceIndexPath.row)
        emojis.insert(emoji, at: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        
        let emoji = emojis[indexPath.row]
        cell.update(with: emoji)
        cell.showsReorderControl = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}
extension ProductTableViewController: AddProductViewControllerDelegate {
    
    func addEmoji(_ emoji: Product) {
        saveContext()
    }
}

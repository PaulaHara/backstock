//
//  ProductTableViewController.swift
//  Backstock
//
//  Created by paula on 2018-11-13.
//  Copyright © 2018 paula. All rights reserved.
//

import UIKit
import CoreData

class ProductTableViewController: UIViewController {
    @IBOutlet var productTableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var emojis = [Product]()
    
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
}

extension ProductTableViewController: UITableViewDelegate {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
        
        let emoji = emojis[indexPath.row]
        cell.configCell(with: emoji)
        cell.showsReorderControl = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "emojiDetail" {
            if let emojiDescr = (sender as? UIButton)?.currentTitle {
                if let cvc = segue.destination as? EmojiDetailViewController {
                    cvc.emojiDetail = emojiDescr
                }
            }
        }
    }
}

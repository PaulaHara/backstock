//
//  AddProductViewController.swift
//  Backstock
//
//  Created by Paula on 11/14/18.
//  Copyright © 2018 paula. All rights reserved.
//

import UIKit
import CoreData

protocol AddProductViewControllerDelegate: class {
    
    func addEmoji(_ emoji: Product)
}

class AddProductViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet private weak var productSymbolTextField: UITextField!
    @IBOutlet private weak var productNameTextField: UITextField!
    @IBOutlet private weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    var managedObjectContext: NSManagedObjectContext!
    
    weak var delegate: AddProductViewControllerDelegate?
    weak var emoji: Product?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productSymbolTextField.delegate = self
        self.productNameTextField.delegate = self
        self.productDescriptionTextView.delegate = self
        
        self.productSymbolTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupFields()
        updateSaveButtonState()
    }
    
    // MARK: Private methods
    private func setupFields() {
        if emoji != nil {
            productSymbolTextField.text = emoji?.productName
            productNameTextField.text = emoji?.barCode
            productDescriptionTextView.text = "\(emoji?.quantity)"
        }
    }
    
    private func updateSaveButtonState() {
        let symbol = productSymbolTextField.text ?? ""
        let name = productNameTextField.text ?? ""
        let description = productDescriptionTextView.text ?? ""
        
        saveBarButtonItem.isEnabled = !symbol.isEmpty && !name.isEmpty && !description.isEmpty
    }
    
    @IBAction private func createNewEmoji(_ sender: UIBarButtonItem) {
        
        let image = Data()
        let symbol = productSymbolTextField.text
        let name = productNameTextField.text
        let description = productDescriptionTextView.text
        
        if !(symbol?.isEmpty)! && !(name?.isEmpty)! && !(description?.isEmpty)! {
            let emoji = Product(context: managedObjectContext)
            emoji.setupProperties(image: image, productName: name!, barCode: description!, quantity: 0)
            
            self.delegate?.addEmoji(emoji)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddProductViewController: UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            // Go to next textfield
            nextField.becomeFirstResponder()
        }
        else {
            // Last textfield
            textField.resignFirstResponder()
            productDescriptionTextView.becomeFirstResponder()
        }
        
        updateSaveButtonState()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    // MARK: UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            updateSaveButtonState()
            
            return false
        }
        return true
    }
    
}

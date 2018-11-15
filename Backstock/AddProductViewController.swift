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
    
    func addProduct(_ product: Product)
}

class AddProductViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet private weak var productNameTextField: UITextField!
    @IBOutlet weak var productBarCodeTextField: UITextField!
    @IBOutlet weak var productQuantityTextField: UITextField!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    var managedObjectContext: NSManagedObjectContext!
    
    weak var delegate: AddProductViewControllerDelegate?
    weak var product: Product?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productNameTextField.delegate = self
        self.productBarCodeTextField.delegate = self
        self.productQuantityTextField.delegate = self
    
        self.productNameTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupFields()
        updateSaveButtonState()
    }
    
    // MARK: Private methods
    private func setupFields() {
        if product != nil {
            productNameTextField.text = product?.productName
            productBarCodeTextField.text = product?.barCode
            productQuantityTextField.text = "\(String(describing: product?.quantity))"
        }
    }
    
    private func updateSaveButtonState() {
        let name = productNameTextField.text ?? ""
        let barcode = productBarCodeTextField.text ?? ""
        let quantity = productQuantityTextField.text ?? ""
        
        saveBarButtonItem.isEnabled = !name.isEmpty && !barcode.isEmpty && !quantity.isEmpty
    }
    
    @IBAction private func createNewProduct(_ sender: UIBarButtonItem) {
        let image = Data()
        let name = productNameTextField.text
        let barcode = productBarCodeTextField.text
        let quantity = productQuantityTextField.text
        
        if !(name?.isEmpty)! && !(barcode?.isEmpty)! && !(quantity?.isEmpty)! {
            let product = Product(context: managedObjectContext)
            product.setupProperties(image: image, productName: name!, barCode: barcode!, quantity: Int16(quantity!)!)
            
            self.delegate?.addProduct(product)
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
            productQuantityTextField.becomeFirstResponder()
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

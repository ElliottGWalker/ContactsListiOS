//
//  AddNewContactViewController.swift
//  ContactsList
//
//  Created by Elliott Walker on 08/04/2021.
//

import UIKit
import CoreData

class AddNewContactViewController: AppolyViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var saveButton: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    
    @objc func textField_EditingChanged(_ sender: UITextField){
        viewModel.setFirstName(string: firstNameTextField.text ?? "")
        viewModel.setLastName(string: lastNameTextField.text ?? "")
        viewModel.setEmail(string: emailTextField.text ?? "")
        viewModel.setContactNumber(string: phoneTextField.text ?? "")
        viewModel.setAddress(string: addressTextField.text ?? "")
    }
    
    
    // MARK:- UIActions
    @IBAction func saveButton_TouchUpInside(_ sender: Any) {
        saveContact()
    }
    
    // MARK: - Variables
    var viewModel: AddContactViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AddContactViewModel()
        
        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 6
        setupFields()
    }
    
    private func setupFields(){
        firstNameTextField.text = viewModel.firstName
        lastNameTextField.text = viewModel.lastName
        emailTextField.text = viewModel.email
        phoneTextField.text = viewModel.contactNumber
        addressTextField.text = viewModel.address
        
        firstNameTextField.addTarget(self, action: #selector(textField_EditingChanged(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textField_EditingChanged(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textField_EditingChanged(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textField_EditingChanged(_:)), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(textField_EditingChanged(_:)), for: .editingChanged)
    }
    
    private func saveContact() {
        guard validateForm(showErrors: true) else { return }
        navigateBackToContactList()
    }

    private func validateForm(showErrors: Bool = false) -> Bool {
        
        guard let error = viewModel.validateAddContact() else {
            saveContact(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, number: phoneTextField.text!, email: emailTextField.text!, address: addressTextField.text!)
            return true
        }
        
        if(showErrors) {
            showError(message: error.localizedDescription, completion: nil)
        }
        return false
    }
    
    private func saveContact(firstName: String, lastName: String, number: String, email: String, address: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
        let contact = NSManagedObject(entity: entity, insertInto: managedContext)
        
        contact.setValue(firstName, forKeyPath: "firstName")
        contact.setValue(lastName, forKeyPath: "lastName")
        contact.setValue(number, forKeyPath: "phone")
        contact.setValue(email, forKeyPath: "email")
        contact.setValue(address, forKeyPath: "address")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("ERROR: ADD - \(error)")
        }
    }
    
    
    private func navigateBackToContactList() {
        navigationController?.popViewController(animated: true)
    }

}

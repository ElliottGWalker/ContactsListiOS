//
//  ContactDetailsViewController.swift
//  ContactsList
//
//  Created by Elliott Walker on 08/04/2021.
//

import UIKit

class ContactDetailsViewController: AppolyViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    // MARK:- Variables
    var contact: Contact? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContactLabels()
    }
    
    private func setContactLabels() {
        self.title = "\(contact?.firstName ?? "") \(contact?.lastName ?? "")"
        firstNameLabel.text = contact?.firstName ?? ""
        lastNameLabel.text = contact?.lastName ?? ""
        emailLabel.text = contact?.email ?? ""
        phoneLabel.text = contact?.phone ?? ""
        addressLabel.text = contact?.address ?? ""
    }
    
}

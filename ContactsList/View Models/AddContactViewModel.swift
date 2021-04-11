//
//  AddContactViewModel.swift
//  ContactsList
//
//  Created by Elliott Walker on 09/04/2021.
//

import Foundation
import UIKit

enum AddContactError: Error {
    case missingFirstName
    case missingLastName
    case invalidEmail
    case missingContactNumber
    case missingAddress
}

extension AddContactError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .missingFirstName:
                return "Please enter first name"
            case .missingLastName:
                return "Please enter last name"
            case .invalidEmail:
                return "Please enter a valid email"
            case .missingContactNumber:
                return "Please enter phone number"
            case .missingAddress:
                return "Please enter address"
        }
    }
}

class AddContactViewModel {
    
    // MARK: - Variables
    
    private(set) var firstName: String?
    private(set) var lastName: String?
    private(set) var email: String?
    private(set) var contactNumber: String?
    private(set) var address: String?
    
    
    // MARK: - Setters
    
    @objc public func setFirstName(_ sender: UITextField) {
        firstName = sender.text
    }
    
    
    @objc public func setLastName(_ sender: UITextField) {
        lastName = sender.text
    }
    
    @objc public func setEmail(_ sender: UITextField) {
        email = sender.text
    }
    
    @objc public func setContactNumber(_ sender: UITextField) {
        contactNumber = sender.text
    }
    
    @objc public func setAddress(_ sender: UITextField) {
        address = sender.text
    }
    
    public func setFirstName(string: String) {
        firstName = string
    }
    
    
    public func setLastName(string: String) {
        lastName = string
    }
    
    public func setEmail(string: String) {
        email = string
    }
    
    public func setContactNumber(string: String) {
        contactNumber = string
    }
    
    public func setAddress(string: String?) {
        address = string
    }
    
    
    // MARK:- Validate
    
    public func validateAddContact() -> AddContactError? {
        
        guard firstName != nil, firstName!.count > 0 else {
            return .missingFirstName
        }
        
        guard lastName != nil, lastName!.count > 0 else {
            return .missingLastName
        }
        
        guard email != nil, email!.count > 0, email!.isValidEmail else {
            return .invalidEmail
        }
        
        guard contactNumber != nil, contactNumber!.count > 0 else {
            return .missingContactNumber
        }
        
        guard address != nil, address!.count > 0 else {
            return .missingAddress
        }
        
        return nil
    }
}

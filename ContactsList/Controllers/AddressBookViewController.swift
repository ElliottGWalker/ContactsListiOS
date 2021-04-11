//
//  ViewController.swift
//  ContactsList
//
//  Created by Elliott Walker on 07/04/2021.
//

import UIKit
import CoreData

class AddressBookViewController: AppolyViewController {
    
    // MARK:- Variables
    var contacts: [Contact] = [] {
        didSet {
            contacts.sort{
                getFullName(contact: $0) < getFullName(contact: $1)
            }
            filteredContacts = contacts
        }
    }
    var filteredContacts: [Contact] = [] {
        didSet {
            contactsTableView.reloadData()
        }
    }

    // MARK:- IBOutlets
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var noContactsView: UIStackView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK:- UIActions
    @IBAction func addButton_TouchUpInside(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: AddNewContactViewController.identifier) as? AddNewContactViewController else { self.showError(message: "", completion: nil); return }
        clearSearchBar()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getContactsFromCoreData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.isEnabled = false
        navBar.leftBarButtonItem = nil
        
        setupTableView()
        setupSearchBar()
    }
    
    private func getFullName(contact: Contact) -> String {
        return "\(contact.firstName ?? "") \(contact.lastName ?? "")"
    }
    
    private func setupTableView() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        contactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        contactsTableView.tableFooterView = UIView()
        
        getContactsFromCoreData()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func clearSearchBar() {
        searchBar.text = ""
    }
    
    private func getContactsFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Contact>(entityName: "Contact")
        
        do {
            contacts = try managedContext.fetch(fetchRequest)
            if(contacts.count > 0) {
                contactsTableView.isHidden = false
                noContactsView.isHidden = true
            } else {
                contactsTableView.isHidden = true
                noContactsView.isHidden = false
            }
            contactsTableView.reloadData()
        } catch let error as NSError {
            print("ERROR: GET - \(error)")
        }
    }
}

extension AddressBookViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = filteredContacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        cell.textLabel?.text = "\(contact.value(forKey: "firstName") ?? "") \(contact.value(forKey: "lastName") ?? "")"
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: ContactDetailsViewController.identifier) as? ContactDetailsViewController else { self.showError(message: "", completion: nil); return }
        vc.contact = filteredContacts[indexPath.row]
        clearSearchBar()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddressBookViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredContacts = contacts
        } else {
            filteredContacts = contacts.filter{ getFullName(contact: $0).lowercased().contains(searchText.lowercased())
            }
        }
    }
}

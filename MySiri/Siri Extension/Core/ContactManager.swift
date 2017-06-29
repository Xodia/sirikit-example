//
//  ContactManager.swift
//  Siri Extension
//
//  Created by Morgan Collino on 6/21/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import Intents

// Contact manager.
class ContactManager {
    
    // MARK: - Public properties
    
    // Shared properties
    static public var sharedContactManager = ContactManager()
    
    // MARK: - Public functions
    
    public func getContacts() -> [Contact] {
        return fetchContacts()
    }
    
    public func getContactsBy(name: String) -> [INPerson] {
        return toINPersons(contacts: fetchContactsBy(name: name))
    }
    
    // MARK: - Private functions
    
    init() {
        
    }
    
    private func fetchContacts() -> [Contact] {
        
        let john = Contact(firstName: "John", lastName: "Doe", phoneNumber: "9292023425")
        let bobby = Contact(firstName: "Bobby", lastName: "Swag", phoneNumber: "9292023415")
        let phil = Contact(firstName: "Phil", lastName: "Mate", phoneNumber: "9292023435")
        let trevor = Contact(firstName: "Trevor", lastName: "Robinson", phoneNumber: "9292023405")
        
        return [john, bobby, phil, trevor]
    }
    
    private func fetchContactsBy(name: String) -> [Contact] {
        return fetchContacts().filter({ (contact) -> Bool in
            return name.contains(contact.firstName) || name.contains(contact.lastName)
        })
    }
    
    private func toINPersons(contacts: [Contact]) -> [INPerson] {
        return contacts.map { (contact) -> INPerson in
            contact.toINPerson()
        }
    }
    
}

struct Contact {
    
    let firstName: String
    let lastName: String
    let phoneNumber: String
    
    func toINPerson() -> INPerson {
        return INPerson(personHandle: INPersonHandle(value: phoneNumber, type: .phoneNumber, label: nil), nameComponents: nil, displayName: firstName + " " + lastName, image: nil, contactIdentifier: nil, customIdentifier: nil)
    }
    
}

extension INPerson {
    
    func toContact() -> Contact {
        let names = displayName.characters.split{$0 == " "}.map(String.init)
        
        return Contact(firstName: names.first!,
                       lastName: names.last!,
                       phoneNumber: personHandle!.value!)
    }
}

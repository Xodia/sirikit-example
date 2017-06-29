//
//  MessageManager.swift
//  Siri Extension
//
//  Created by Morgan Collino on 6/21/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import Intents

// Message manager.
class MessageManager {
    
    // MARK: - Public properties
    
    // Shared properties
    static public var sharedMessageManager = MessageManager()
    
    // MARK: - Public functions
    public func sendMessage(message: String, to: Contact) -> Bool {
        return true
    }
    
    public func allMessages() -> [INMessage] {
        return toINMessages(messages: fetchMessages())
    }
    
    // MARK: - Private functions
    
    init() {
        
    }
    
    private func fetchMessages() -> [Message] {
        let contacts = ContactManager.sharedContactManager.getContacts()
        let firstContact = contacts.first!
        
        let message1 = Message(identifier: "identifier", text: "I love siri!", from: firstContact, datetime: Date(), recipients: contacts)
        let message2 = Message(identifier: "identifier", text: "Where is Brian?", from: firstContact, datetime: Date(), recipients: contacts)
        
        return [message1, message2]
    }
    
    private func toINMessages(messages: [Message]) -> [INMessage] {
        return messages.map { (message) -> INMessage in
            message.toINMessage()
        }
    }
    
}

struct Message {
    
    let identifier: String
    let text: String
    let from: Contact
    let datetime: Date
    let recipients: [Contact]
    
    func toINMessage() -> INMessage {
        return INMessage(
            identifier: self.identifier,
            content: self.text,
            dateSent: self.datetime,
            sender: self.from.toINPerson(),
            recipients: self.recipients.map({ (contact) -> INPerson in
                return contact.toINPerson()
            })
        )
    }
    
}

extension INMessage {
    
    func toMessage() -> Message {
        return Message(identifier: self.identifier, text: self.content!, from: self.sender!.toContact(), datetime: self.dateSent!, recipients: self.recipients!.map({ (person) -> Contact in
            person.toContact()
        }))
    }
    
}

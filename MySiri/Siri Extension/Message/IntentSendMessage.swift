//
//  IntentSendMessage.swift
//  Siri Extension
//
//  Created by Morgan Collino on 6/21/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Intents
import LocalAuthentication

extension MessageIntent: INSendMessageIntentHandling {
    
    // MARK: - INSendMessageIntentHandling
    
    // Handle the completed intent (required).
    
    func handle(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Implement your application logic to send a message here.
        guard let firstRecipient = intent.recipients?.first else {
            return
        }
        
        let reason = "Allow Siri to send the message"
        LAContext().evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (accessGranted, error) in
            var responseSuccess: INSendMessageIntentResponseCode = .failure
            if accessGranted {
                let result = MessageManager.sharedMessageManager.sendMessage(message: intent.content!, to: firstRecipient.toContact())
                responseSuccess = result ? .success : .failure
            }
            
            let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
            let response = INSendMessageIntentResponse(code: responseSuccess, userActivity: userActivity)
            completion(response)
        }
    }
    
    // Once resolution is completed, perform validation on the intent and provide confirmation (optional).
    
    func confirm(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Verify user is authenticated and your app is ready to send a message.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    // Implement resolution methods to provide additional information about your intent (optional).
    func resolveRecipients(forSendMessage intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        if let recipients = intent.recipients {
            
            // If no recipients were provided we'll need to prompt for a value.
            if recipients.count == 0 {
                completion([INPersonResolutionResult.needsValue()])
                return
            }
            
            var resolutionResults = [INPersonResolutionResult]()
            for recipient in recipients {
                // Look for potential matching contacts here.
                let matchingContacts = ContactManager.sharedContactManager.getContactsBy(name: recipient.displayName)
                
                if matchingContacts.count == 0 {
                    // We have no contacts matching the description provided
                    resolutionResults += [INPersonResolutionResult.unsupported()]
                } else if matchingContacts.count == 1 {
                    // We have exactly one matching contact
                    resolutionResults += [INPersonResolutionResult.success(with: matchingContacts.first!)]
                } else if matchingContacts.count > 1 {
                    // We need Siri's help to ask user to pick one from the matches.
                    resolutionResults += [INPersonResolutionResult.disambiguation(with: matchingContacts)]
                }
            }
            completion(resolutionResults)
        }
    }
    
    // You could use this functon to give more context to the text you want to send via Siri/Your app.
    func resolveContent(forSendMessage intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
}

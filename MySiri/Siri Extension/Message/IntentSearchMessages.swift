//
//  IntentSearchMessages.swift
//  Siri Extension
//
//  Created by Morgan Collino on 6/21/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Intents

extension MessageIntent: INSearchForMessagesIntentHandling {
    
    // MARK: - INSearchForMessagesIntentHandling
    
    func handle(searchForMessages intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        // Implement your application logic to find a message that matches the information in the intent.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
        
        // Initialize with found message's attributes
        response.messages = MessageManager.sharedMessageManager.allMessages()
        completion(response)
    }
    
}

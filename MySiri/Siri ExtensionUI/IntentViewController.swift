//
//  IntentViewController.swift
//  Siri ExtensionUI
//
//  Created by Morgan Collino on 6/21/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var contentSize: CGSize {
        return CGSize(width: self.extensionContext!.hostedViewMinimumAllowedSize.width, height: self.extensionContext!.hostedViewMinimumAllowedSize.height + 60)
    }
    
    private var defaultSize: CGSize {
        return CGSize(width: self.extensionContext!.hostedViewMinimumAllowedSize.width, height: 40)
    }
    
    // MARK: - Private functions
    
    fileprivate func displayFor(parameter: INParameter, interaction: INInteraction) -> CGSize {
        switch parameter.parameterClass.description() {
        case "INSendMessageIntent":
            let sendMessageIntent = interaction.intent as! INSendMessageIntent
            
            if parameter.parameterKeyPath == "content",
                let content = sendMessageIntent.content {

                if interaction.intentHandlingStatus == .success {
                    displayMessageSentIntent(value: "")
                } else {
                    displaySendMessageIntent(value: content)
                }
                return contentSize
            } else if parameter.parameterKeyPath == "recipients" {
                let contact = sendMessageIntent.recipients?.first
                displayRecipientIntent(with: contact)
                return defaultSize
            }
        default:
            break
        }
        
        return CGSize.zero
    }
    
    private func displayRecipientIntent(with contact: INPerson?) {
        let recipientViewController = storyboard?.instantiateViewController(withIdentifier: "RecipientViewController") as! RecipientViewController
        let displayName = contact?.displayName ?? "somebody"
        recipientViewController.content = "Sending a message to \(displayName)"
        present(recipientViewController, animated: false, completion: nil)
    }
    
    private func displaySendMessageIntent(value: String?) {
        let messageViewController = storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        messageViewController.content = value
        present(messageViewController, animated: false, completion: nil)
    }
    
    private func displayMessageSentIntent(value: String) {
        let messageViewController = storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        messageViewController.content = "Message Sent"
        present(messageViewController, animated: false, completion: nil)
    }
    
}

extension IntentViewController: INUIHostedViewControlling {
    
    @available(iOS 10.0, *)
    func configure(with interaction: INInteraction, context: INUIHostedViewContext, completion: @escaping (CGSize) -> Void) {
        // Should not be called - By default is calling configureView
        fatalError()
    }
    
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        
        let intentParameter = parameters.filter({ (parameter) -> Bool in
            return parameter.parameterClass == INSendMessageIntent.classForCoder()
        }).first
        
        guard let contentType = intentParameter else {
            completion(false, parameters, CGSize.zero)
            return
        }
        
        let size = displayFor(parameter: contentType, interaction: interaction)
        completion(true, parameters, size)
    }
    
}

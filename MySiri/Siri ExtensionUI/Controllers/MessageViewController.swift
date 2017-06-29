//
//  MessageViewController.swift
//  Siri ExtensionUI
//
//  Created by Morgan Collino on 6/22/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    // MARK: - Public properties
    
    var content: String?
    
    // MARK: - Private properties
    
    @IBOutlet private weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentLabel.text = content
    }

}

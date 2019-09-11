//
//  IncomingMessageTableViewCell.swift
//  SendBird-ios
//
//  Created by Swift Legends on 11/09/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit

class IncomingMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var incomingMessageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 16

        // Initialization code
    }
    
    func setIncomingMessage(_ message: ChatMessage) {
        incomingMessageLabel.numberOfLines = 0
    incomingMessageLabel.text = message.message
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

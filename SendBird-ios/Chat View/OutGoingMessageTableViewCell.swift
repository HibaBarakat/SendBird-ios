//
//  OutGoingMessageTableViewCell.swift
//  SendBird-ios
//
//  Created by Swift Legends on 11/09/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit

class OutGoingMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var outgoingMessageLabel: UILabel!
    
    @IBOutlet weak var messageView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 16

        // Initialization code
    }
    func setOutgoingMessage(_ message: ChatMessage) {
        outgoingMessageLabel.numberOfLines = 0

        outgoingMessageLabel.text = message.message
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

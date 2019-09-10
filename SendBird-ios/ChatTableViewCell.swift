//
//  ChatTableViewCell.swift
//  SendBird-ios
//
//  Created by Swift Legends on 05/09/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var messageView: UIView!
    
    var isIncoming: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 16
    
    }
    
    func setUI() {
//        
//        let constraints = [messageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//        messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//        messageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250)]
//        
//        NSLayoutConstraint.activate(constraints)
        
        let leadingConstraints = messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        
        let trailingConstraints = messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
   
        
        if isIncoming != true {
            messageView.backgroundColor = .white
            messageLabel.textColor = .black

            leadingConstraints.isActive = false
            trailingConstraints.isActive = true
            
            
        }else if isIncoming{
            
            messageView.backgroundColor = .darkGray
            messageLabel.textColor = .white
            trailingConstraints.isActive = false
            leadingConstraints.isActive = true
            

            
        }
        
        
        
        
    }

    
    func setMessage(_ chatMessage: ChatMessage) {
        messageLabel.numberOfLines = 0
        isIncoming = chatMessage.isIncoming
        messageLabel.text = chatMessage.message
        setUI()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

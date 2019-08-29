//
//  ChatHistoryTableViewCell.swift
//  SendBird-ios
//
//  Created by Swift Legends on 25/08/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit
import SendBirdSDK
import Alamofire
import AlamofireImage

class ChatHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfilaImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setGroupChannel(groupChannel: SBDGroupChannel){
        if let url = URL(string: groupChannel.coverUrl!){
            self.userProfilaImage.af_setImage(withURL: url)
        }
        userNameLabel.text = groupChannel.name
        if groupChannel.lastMessage != nil , groupChannel.lastMessage is SBDUserMessage {
            let lastMessage = groupChannel.lastMessage as! SBDUserMessage
            lastMessageLabel.text = lastMessage.message

        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

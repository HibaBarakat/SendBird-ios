//
//  userListTableViewCell.swift
//  SendBird-ios
//
//  Created by Swift Legends on 31/07/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit
import SendBirdSDK
import AFNetworking
import Alamofire

class userListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var user: SBDUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

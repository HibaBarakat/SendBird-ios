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
import AlamofireImage

class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUserDetails(_ user: SBDUser){
        if let url = URL(string: user.profileUrl!){
    self.userImage.af_setImage(withURL: url)
    }
        userName.text = user.userId
    }

    

}

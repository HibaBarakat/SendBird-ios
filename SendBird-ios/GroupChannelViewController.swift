//
//  GroupChannelViewController.swift
//  SendBird-ios
//
//  Created by Swift Legends on 30/07/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit
import SendBirdSDK

class GroupChannelViewController: UIViewController {
    
    func createChannel () {
        var users: [String] = []
        users.append("Hiba")
        users.append("Jhon")
        users.append("Massa")
        users.append("Bashar")
        users.append("Majd")
        
        var ops: [String] = []
        ops.append("GGHH")
        
        var params = SBDGroupChannelParams()
        params.isDistinct = false
        params.isEphemeral = false
        params.isPublic = false
        params.addUserIds(users)
        params.operatorUserIds = ops
        params.name = "NAME"
        params.channelUrl = "UNIQUE_CHANNEL_URL"
        params.coverImage = nil            // or .coverUrl
        params.data = "DATA"
        params.customType = "CUSTOM_TYPE"
        
        SBDGroupChannel.createChannel(with: params) { (groupChannel, error) in
            if error != nil {   // Error.
                print("error in creation")
                return
            }else {
                print("channel created")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.createChannel()
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

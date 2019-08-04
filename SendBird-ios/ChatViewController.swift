//
//  MessageViewController.swift
//  SendBird-ios
//
//  Created by Swift Legends on 31/07/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatViewController: UIViewController, SBDChannelDelegate, SBDConnectionDelegate {
    
    
    weak var channel: SBDGroupChannel?
    weak var user: SBDUser?
    private var users: [SBDUser] = []
 


    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var msgToBeSentTextField: UITextField!
    @IBOutlet weak var sendMessageLabel: UILabel!
    @IBOutlet weak var recievedMessageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("selected user from chat view")
        if user != nil{
            print(user!)
        }
        SBDMain.add(self as SBDChannelDelegate, identifier: self.description)
        SBDMain.add(self as SBDConnectionDelegate, identifier: self.description)
        
        createOnetoOneChannel()

        
    
        // Do any additional setup after loading the view.
    }
    func createOnetoOneChannel(){
        
        if user != nil {
            users.append(user!)
            
        }
        
        SBDGroupChannel.createChannel(with: users, isDistinct: true) { (channel, error) in
            if error == nil {
                self.channel = channel
                print("channel created")

              
                
            }else {
                print("Error in creating the channel")
            }
        }

    }
    
    func sendMessageByUser(_ msg: String){
       
        DispatchQueue.main.async {

            if self.channel != nil {
            
                self.channel?.sendUserMessage(msg, completionHandler: { (smsg, error) in
                if error == nil {
                    
                    print(smsg)
                    
                }else {
                    print("Error in sending message")
                }
            })
        }
        }
    
    }
    
    
    @IBAction func clickOnSendButton(_ sender: Any)  {
        
        if self.msgToBeSentTextField.text?.count != 0 {
            print("texttt field >>>")
            print(self.msgToBeSentTextField.text)
            self.sendMessageByUser(self.msgToBeSentTextField.text!)
            self.sendMessageLabel.text = self.msgToBeSentTextField.text!

                }
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        DispatchQueue.main.async {

            if message is SBDUserMessage {
                
                let userMessage = message as! SBDUserMessage
                let sender = userMessage.sender
                var body = "\(userMessage.message)"
                self.recievedMessageLabel.text = body
                
                print("Received message")
                print(body)
            }
          
        }
    }

}

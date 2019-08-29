//
//  MessageViewController.swift
//  SendBird-ios
//
//  Created by Swift Legends on 31/07/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatViewController: UIViewController, SBDChannelDelegate {
    
    
    weak var channel: SBDGroupChannel?

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var msgToBeSentTextField: UITextField!
    @IBOutlet weak var sendMessageLabel: UILabel!
    @IBOutlet weak var recievedMessageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SBDMain.add(self as SBDChannelDelegate, identifier: self.description)


        }

    
    func sendMessageByUser(_ msg: String){
 
            if self.channel != nil {
                
                self.channel?.sendUserMessage(msg, completionHandler: { (smsg, error) in
                if error == nil {
                    
                    print("Message Format: ",String(describing: smsg))
                    
                }else {
                    print("Error in sending message")
                }
            })
        }
        
    
    }
    
    
    @IBAction func clickOnSendButton(_ sender: Any)  {
        
        if self.msgToBeSentTextField.text?.count != 0 {
            print("texttt field >>>",String(describing: self.msgToBeSentTextField.text!))

            self.sendMessageByUser(String(describing: self.msgToBeSentTextField.text!))

            self.sendMessageLabel.text = self.msgToBeSentTextField.text
            self.msgToBeSentTextField.text? = ""

                }
    }
    

    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
    
            if message is SBDUserMessage {
                
                let userMessage = message as! SBDUserMessage
                var body = "\(userMessage.message)"
                self.recievedMessageLabel.text = body
                
                print("Received message")
                print(body)
            }
          
        }
    

}

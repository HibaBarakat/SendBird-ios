//
//  MessageViewController.swift
//  SendBird-ios
//
//  Created by Swift Legends on 31/07/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit
import SendBirdSDK

struct ChatMessage {
    var message: String
    var sender: String
    var isIncoming: Bool
    
}

class ChatViewController: UIViewController {
    
    
    var channel: SBDGroupChannel?
    var chatMessagesList: [ChatMessage] = []
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var messageToBeSentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPreviousMessages()
        setUI()
        listenToKeyboardEvents()
        SBDMain.add(self as SBDChannelDelegate, identifier: self.description)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)


        
        }
    
    deinit {
        // stop listening
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    func listenToKeyboardEvents(){
        // Listener to keyboard events

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func setUI(){
        navigationItem.title = channel?.name
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.93, alpha: 1)
        tableView.keyboardDismissMode = .onDrag
        sendMessageView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        sendButton.isEnabled = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // dismiss keyboard
        view.endEditing(true)
        view.frame.origin.y = 0
        super.touchesBegan(touches, with: event)
    }
    
    
    
    
    func loadPreviousMessages() {
        
        guard let previousMessageQuery = self.channel!.createPreviousMessageListQuery()
            else {return}
        previousMessageQuery.loadPreviousMessages(withLimit: 30, reverse: true, completionHandler: { (messages, error) in
            guard error == nil else {   // Error.
                return
            }
            
            if messages != nil {
            self.formatIncomigMessages(messages!)
                
            }
            
            
        })
    }
    func formatIncomigMessages(_ messages: [SBDBaseMessage]){
        for message in messages{
            
            if message is SBDUserMessage {
                
                let userMessage = message as! SBDUserMessage
                let body = String(describing: userMessage.message!)
                let sender = userMessage.sender?.nickname
                if sender == SBDMain.getCurrentUser()?.nickname {
                    let msg = ChatMessage(message: body, sender: sender!, isIncoming: false)
                    chatMessagesList.insert(msg, at: 0)

                }else {
                    let msg = ChatMessage(message: body, sender: sender!, isIncoming: true)
                    chatMessagesList.insert(msg, at: 0)
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
           //self.scrollToBottomOfChat()
            
        }
    }

    
    func sendMessageByUser(_ msg: String){
        
            if self.channel != nil {
              
                self.channel?.sendUserMessage(msg, completionHandler: { (smsg, error) in
                if error == nil {
                    guard let sender = SBDMain.getCurrentUser()?.nickname else {return}
                    let msg = ChatMessage(message: msg, sender: sender, isIncoming: false)
                    
                    self.chatMessagesList.insert(msg, at: 0)
                    //self.chatMessagesList.append(msg)
                    DispatchQueue.main.async {
                        self.messageToBeSentTextField.text = ""
                        self.tableView.reloadData()
                       // self.scrollToBottomOfChat()
                        
                    }
                    
                }else {
                    print("Error in sending message")
                }
            })
        }
        
    
    }
    
    
    @IBAction func clickOnSendButton(_ sender: Any)  {
        if messageToBeSentTextField.text?.count != 0 && messageToBeSentTextField.text != nil {
            sendButton.isEnabled = true
            self.sendMessageByUser(messageToBeSentTextField.text!)

        }else{
            sendButton.isEnabled = false
        }
        

    }

    

    

} // End of class



extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatMessagesList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "chatTableViewCell", for: indexPath) as? ChatTableViewCell {
       
            cell.setMessage(chatMessagesList[indexPath.row])
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

            return cell
        }
        return UITableViewCell()

        
    }
    
    func scrollToBottomOfChat(){
        if chatMessagesList.count > 1 {
        let indexPath = IndexPath(row: chatMessagesList.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        
        }
    }
    
    
}


extension ChatViewController: SBDChannelDelegate {
    
    //MARK: Recieve Messages From User
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        
        if message is SBDUserMessage {
            
            
            let userMessage = message as! SBDUserMessage
            let body = "\(String(describing: userMessage.message!))"
            let sender = (userMessage.sender?.nickname)!
            let msg = ChatMessage(message: body, sender: sender, isIncoming: true)
            self.chatMessagesList.insert(msg, at: 0)

            //self.chatMessagesList.append(msg)
            DispatchQueue.main.async {
                self.tableView.reloadData()
               //self.scrollToBottomOfChat()
                
            }

        }
        
    }
    
}

extension ChatViewController: UITextFieldDelegate {
    func hideKeyboard(){
        messageToBeSentTextField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        hideKeyboard()
        return true
        
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        sendButton.isEnabled = true
        return true

    }
    
    @objc func keyboardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
            view.frame.origin.y = -keyboardRect.height
            
        }
        else if notification.name == UIResponder.keyboardWillHideNotification {
            view.frame.origin.y = 0
            
        }
    }
    
 
}

//
//  RegistrationViewController.swift
//  SendBird-ios
//
//  Created by Swift Legends on 21/08/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit
import SendBirdSDK

class RegistrationViewController: UIViewController {
    


    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    private weak var user: SBDUser?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func clickOnSignUpButton(_ sender: Any) {
    
    
            let alert = UIAlertController(title: "User Connection", message: " If there is no matching user ID found, the server creates an account with the user ID provided", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.connect()
            }))
        
            self.present(alert, animated: true)
      
   
            
    
    }
    
    
    
    private func connect() {
        self.view.endEditing(true) // to hide the keyboard
        if SBDMain.getConnectState() != .open {
            

            let userId = self.userIdTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let nickname = self.nicknameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if userId?.count == 0 || nickname?.count == 0 {
                print("error no user id or nickname")
                
                return
            }
            self.setUIsWhileConnecting()
           

            SBDMain.connect(withUserId: userId!) { (user, error) in
                if error != nil {
                    print("error in connection")
                  
                    return
                }else{
                  
                    SBDMain.updateCurrentUserInfo(withNickname: nickname, profileUrl:nil , completionHandler: { (error) in
                        if error != nil {
                            print("error in updating user")
                        }else {
                            print(user as Any)
                            self.user = user
                            DispatchQueue.main.async {
                                self.setUIsForDefault()
                            }
                             self.performSegue(withIdentifier: "chatList", sender: nil)
                        }
                    })

                    

                   
                }
                
            }
            
            
            print("connection done!")
        }
      
    }
    
    
    private func setUIsWhileConnecting() {
        self.userIdTextField.isEnabled = false
        self.connectButton.isEnabled = false
        self.connectButton.setTitle("Connecting ...", for: .normal)
    }
    private func setUIsForDefault() {
        self.userIdTextField.isEnabled = true
        self.connectButton.isEnabled = true
        self.connectButton.setTitle("Sign Up", for: .normal)
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

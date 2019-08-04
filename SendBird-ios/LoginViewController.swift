//
//  LoginViewController.swift
//  SendBird-ios
//
//  Created by Swift Legends on 28/07/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit
import SendBirdSDK


class LoginViewController: UIViewController {

    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.connectButton.addTarget(self, action: #selector(clickConnectButton(_:)) , for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    func connect() {
        self.view.endEditing(true) // to hide the keyboard
        if SBDMain.getConnectState() != .open {
            let userId = self.userIdTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let nickname = self.nicknameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if userId?.count == 0 || nickname?.count == 0 {
                print("error no user id or nickname")
                
                return
            }
            let userDefault = UserDefaults.standard
            userDefault.setValue(userId, forKey: "sendbird_user_id")
            userDefault.setValue(nickname, forKey: "sendbird_user_nickname")
            
            self.setUIsWhileConnecting()
           

            SBDMain.connect(withUserId: userId!) { (user, error) in
                if error != nil {
                    print("error in connect")
                     let alert = UIAlertController(title: "Error connection Alert", message: "This is an alert to report an error in connecting to server.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    DispatchQueue.main.async {
                        self.setUIsForDefault()
                    }
                    return
                }else{
                    print(user!)
                    SBDMain.updateCurrentUserInfo(withNickname: nickname, profileUrl: nil) { (error) in
                        if error != nil {
                            print("error in update user info")
                            return
                        }else {
                                DispatchQueue.main.async {
                                    self.setUIsForDefault()
                                    print("Going to tab bar")

                                    self.performSegue(withIdentifier: "MainTabBarController", sender: nil)
                            
                            }
                            
                        }
                }
            }
            
          
           
            }

            
            print("done!")
            
        } else {
            SBDMain.disconnect {
                DispatchQueue.main.async {
                    self.setUIsForDefault()
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
  
        return true
    }
  
    @IBAction func clickConnectButton(_ sender: Any) {
       self.connect()
    
    }
    
    private func setUIsWhileConnecting() {
        self.userIdTextField.isEnabled = false
        self.nicknameTextField.isEnabled = false
        self.connectButton.isEnabled = false
        self.connectButton.setTitle("Connecting ...", for: .normal)
    }
    private func setUIsForDefault() {
        self.userIdTextField.isEnabled = true
        self.nicknameTextField.isEnabled = true
        self.connectButton.isEnabled = true
        self.connectButton.setTitle("Connect", for: .normal)
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

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
    @IBOutlet weak var connectButton: UIButton!
    
    private weak var user: SBDUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
    }
    
    func connect() {
        self.view.endEditing(true) // to hide the keyboard
        if SBDMain.getConnectState() != .open {
            let userId = self.userIdTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
         
            if userId?.count == 0  {
                print("error no user id or nickname")
                
                return
            }

            self.setUIsWhileConnecting()

            SBDMain.connect(withUserId: userId!) { (user, error) in
                if error != nil {
                    print("error in connect")
                    self.setUIsForDefault()
                  
                    return
                }else{
                    //Main Queue -Using to update the UI after completing work in a task on a concurrent queue.
                    DispatchQueue.main.async {
                        self.setUIsForDefault()
                    }
                    self.user = user
                    
                    self.performSegue(withIdentifier: "SignIn", sender: nil)
                    
            }
          
            }

            
            print("done!")
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
  
        return true
    }
  
    @IBAction func clickConnectButton(_ sender: Any) {
        connect()
        
    }
    
    @IBAction func clickSignUpButton(_ sender: Any) {
          self.performSegue(withIdentifier: "SignUp", sender: nil)
        
    }
    private func setUIsWhileConnecting() {
        self.userIdTextField.isEnabled = false
        self.connectButton.isEnabled = false
        self.connectButton.setTitle("Connecting ...", for: .normal)
    }
    private func setUIsForDefault() {
        self.userIdTextField.isEnabled = true
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

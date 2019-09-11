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
    


    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var idError: UILabel!
    @IBOutlet weak var nicknameErorr: UILabel!
    private var userId: String?
    private var nickname: String?
    private let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tryToAutoConnect()

        idError.isHidden = true
        nicknameErorr.isHidden = true
        listenToKeyboardEvents()
        


    }
    
    func listenToKeyboardEvents() {
        // Listener to keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    deinit {
        // stop listening
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    

    
    @IBAction func clickOnSignUpButton(_ sender: Any) {

        if checkValidation() {
            self.connect()
        }

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // dismiss keyboard
        view.endEditing(true)
        view.frame.origin.y = 0
        super.touchesBegan(touches, with: event)
    }
    private func checkValidation() -> Bool{
         userId = self.userIdTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
         nickname = self.nicknameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if userId == nil {
            
            let alert = UIAlertController(title: "User Connection", message: " User ID not Found", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)

            
            return false
        }else if userId?.count == 0 && nickname?.count == 0 {
            idError.isHidden = false
            nicknameErorr.isHidden = false

            return false
        }else if userId?.count == 0 {
            idError.isHidden = false
            return false
            
        }else if nickname?.count == 0 {
            
            nicknameErorr.isHidden = false
            return false
        }else {
            
            userDefault.setValue(userId, forKey: "userId")
            userDefault.setValue(nickname, forKey: "nickname")
            
            return true
        }
        
    }
    
    func tryToAutoConnect() {
        
        if let userId = userDefault.value(forKey: "userId"), let nickname = userDefault.value(forKey: "nickname") {
            
            self.userId = userId as? String
            self.nickname = nickname as? String
            
                connect()
        
        }
        
    }
    func cancelAutoConnect() {
        userDefault.removeObject(forKey: "userId")
        userDefault.removeObject(forKey: "nickname")

    }
    

    private func connect() {
        self.view.endEditing(true) // to hide the keyboard


            self.setUIsWhileConnecting()
           

            SBDMain.connect(withUserId: userId!) { (user, error) in
                if error != nil {
                    print("error in connection")
                  
                    return
                }else{
                  
                    SBDMain.updateCurrentUserInfo(withNickname: self.nickname, profileUrl:nil , completionHandler: { (error) in
                        if error != nil {
                            print("error in updating user")
                        }else {
                            DispatchQueue.main.async {
                                self.setUIsForDefault()
                            }
                            self.performSegue(withIdentifier: "connect", sender: self.userDefault)
                        }
                    })

                }
                
            }

            print("connection done!")
        
      
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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
    


}
extension RegistrationViewController: UITextFieldDelegate {
    func hideKeyboard(){
        userIdTextField.resignFirstResponder()
        nicknameTextField.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if userIdTextField.text?.count != 0 && nicknameTextField.text?.count == 0{
        idError.isHidden = true
        }else if nicknameTextField.text?.count != 0 && userIdTextField.text?.count == 0{
            nicknameErorr.isHidden = true
        } else {
            idError.isHidden = true
            nicknameErorr.isHidden = true
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        hideKeyboard()
        return true
        
    }
    
    @objc func keyboardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
            view.frame.origin.y = -keyboardRect.height+(heightConstraints.constant*0.75)

        }
        else if notification.name == UIResponder.keyboardWillHideNotification {
            view.frame.origin.y = 0

        }
    }
    

}


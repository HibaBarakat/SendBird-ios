//
//  SelectorOperatorsViewController.swift
//  SendBird-ios
//
//  Created by Swift Legends on 30/07/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit
import AFNetworking
import SendBirdSDK
import Alamofire



class SelectorOperatorsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   



    @IBOutlet var okButton: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var userListQuery: SBDUserListQuery?
    private var users: [SBDUser] = []
    private var refreshControl: UIRefreshControl?
    var selectedUsers: [String:SBDUser] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.userListQuery = nil
        self.loadUserList(true)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(SelectorOperatorsViewController.refreshUserList), for: .valueChanged)
        
        self.tableView.refreshControl = self.refreshControl
        // self.refreshUserList()
        
    

    }
    
    @objc func refreshUserList() {
        self.loadUserList(true)
    }
    
    func loadUserList(_ refresh: Bool) {
        if refresh {
            self.userListQuery = nil
        }
        
        if self.userListQuery == nil {
            self.userListQuery = SBDMain.createApplicationUserListQuery()
            self.userListQuery?.limit = 20
        }
        
        if self.userListQuery?.hasNext == false {
            return
        }
        self.userListQuery!.loadNextPage { (users, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                }
                
                return
            }
            
            DispatchQueue.main.async {
                if refresh {
                    self.users.removeAll()
                }
                
                for user in users! {
                    if user.userId == SBDMain.getCurrentUser()!.userId {
                        continue
                    }
                    self.users.append(user)
                }
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
        
    }
    
    @IBAction func pressOkButton(_ sender: Any) {
       
        print("ok button")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell", for: indexPath) as? userListTableViewCell
       
        cell?.user = self.users[indexPath.row]
        
        DispatchQueue.main.async {
            if let updateCell = tableView.cellForRow(at: indexPath) as? userListTableViewCell {
                updateCell.userName.text = self.users[indexPath.row].nickname
           
        }
        }
        
    
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: ChatViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chatViewController") as? ChatViewController)!
        print("selected user")
        print(users[indexPath.row])
        vc.user = users[indexPath.row]
        self.present(vc, animated: true, completion: nil)
   
      

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


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



class UserListViewController: UIViewController{
    

    @IBOutlet weak var tableView: UITableView!
    
    private var userListQuery: SBDUserListQuery?
    private var refreshControl: UIRefreshControl?
    var channel: SBDGroupChannel?
    private var users: [SBDUser] = []
    var channelUsers: [SBDUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadUserList()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(UserListViewController.refreshUserList), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl

    }
    
    
  @objc func refreshUserList() {
        self.loadUserList()
    }
    
    func loadUserList() {
        
        self.userListQuery = nil

        if self.userListQuery == nil {
            self.userListQuery = SBDMain.createApplicationUserListQuery()
            self.userListQuery?.limit = 20
        }
        
        if self.userListQuery?.hasNext == false {
            return
        }
        self.userListQuery!.loadNextPage { (users, error) in
            if error != nil {
                self.refreshControl?.endRefreshing()
                return
            }

                    self.users.removeAll()
            
                
                for user in users! {
                    if user.userId == SBDMain.getCurrentUser()!.userId {
                        continue
                    }
                    self.users.append(user)
                }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            channelUsers.insert(users[indexPath.row], at: 0)
            channelUsers.insert(SBDMain.getCurrentUser()!, at: 1)
           
        }

    }
   

}
extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell", for: indexPath) as? UserListTableViewCell{
            
            cell.setUserDetails(self.users[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
}


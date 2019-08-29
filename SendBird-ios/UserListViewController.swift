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



class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet var okButton: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var userListQuery: SBDUserListQuery?
    private var users: [SBDUser] = []
    private var refreshControl: UIRefreshControl?
    private var userIndex = 0
    private var channelUsers: [SBDUser] = []
    private var channel: SBDGroupChannel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.userListQuery = nil
        self.loadUserList(true)

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(UserListViewController.refreshUserList), for: .valueChanged)
        
        self.tableView.refreshControl = self.refreshControl

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
                self.refreshControl?.endRefreshing()
                return
            }

                if refresh {
                    self.users.removeAll()
                }
                
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
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell", for: indexPath) as? userListTableViewCell
       
        cell?.user = self.users[indexPath.row]
        cell?.userName.text = self.users[indexPath.row].nickname
        
        return cell!
  
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        userIndex = indexPath.row
        self.channelUsers.append(users[userIndex])
        self.channelUsers.append(SBDMain.getCurrentUser()!)
        self.createOneToOneChannel()
    }
    
    func createOneToOneChannel(){
        let channelName = users[userIndex].userId+" & "+SBDMain.getCurrentUser()!.userId


        SBDGroupChannel.createChannel(withName: channelName, isDistinct: true, users: channelUsers, coverUrl: nil, data: nil) { (groupChannel, error) in
            guard error == nil else {   // Error.
                print("Error in creating channel")
                return
            }

            self.channel = groupChannel
            self.performSegue(withIdentifier: "chatViewController", sender: nil)
            self.channelUsers.removeAll()
        }

        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "chatViewController", let vc = segue.destination as? ChatViewController{
            vc.channel = self.channel
        }
    }
   

}


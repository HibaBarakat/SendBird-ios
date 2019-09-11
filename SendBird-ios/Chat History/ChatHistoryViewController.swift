//
//  ChatHistoryViewController.swift
//  SendBird-ios
//
//  Created by Swift Legends on 25/08/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatHistoryViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!

    
    private var groupChannelsList = [SBDGroupChannel]()
    private var searchGroupChannelList = [SBDGroupChannel]()
    private var channelListQuery: SBDGroupChannelListQuery?
    private var searching = false
    private var refreshControl: UIRefreshControl?



    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveListOfChannels()
        setUpNavBar()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(ChatHistoryViewController.refreshGroupList), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshGroupList()
    }
    



    @IBAction func clickLogOutButton(_ sender: Any) {
        SBDMain.disconnect(completionHandler: {
            let userDefault = UserDefaults.standard
            userDefault.removeObject(forKey: "userId")
            userDefault.removeObject(forKey: "nickname")
            userDefault.synchronize()
            self.performSegue(withIdentifier: "logout" , sender: nil)

        })
    
    }
    @IBAction func clickNewChatButton(_ sender: Any) {
        self.performSegue(withIdentifier: "users", sender: nil)
    }
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {

    }
    @IBAction func userSelection(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is UserListViewController , let senderVC = unwindSegue.source as? UserListViewController {
             let users = senderVC.channelUsers

                self.createOneToOneChannel(users)
            
            
        }

    }
    func createOneToOneChannel( _ channelUsers: [SBDUser]){
        let channelName = channelUsers[0].userId+" & "+SBDMain.getCurrentUser()!.userId
        
        SBDGroupChannel.createChannel(withName: channelName, isDistinct: true, users: channelUsers, coverUrl: nil, data: nil) { (groupChannel, error) in
            guard error == nil else {   // Error.
                print("Error in creating channel")
                return
            }
            self.performSegue(withIdentifier: "chatView", sender: groupChannel)

            
        }
        
        
    }
    
    @objc func refreshGroupList(){
        retrieveListOfChannels()
    }
    
    func retrieveListOfChannels(){

        channelListQuery = SBDGroupChannel.createMyGroupChannelListQuery()
        channelListQuery?.includeEmptyChannel = false
   
        
        if channelListQuery?.hasNext == nil {
            return
        }
        channelListQuery?.loadNextPage(completionHandler: { (groupChannels, error) in
            guard error == nil else {   // Error.
                self.refreshControl?.endRefreshing()
                print("error in loading channels")
                return
            }
            
            self.groupChannelsList.removeAll()
          
            for group in groupChannels! {
                self.groupChannelsList.append(group)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        })

    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatView", let vc = segue.destination as? ChatViewController{
            vc.channel = sender as? SBDGroupChannel
        }

    }
    

}


extension ChatHistoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
   
        channelListQuery = SBDGroupChannel.createMyGroupChannelListQuery()
        channelListQuery?.includeEmptyChannel = true
        channelListQuery?.channelNameContainsFilter = searchText
        channelListQuery?.loadNextPage(completionHandler: { (groupChannels, error) in
            guard error == nil else {   // Error.
                print("error search")
                return
            }
            self.searchGroupChannelList.removeAll()

            for group in groupChannels! {
                self.searchGroupChannelList.append(group)
            }
                self.searching = true
                self.tableView.reloadData()
        })

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchGroupChannelList.removeAll()
        tableView.reloadData()
    }
    
    func setUpNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController!.searchBar.delegate = self
        self.definesPresentationContext = true
        
    }

   
}

extension ChatHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Chat History table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return self.searchGroupChannelList.count
        }else{
            
            return self.groupChannelsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "chatHistoryCell", for: indexPath) as? ChatHistoryTableViewCell {
            if searching {
                cell.setGroupChannel(groupChannel: searchGroupChannelList[indexPath.row])
            } else {
                cell.setGroupChannel(groupChannel: groupChannelsList[indexPath.row])
                
            }
            return cell
        }
        return UITableViewCell()
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            performSegue(withIdentifier: "chatView", sender: searchGroupChannelList[indexPath.row])
            
        }else {
            performSegue(withIdentifier: "chatView", sender: groupChannelsList[indexPath.row])
        }
        
    }
}

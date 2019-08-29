//
//  ChatHistoryViewController.swift
//  SendBird-ios
//
//  Created by Swift Legends on 25/08/2019.
//  Copyright © 2019 Swift Legends. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var newChatButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    var userIdAndFriendId: [String] = []
    var groupChannelsList: [SBDGroupChannel] = []
    var searchGroupChannel = [SBDGroupChannel]()
    var searching = false
    var channelListQuery: SBDGroupChannelListQuery?
    private var userIndex = 0
    var chatGroupChannel: SBDGroupChannel?

    

    
    private var refreshControl: UIRefreshControl?
    
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveListOfChannels(true)

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(ChatHistoryViewController.refreshGroupList), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
    }
    
    
    @objc func refreshGroupList(){
        retrieveListOfChannels(true)
    }
    
    
    func retrieveListOfChannels(_ refresh: Bool){
        if refresh {
            self.channelListQuery = nil
        }
        
        if self.channelListQuery == nil {
        channelListQuery = SBDGroupChannel.createMyGroupChannelListQuery()
        channelListQuery?.includeEmptyChannel = false
        }
        
        if channelListQuery?.hasNext == nil {
            return
        }
        channelListQuery?.loadNextPage(completionHandler: { (groupChannels, error) in
            guard error == nil else {   // Error.
                self.refreshControl?.endRefreshing()
                print("error in loading channels")
                return
            }
            if refresh {
                self.groupChannelsList.removeAll()
            }
            print(groupChannels?.count)
            for group in groupChannels! {
                print(group)
                self.groupChannelsList.append(group)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        })
        
       
        
    }
    
    @IBAction func clickOnNewChatButton(_ sender: Any) {
    performSegue(withIdentifier: "userList", sender: nil)
    }
    
    
    // MARK: Chat History table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return self.searchGroupChannel.count
        }else{
        
        return self.groupChannelsList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatHistoryCell", for: indexPath) as? ChatHistoryTableViewCell
        if searching {
        cell?.setGroupChannel(groupChannel: searchGroupChannel[indexPath.row])
            print(" we are searchiiiiinnnnngggg")
        } else {
        cell?.setGroupChannel(groupChannel: groupChannelsList[indexPath.row])
            print(" we are NOOOOOOOTTTTTT searchiiiiinnnnngggg")

        }
        return cell!



    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userIndex = indexPath.row
        if searching {
            self.chatGroupChannel = searchGroupChannel[userIndex]
        }else {
            self.chatGroupChannel = groupChannelsList[userIndex]
        }
        performSegue(withIdentifier: "chatViewController", sender: nil)


    }
    


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatViewController", let vc = segue.destination as? ChatViewController{
        vc.channel = self.chatGroupChannel
        }
    }
  

}
extension ChatHistoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        groupChannelsList.removeAll()
        searchGroupChannel.removeAll()
        channelListQuery = SBDGroupChannel.createMyGroupChannelListQuery()
        channelListQuery?.includeEmptyChannel = true
        channelListQuery?.channelNameContainsFilter = searchText
        channelListQuery?.loadNextPage(completionHandler: { (groupChannels, error) in
            guard error == nil else {   // Error.
                print("error search")
                return
            }
            self.searchGroupChannel.removeAll()

            for group in groupChannels! {
                self.searchGroupChannel.append(group)
            }

                self.searching = true
                self.tableView.reloadData()

        })

        
        
    }
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchGroupChannel.removeAll()
        groupChannelsList.removeAll()


        self.refreshGroupList()


    }
    
    
}

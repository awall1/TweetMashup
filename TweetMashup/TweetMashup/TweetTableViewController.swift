//
//  TweetTableViewController.swift
//  TweetMashup
//
//  Created by Alex on 11/19/16.
//  Copyright © 2016 awol. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController {
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    private var tweetsArray : [Tweet] = []
    @IBOutlet var tweetTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        refreshButton.tintColor = UIColor.red
        refreshButton.isEnabled = false
        TwitterAPI.sharedInstance.search(query: "%23Trump") {
            [weak self] (result: SearchResult) -> () in
            switch result {
            case .success(let tweets):
                self?.tweetsArray = tweets
            case .failure:
                print("Well that failed. Idealy I'd present a UIAlert to notify the user of failure here")
            }
            self?.refreshButton.tintColor = UIColor.blue
            self?.refreshButton.isEnabled = true
            self?.tweetTableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath)

        cell.textLabel?.text = tweetsArray[indexPath.row].message.replacingOccurrences(of: "Trump", with: "Clinton").replacingOccurrences(of: "Donald", with: "Hillary")
        cell.detailTextLabel?.text = tweetsArray[indexPath.row].user
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

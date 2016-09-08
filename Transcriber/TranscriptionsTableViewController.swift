//
//  TranscriptionsTableViewController.swift
//  Transcriber
//
//  Created by Ryan Lim on 9/5/16.
//  Copyright © 2016 Ryan Lim. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class TranscriptionsTableViewController: UITableViewController {

    var dummyItems: [String] = ["r", "y", "a", "n"]
    var reuseIdentifier = "TranscriptionsTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        checkPermissions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dummyItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TranscriptionsTableViewCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = dummyItems[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Permissions
    
    func checkPermissions(){
        //check if the program has access to the microphone
        let recordingAuthorized = AVAudioSession.sharedInstance().recordPermission() == .granted
        //check if the program has access to Siri Speech Recognition
        let transcribeAuthorized = SFSpeechRecognizer.authorizationStatus() == .authorized
        //check if the program has access to both the microphone and Siri Speech Recognition
        let authorized = recordingAuthorized && transcribeAuthorized
        
        //if the program does not have access to both the microphone and Siri Speech Recognition, present the screen that requests permission
        if !authorized {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PermissionsVc") {
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
        
    }

}

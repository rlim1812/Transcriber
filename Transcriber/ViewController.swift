//
//  ViewController.swift
//  Transcriber
//
//  Created by Ryan Lim on 9/5/16.
//  Copyright © 2016 Ryan Lim. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var grantButton: UIButton!
    
    @IBAction func grantPermission(_ sender: AnyObject) {
        requestRecordPermissions()
    }
    
    //flows through to transcribe permissions
    func requestRecordPermissions(){
        
        AVAudioSession.sharedInstance().requestRecordPermission () {
            [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    //get the transcription permissions
                    self.requestTranscribePermissions()
                } else {
                    //error
                    self.showError()
                }
            }
        }
        
    }
   
    func requestTranscribePermissions(){
        SFSpeechRecognizer.requestAuthorization { [unowned self] authorizationStatus in
            DispatchQueue.main.async {
                if authorizationStatus == .authorized {
                    //Great! Good to go!
                    self.dismiss(animated: true, completion: nil)
                } else {
                    //error handling
                    self.showError()

                }
            }
        }
    }
    
    func showError(){
        self.messageLabel.text = "You have previously denied this app access to speech recognition. Please change in settings and restart the app"
        self.disableButton()
    }
    
    func disableButton(){
        self.grantButton.isEnabled = false
        UIView.animate(withDuration: 1.0) {
            self.grantButton.alpha = 0.3
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


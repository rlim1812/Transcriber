//
//  RecordViewController.swift
//  Transcriber
//
//  Created by Ryan Lim on 9/6/16.
//  Copyright © 2016 Ryan Lim. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    
    @IBOutlet weak var recordingIndicator: UIActivityIndicatorView!

    @IBOutlet weak var textView: UITextView!
    
    var audioRecorder: AVAudioRecorder?
    var recorderFileUrl: URL!
    var textFileUrl: URL!
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let utils = Utilities()
        recorderFileUrl = utils.getAudioFileUrl()
        textFileUrl = utils.getTextFileUrl()
        
        print("ryank" + recorderFileUrl.absoluteString!)
        recordAudio()
        recordingIndicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        audioRecorder?.stop()
        recordingIndicator.stopAnimating()
        sender.titleLabel?.text = "Finished"
        sender.isEnabled = false
        sender.alpha = 0.2
        
    }
    
    //Mark: Audio Recording
    func recordAudio(){
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 44100, AVNumberOfChannelsKey: 2, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            audioRecorder = try AVAudioRecorder(url: recorderFileUrl, settings: settings)
            
            audioRecorder?.delegate = self
            audioRecorder?.record()
            recordingIndicator.startAnimating()
        } catch let error {
            //failed to record
            print("ryank failed recording \(error)")
            recordingEnded(success: false)
        }
        
        
    }
    
    func recordingEnded(success:Bool){
        audioRecorder?.stop()
        if success {
            do {
                //play and transcribe audio
                audioPlayer?.stop()
                audioPlayer = try AVAudioPlayer(contentsOf: recorderFileUrl)
                audioPlayer?.play()
                transcribeAudio()
                print("playing")
                
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        audioPlayer?.stop()
    }
    
    //Mark: Transcribe
    func transcribeAudio(){
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: recorderFileUrl)
        
        recognizer?.recognitionTask(with: request) {
            [unowned self] (result, error) in
            
            guard let result = result else {
                print("ryank" + String(error))
                return
            }
            
            if result.isFinal {
                let text = result.bestTranscription.formattedString
                self.textView.text = text
                do {
                    try text.write(to: self.textFileUrl, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    
                }
            }
            
        }
    }
    
    //Mark: Audio Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            recordingEnded(success: false)
        } else {
            recordingEnded(success: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

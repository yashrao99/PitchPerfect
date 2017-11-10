//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Yash Rao on 11/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - RecordSoundsViewController: AVAudioPlayerDelegate

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    // MARK: - Button outlets for RecordSoundsViewController
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    // MARK: - Stop recording button disabled once view loads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Controlling UI buttons using a function
    

    func switchLabelsandButtons(isRecording: Bool) {
        recordingLabel.text = isRecording ? "Recording in progress" : "Tap to record"
        recordButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
        }
    // MARK: - Record Audio function, enables stop button and changes record label first
    
    @IBAction func recordAudio(_ sender: Any) {
        
        switchLabelsandButtons(isRecording: true)
        
        // MARK: - Record Audio funciton, creates the audio file and sets the variable to the path directory and then records the audio
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    // MARK: - Stop Recording function
    
    @IBAction func stopRecording(_ sender: Any) {
        switchLabelsandButtons(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    // MARK: - Finished recording function, performs segue to PlaySoundsViewController
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording failed")
        }
    }
    // MARK: - Sends the recorded Audio URL to the PlaySoundsViewController prior to the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}


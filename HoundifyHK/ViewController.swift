//
//  ViewController.swift
//  HoundifyHK
//
//  Created by Eric Tan on 7/29/15.
//  Copyright (c) 2015 Harman International. All rights reserved.
//

import UIKit

let VOICE_SEARCH_END_POINT = "https://api.houndify.com/v1/audio"

class ViewController: UIViewController {

    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "";
        startListening()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* Starts listening through HoundVoiceSearch as view is loaded */
    func startListening() {
        HoundVoiceSearch.instance().startListeningWithCompletionHandler(
            {error in
                dispatch_async(dispatch_get_main_queue(), {
                    if error != nil {
                        self.textView.text = error.localizedDescription;
                    }
                })
            })
    }
    
    
    /* Callback for when the search button is pressed */
    @IBAction func searchPressed(sender: UIButton) {
        var currentState = HoundVoiceSearch.instance().state
        var stringRep: String!
        
        switch currentState
        {
            case HoundVoiceSearchState.None:
                stringRep = "None"
                break;
    
            case HoundVoiceSearchState.Ready:
                self.startSearch();
                stringRep = "Ready"
                break;
    
            case HoundVoiceSearchState.Recording:
                stringRep = "Recording"
                HoundVoiceSearch.instance().stopSearch();
                break;
    
            case HoundVoiceSearchState.Searching:
                stringRep = "Searching"
                HoundVoiceSearch.instance().cancelSearch();
                break;
  
            case HoundVoiceSearchState.Speaking:
                stringRep = "Speaking"
                HoundVoiceSearch.instance().stopSpeaking();
                break;
        }
        
        checkState(currentState)
        println(stringRep)
    }

    /* Helper method for changing the mic icon */
    func checkState(state: HoundVoiceSearchState) {
        
        var image: UIImage!
        
        if state == HoundVoiceSearchState.None ||
            state == HoundVoiceSearchState.Searching ||
            state == HoundVoiceSearchState.Recording {
            image = UIImage(named: "greenMic.png")
        }
        else {
            image = UIImage(named: "redMic.png")
        }
        
        self.searchBtn.setImage(image, forState: .Normal)
    }
    
    /* Helper method for taking in voice commands */
    func startSearch() {
        
        // Fill out with addional information if needed.
        var requestInfo = NSDictionary()
        
        // Configures voice search before searching
        var endPointURL = NSURL(string: VOICE_SEARCH_END_POINT)
        //HoundVoiceSearch.instance().enableSpeech = false;
        
        HoundVoiceSearch.instance().startSearchWithRequestInfo(
            requestInfo as [NSObject : AnyObject],
            userID: "testUser",
            endPointURL: endPointURL,
            responseHandler: {(error, responseType, response) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    if error != nil {
                        self.textView.text = error.localizedDescription;
                    }
                    else {
                        if (responseType == HoundVoiceSearchResponseType.PartialTranscription) {
                            self.textView.text = response["PartialTranscript"] as! String;
                        }
                        else if (responseType == HoundVoiceSearchResponseType.HoundServer) {
                            
                            let json = JSON(response)
                            self.textView.text = String(stringInterpolationSegment: response)
                            
                            let  spokenText = json["Disambiguation"]["ChoiceData"][0]["Transcription"].stringValue
                            println(spokenText)
                            
                            //if spokenText == "i am leaving"
                            
                        }
                    }
                }) // end dispatch
                
            }
        )
    }
    
}


//
//  ViewController.swift
//  HoundifyHK
//
//  Created by Eric Tan on 7/29/15.
//  Copyright (c) 2015 Harman International. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

let VOICE_SEARCH_END_POINT = "https://api.houndify.com/v1/audio"

class MainRecordVC: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    let locManager = CLLocationManager()
    var g_alert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBtn.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10
        textView.text = "";
        
        // Ask for location services for weather update
        locManager.delegate = self
        //locManager.requestWhenInUseAuthorization()
        locManager.requestAlwaysAuthorization()

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
    }
    
    /* Callback method for when logout btn is pressed */
    @IBAction func logoutPressed(sender: UIButton) {
        PFUser.logOut()
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
    
    /* Triggers event in Parse Cloud to send push notifcation to HKRules application */
    func triggerLeaveEventInCloud() {
        
        var username: AnyObject? = PFUser.currentUser()?["additional"]
        
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
                currentLocation = locManager.location
        }
        g_alert = UIAlertController(title: "Triggered event", message: "Attempting to call cloud code. This notification will disappear if the cloud code finished correctly", preferredStyle: .Alert)
        g_alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            self.dismissViewControllerAnimated(false, completion: nil)
        }))
        
        self.presentViewController(g_alert, animated: false, completion: nil)
        // Trigger event in Parse Cloud to send a push notification to HKRules
        PFCloud.callFunctionInBackground("prepareToLeaveHouse",
            withParameters:
                ["username":username! as! String,
                    "locationLatitude": currentLocation.coordinate.latitude,
                    "locationLongitude":currentLocation.coordinate.longitude]) {
            (response: AnyObject?, error: NSError?) -> Void in
            if error != nil {
                println("Error with triggering event.")
            } else {
                println("Successfully triggered event in the cloud!")
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
        
    }

    
    /* Helper method for taking in voice commands */
    func startSearch() {
        
        // Fill out with addional information if needed.
        var requestInfo = NSDictionary()
        
        // Configures voice search before searching
        var endPointURL = NSURL(string: VOICE_SEARCH_END_POINT)
        HoundVoiceSearch.instance().enableSpeech = false;
        
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
                            //self.textView.text = String(stringInterpolationSegment: response)
                            
                            let  spokenText = json["Disambiguation"]["ChoiceData"][0]["Transcription"].stringValue
                            println(spokenText)
                            
                            if spokenText == "i'm leaving now" ||
                                spokenText == "i am leaving now" ||
                                spokenText == "i'm leaving" {
                                // Trigger event in Parse Cloud to send a push notification to HKRules
                                self.triggerLeaveEventInCloud()
                            }
                            
                        }
                    }
                }) // end dispatch
                
            }
        )
    }
    
}


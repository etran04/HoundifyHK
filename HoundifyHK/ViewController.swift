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
    @IBOutlet weak var listenBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func listenPressed(sender: UIButton) {
    }
    
    func startSearch() {
        
        // Fill out with addional information if needed.
        var requestInfo = NSDictionary()
        
        var endPointURL = NSURL(string: VOICE_SEARCH_END_POINT)
        
        /*HoundVoiceSearch.instance().startSearchWithRequestInfo(
            requestInfo as [NSObject : AnyObject],
            userID: "testUser",
            endPointURL: endPointURL,
            responseHandler: {(error, responseType, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if ((error) != nil) {
                        self.textView.text = error.localizedDescription;
                    }
                    else {
                        if (responseType == HoundVoiceSearchResponseType.PartialTranscription) {
                            self.textView.text = "PartialTranscript";
                        }
                        else if (responseType == HoundVoiceSearchResponseType.HoundServer) {
                            let json = JSON(response)
                            println(json["Status"]);
                        }
                    }
                    
                })
            }
        )*/
    
    }

}


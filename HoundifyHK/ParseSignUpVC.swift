//
//  ParseSignUpVC.swift
//  HoundifyHK
//
//  Created by Eric Tan on 8/17/15.
//  Copyright (c) 2015 Harman International. All rights reserved.
//

import UIKit
import ParseUI

class ParseSignUpVC: PFSignUpViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the logo to Harman in signUpVC
        let harmanSignUpLogo = UIImageView(image: UIImage(named:"Harman_Logo.png"))
        self.signUpView?.logo = harmanSignUpLogo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.signUpView?.logo?.frame = CGRect(x: 30, y: 30, width: 350, height: 270)
    }

}

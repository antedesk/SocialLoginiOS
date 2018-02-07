//
//  ViewController.swift
//  SocialLoginHMTLit
//
//  Created by antonio.tedeschi on 02/02/18.
//  Copyright © 2018 antedesk. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var statusText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        statusText.text = "Google Sign in"
        
        toggleAuthUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        statusText.text = "Signed out"
        toggleAuthUI()
    }
    
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
        } else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            statusText.text = "Google Sign in"
        }
    }
}

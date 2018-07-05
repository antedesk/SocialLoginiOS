//
//  ViewController.swift
//  SocialLoginHMTLit
//
//  Created by antonio.tedeschi on 02/07/18.
//  Copyright © 2018 antedesk. All rights reserved.
//

import UIKit
import TwitterKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var userIdLabel: UILabel!
    var logInButton: TWTRLogInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                let authToken = session!.authToken
                let authTokenSecret = session!.authTokenSecret
                let credential = TwitterAuthProvider.credential(withToken: authToken, secret: authTokenSecret)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        print("error: \(error.localizedDescription)");
                        return
                    }
                    if let userName = user?.displayName{
                        print("hi \(userName)");
                        self.userIdLabel.text = "Hi \(userName)!"
                    }
                    self.toggleAuthUI()
                }
                
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        toggleAuthUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogOut(_ sender: AnyObject) {
        
        let store = Twitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        print("[LogOut] - User has session: \(Twitter.sharedInstance().sessionStore.hasLoggedInUsers())")
        toggleAuthUI()
    }

    func toggleAuthUI() {
        print("[Toggle] - User has session: \(Twitter.sharedInstance().sessionStore.hasLoggedInUsers())")
        if (Twitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            // Signed in
            print("\nUser Session\n")
            logInButton.isHidden = true
            logOutButton.isHidden = false
        } else {
            print("\nNo User session\n")
            logInButton.isHidden = false
            logOutButton.isHidden = true
            userIdLabel.text = "Twitter Login"
        }
    }

}


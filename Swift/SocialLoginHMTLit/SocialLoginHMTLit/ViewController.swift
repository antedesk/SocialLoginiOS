//
//  ViewController.swift
//  SocialLoginHMTLit
//
//  Created by antonio.tedeschi on 02/02/18.
//  Copyright © 2018 antedesk. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var userIdLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.center = view.center
        loginButton.readPermissions = ["email", "public_profile"]
        view.addSubview(loginButton)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        let firebaseAuth = Auth.auth()
        
        firebaseAuth.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            print("Successfully logged in with our user: ", user ?? "")
            
            let user = Auth.auth().currentUser
            let displayName = user?.displayName
            self.userIdLabel.text = displayName
            
            print("Logged in ", user?.displayName)
        })
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        userIdLabel.text = "Facebook Login"
        print("Logged out!")
    }
    
    
    
}


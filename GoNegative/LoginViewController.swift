//
//  ViewController.swift
//  FacebookLoginTry
//
//  Created by Tejas Upmanyu on 13/04/17.
//  Copyright © 2017 VisionArray. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController{

    var userDetails = [String:String]()
    var userStorage : FIRStorageReference!
    var DBRef : FIRDatabaseReference!
    
    
    
    

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true

    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var CustomLoginButton: RoundButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tabBarController?.tabBarItem.image = UIImage(named: "share")
        
        let storage = FIRStorage.storage().reference(forURL: "gs://gonegative-b2a79.appspot.com")
        userStorage = storage.child("users")
        
        DBRef = FIRDatabase.database().reference()
        
        
        
        
        
    }
    

    @IBAction func handleLogin(_ sender: RoundButton) {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, err) in
            if err != nil
            {
                print("Custom Login Failed")
                CDAlertView(title: "Custom Sign in Error", message: "There was a problem with Custom Sign in. If this problem persists, try a different account.", type: .error).show()
               
            }
            
            
            self.showFBDetails()
        }
        
        
    }
    
    
    func showFBDetails() {
        
        
        let params = ["fields" : "email, name, picture.width(198).height(198)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: params).start { (connection, result, err) in
            
            if err != nil
            {
                print("Graph Request Failed")
                CDAlertView(title: "Facebook Sign in Error", message: "There was a problem with Facebook Sign in. If this problem persists, try a different account.", type: .error).show()
                return
            }
            
            print("\(String(describing: result))")
            
            
            if let dict = result as? NSDictionary
            {
                self.parse(dict: dict)
            }
            
            
            self.nameLabel.text = self.userDetails["userName"]
            
            
            let userDefaults = UserDefaults.standard
            
            userDefaults.set("true", forKey: "loginComplete")
            userDefaults.set(self.userDetails["userName"], forKey: "userName")
            userDefaults.set(self.userDetails["userMail"], forKey: "userMail")
            userDefaults.set(self.userDetails["userProfileImageURL"], forKey: "userProfileImageURL")
            
            userDefaults.synchronize()
            
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "userProfileViewController") as? ProfileViewController {
                // 2: success! Set its property
                vc.userInfo = self.userDetails
                // 3: now push it onto the navigation controller
                self.performSegue(withIdentifier: "LoginComplete", sender: self)
                
            }
            
        }
        
        let accessToken = FBSDKAccessToken.current()
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil
            {
                print("error! FireBase Facebook Sign in not possible")
                CDAlertView(title: "Facebook Sign in Error", message: "There was a problem with Facebook Sign in. If this problem persists, try a different account.", type: .error).show()
                return
            }
            print("Successfully Logged in with Firebase Facebook.")
            
            if let user = user
            {
                let aboutUser : [String: Any] = ["uid":user.uid,"name":self.userDetails["userName"]!,"email":self.userDetails["userMail"]!,"urlToProfileImage":self.userDetails["userProfileImageURL"]!]
                self.DBRef.child("users").child(user.uid).setValue(aboutUser)
                
                
            }
            
            

            
        })

        
        
        

    }
    
    
    
    func parse(dict : NSDictionary) {
        
        let userName = dict["name"]
        let userMail = dict["email"]
        let userProfileImageURL = dict.value( forKeyPath: "picture.data.url" )!
        
        let userObj = ["userName":userName,"userMail":userMail,"userProfileImageURL": userProfileImageURL]
        self.userDetails = userObj as! [String : String]
        
    }

    
    func showError(errorMessage : String) {
        let ac = UIAlertController(title: "\(errorMessage)", message: "There was a problem loading; please try again.\(errorMessage)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
       
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


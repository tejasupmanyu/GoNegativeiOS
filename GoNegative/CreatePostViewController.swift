//
//  CreatePostViewController.swift
//  FacebookLoginTry
//
//  Created by Tejas Upmanyu on 16/04/17.
//  Copyright © 2017 VisionArray. All rights reserved.
//

import UIKit
import Firebase

 
class CreatePostViewController: UIViewController , UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{


    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        
        postText.endEditing(true)
    }
    
    
    @IBOutlet var panGestureRecogniser: UIPanGestureRecognizer!
    @IBOutlet weak var submtButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var postImage: RoundImageView!
        
        
    @IBOutlet weak var selectImageButton: RoundButton!
    @IBOutlet weak var postText: KMPlaceholderTextView!
    
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        postText.delegate = self
        postText.font = UIFont(name: "AvenirNext-Regular" , size: 24)
        
        let toolBarView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 35))
        toolBarView.backgroundColor = UIColor.darkGray
        
//        postText.inputAccessoryView = toolBarView
        picker.delegate = self
        
        
        
    }
    
    
    
   
    
    
    @IBAction func ImageSelector(_ sender: RoundButton) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
        
    
    
    
    @IBAction func cancelPost(_ sender: UIBarButtonItem) {
        
        self.postText.text = ""
        self.postImage.image = nil
        
       self.performSegue(withIdentifier: "cancelPost", sender: self)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.postImage.image = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
        self.selectImageButton.alpha = 0
    }
    
    
    
    
    
    @IBAction func submitPost(_ sender: UIBarButtonItem) {
        
        if postImage.image == nil
        {
            CDAlertView(title: "No Image Selected", message: "We definiely need a image for this awesome post.", type: .error).show()
            return
        }
        
        SwiftSpinner.show("Submitting your post...")
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let postDate = formatter.string(from: date)
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let DBref = FIRDatabase.database().reference()
        let Storage = FIRStorage.storage().reference(forURL: "gs://gonegative-b2a79.appspot.com")
        let key = DBref.child("posts").childByAutoId().key
        let ImageRef = Storage.child("posts").child(uid).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(postImage.image!, 0.6)
        let uploadTask = ImageRef.put(data!, metadata: nil) { (metadata, error) in
                if error != nil
                {
                    print("Error Uploading Image to Firebase ")
                    SwiftSpinner.show(duration: 2, title: "Error! Try again please.")
                    SwiftSpinner.hide()
                    CDAlertView(title: "Post Unsuccessful", message: "Your Story couldn't reach us. Try Again", type: .error).show()
                    return
                }
            SwiftSpinner.show(duration: 3, title: "Almost there...", animated: true)
            ImageRef.downloadURL(completion: { (url, error) in
                
                if let url = url{
                    let feed = ["userID":uid,"postImageURL":url.absoluteString,"storyText": self.postText.text,"likes": 0,"author": UserDefaults.standard.string(forKey: "userName")!,"postDate": postDate,"postID": key] as [String : Any]
                    let postFeed = ["\(key)": feed]
                    DBref.child("posts").updateChildValues(postFeed)
                    
                    SwiftSpinner.show(duration: 2, title: "Done", animated: true)
                    CDAlertView(title: "Post Successful", message: "Your Story is now safe with us.", type: .success).show()
                    SwiftSpinner.hide()
                    self.performSegue(withIdentifier: "cancelPost", sender: self)
                    
                    
                    
                }
            })
            
            }
        uploadTask.resume()
        
        }
    
    }


    



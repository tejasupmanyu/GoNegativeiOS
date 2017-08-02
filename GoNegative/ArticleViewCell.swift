//
//  ArticleViewCell.swift
//  HackathonPrototype
//
//  Created by Tejas Upmanyu.
//  Copyright © 2017 VisionArray. All rights reserved.
//

import UIKit
import Firebase

class ArticleViewCell: UICollectionViewCell {

    var PostID : String!
    
    
    
    @IBOutlet weak var ThumbNail: RoundImageView!
    
    @IBOutlet weak var AuthorNameLabel: UILabel!
    @IBOutlet weak var readMore: UIButton!
    
    @IBOutlet weak var NewsTitle: UILabel!

    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var CoverImage: RoundImageView!
    
    @IBOutlet weak var storyTextView: UITextView!
   
    @IBAction func readControl(_ sender: Any) {
        
        let button = sender as! UIButton
        if button.titleLabel?.text == "Read More"
        {
            button.setTitle("Read Less", for: .normal)
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.storyTextView.isHidden = false
            })
            
        }
        else
        {
            button.setTitle("Read More", for: .normal)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.storyTextView.isHidden = true
            })
        }
    }
    
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heartButton: FaveButton!
    @IBOutlet weak var shareButton: FaveButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    
        
    }
    
    @IBAction func likePressed(_ sender: FaveButton) {
        
        let ref = FIRDatabase.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        self.heartButton.isEnabled = false
        
        ref.child("posts").child(self.PostID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let post = snapshot.value as? [String: AnyObject]
            {
                let updateLikes : [String: Any] = ["peopleWhoLike/\(keyToPost)": FIRAuth.auth()!.currentUser!.uid]
                
                ref.child("posts").child(self.PostID).updateChildValues(updateLikes, withCompletionBlock: { (err, reff) in
                    
                    if err == nil
                    {
                        ref.child("posts").child(self.PostID).observeSingleEvent(of: .value, with: { (snap) in
                            
                            if let properties = snap.value as? [String: AnyObject]
                            {
                                if let likes = properties["peopleWhoLike"] as? [String: AnyObject]
                                {
                                    let count = likes.count
                                    self.likesLabel.text = "\(count) likes"
                                    let update = ["likes":count]
                                    ref.child("posts").child(self.PostID).updateChildValues(update)
                                    self.heartButton.isHidden = true
                                    self.heartButton.isEnabled = true
                                }
                            }
                        })
                    }
                })
                
            }
        })
    }

}


func color(_ rgbColor: Int) -> UIColor{
    return UIColor(
        red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
        blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
        alpha: CGFloat(1.0)
    )
}


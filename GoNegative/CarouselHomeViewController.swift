//
//  CarouselHomeViewController.swift
//  HackathonPrototype
//
//  Created by Tejas Upmanyu.
//  Copyright © 2017 VisionArray. All rights reserved.
//

import UIKit
import Firebase

class CarouselHomeViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, FaveButtonDelegate{

    
    @IBOutlet weak var FeedView: UICollectionView!

    //@IBOutlet weak var frontView: UIView!
    @IBOutlet weak var heartButton: FaveButton?
    @IBOutlet weak var shareButton: FaveButton?
    var posts = [Post]()
    var authorsImages = [String]()
    var finishedLoading = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FeedView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FeedView.delegate = self
        FeedView.dataSource = self
//        SwiftSpinner.useContainerView(frontView)
//        SwiftSpinner.show(duration: 8, title: "Loading...")
        
        fetchPosts()
        
        
        
    }
    
    func fetchPosts()
    {
        finishedLoading = false
        var i = 0
        let DBRef = FIRDatabase.database().reference()
        
        DBRef.child("posts").queryOrderedByKey().observe(.value, with: { (DBSnapshot) in
            if i == 0
            {
                SwiftSpinner.show(duration: 3, title: "Fetching your Favourite posts...")
                i = 1
            }
            
            self.posts = [Post]()
            let allPosts = DBSnapshot.value as! [String: AnyObject]

                for (_,posts) in allPosts
                {
                    
                    let individualPost = Post()
                    if let author = posts["author"] as? String, let likes = posts["likes"] as? Int, let postText = posts["storyText"] as? String, let postDate = posts["postDate"] as? String, let postID = posts["postID"] as? String,let urlToPostImage = posts["postImageURL"] as? String, let userID = posts["userID"] as? String, let postTitle = posts["postTitle"] as? String, let authorImageURL = posts["urlToAuthorImage"] as? String{
                        
                        individualPost.author = author
                        individualPost.likes = likes
                        individualPost.postDate = postDate
                        individualPost.postText = postText
                        individualPost.postTitle = postTitle
                        individualPost.urlToPostImage = urlToPostImage
                        individualPost.postID = postID
                        individualPost.userID = userID
                        individualPost.urlToAuthorImage = authorImageURL
                        
                        if let people = posts["peopleWhoLike"] as? [String: AnyObject]
                        {
                            for(_,person) in people
                            {
                                individualPost.peopleWhoLiked.append(person as! String)
                            }
                        }
                        
                        self.posts.append(individualPost)
                        self.FeedView.reloadData()
                        self.finishedLoading = true
                    }
                    

                }
            
        })
        
               DBRef.removeAllObservers()
        //self.frontView.removeFromSuperview()
    }
    
    
   
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let ArticleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! ArticleViewCell
            ArticleCell.NewsTitle.text = self.posts[indexPath.row].postTitle
            ArticleCell.PostID = self.posts[indexPath.row].postID
            ArticleCell.CoverImage.sd_setShowActivityIndicatorView(true)
            ArticleCell.CoverImage.sd_setIndicatorStyle(.whiteLarge)
            ArticleCell.CoverImage.sd_setImage(with: URL(string: self.posts[indexPath.row].urlToPostImage), placeholderImage: UIImage(named:"Placeholder"), options: [.progressiveDownload,.continueInBackground,.scaleDownLargeImages,])
            ArticleCell.storyTextView.text = self.posts[indexPath.row].postText
            ArticleCell.storyTextView.font = UIFont(name: "AvenirNext-Regular" , size: 16)
            
        
           
            for person in self.posts[indexPath.row].peopleWhoLiked
            {
                
                if person == FIRAuth.auth()!.currentUser!.uid
                {
                    ArticleCell.heartButton.isHidden = true
                    break
                }
                
            }
            ArticleCell.likesLabel.text = "\(self.posts[indexPath.row].likes!) likes"
            ArticleCell.ThumbNail.sd_setImage(with: URL(string: self.posts[indexPath.row].urlToAuthorImage), placeholderImage: UIImage(named: "authorPlaceholder"))
            ArticleCell.AuthorNameLabel.text = self.posts[indexPath.row].author
            
        
            return ArticleCell


       
    }
    
    
    
    
    
    let colors = [
        DotColors(first: color(0x7DC2F4), second: color(0xE2264D)),
        DotColors(first: color(0xF8CC61), second: color(0x9BDFBA)),
        DotColors(first: color(0xAF90F4), second: color(0x90D1F9)),
        DotColors(first: color(0xE9A966), second: color(0xF8C852)),
        DotColors(first: color(0xF68FA7), second: color(0xF6A2B8))
    ]
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool){
    }
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
        if( faveButton === heartButton || faveButton === shareButton){
            return colors
        }
        return nil
    }

    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}







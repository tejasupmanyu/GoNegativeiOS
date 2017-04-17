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

    @IBOutlet weak var heartButton: FaveButton?
    @IBOutlet weak var shareButton: FaveButton?
    var posts = [Post]()
    var authorsImages = [String]()
    
    
    var BackGroundImageArray = ["cover","mainBackground","cover","mainBackground","cover","mainBackground","cover","mainBackground","cover","mainBackground"]
    var CellTitles = ["Tejas","Shabbir","Shivam","Tejas","Shabbir","Shivam","Tejas","Shabbir","Shivam","VisionArray"]
    var ArticleHeadings = ["Nigga hua Agwa","Khatarnak Nigga","App is working","Nigga hua Agwa","Khatarnak Nigga","App is working","Nigga hua Agwa","Khatarnak Nigga","App is working","Designed by Tejas Upmanyu"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FeedView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FeedView.delegate = self
        FeedView.dataSource = self
                fetchPosts()
        
        
    }
    
    func fetchPosts()
    {
        let DBRef = FIRDatabase.database().reference()
        
        DBRef.child("posts").queryOrderedByKey().observe(.value, with: { (DBSnapshot) in
            SwiftSpinner.show(duration: 5, title: "Fetching your Favourite posts...")
            let allPosts = DBSnapshot.value as! [String: AnyObject]
            print(allPosts)
            for (_,posts) in allPosts
            {
                print(posts)
                let individualPost = Post()
                if let author = posts["author"] as? String, let likes = posts["likes"] as? Int, let postText = posts["storyText"] as? String, let postDate = posts["postDate"] as? String, let postID = posts["postID"] as? String,let urlToPostImage = posts["postImageURL"] as? String, let userID = posts["userID"] as? String{
                    
                    
                    individualPost.author = author
                    individualPost.likes = likes
                    individualPost.postDate = postDate
                    individualPost.postText = postText
                    individualPost.urlToPostImage = urlToPostImage
                    individualPost.postID = postID
                    individualPost.userID = userID
                    
                    self.posts.append(individualPost)
                }
            }
            
            
            print(self.posts)
            self.FeedView.reloadData()
        })
        
        
        DBRef.removeAllObservers()
    }
    
    
    
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let ArticleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! ArticleViewCell
            ArticleCell.NewsTitle.text = "Post title"
            ArticleCell.CoverImage.downloadImage(from: self.posts[indexPath.row].urlToPostImage)
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







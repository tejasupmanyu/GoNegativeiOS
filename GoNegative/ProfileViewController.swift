//
//  ProfileViewController.swift
//  FacebookLoginTry
//
//  Created by Tejas Upmanyu on 13/04/17.
//  Copyright © 2017 VisionArray. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {

    

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    var userInfo = [String:String]()
    var cellHeadings = ["Account Details","Settings","About"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Profile"
        
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        

        
        let userDefaults = UserDefaults.standard
        print(userDefaults.string(forKey: "userProfileImageURL")!)
        
        profileImage.downloadImage(from: userDefaults.string(forKey: "userProfileImageURL")!)
        userNameLabel.text = userDefaults.string(forKey: "userName")
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellHeadings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = cellHeadings[indexPath.row]
        return cell

    }
    

    
}

extension UIImageView{
    func downloadImage(from url: String)
    {
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest){(data,response,error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
                
            }
        }
        task.resume()
    }
}


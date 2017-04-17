//
//  ArticleViewCell.swift
//  HackathonPrototype
//
//  Created by Tejas Upmanyu.
//  Copyright © 2017 VisionArray. All rights reserved.
//

import UIKit

class ArticleViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var ThumbNail: RoundImageView!
    
    @IBOutlet weak var AuthorNameLabel: UILabel!
    
    @IBOutlet weak var NewsTitle: UILabel!

    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var CoverImage: RoundImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heartButton: FaveButton!
    @IBOutlet weak var shareButton: FaveButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
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


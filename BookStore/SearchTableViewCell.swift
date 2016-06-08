//
//  SearchTableViewCell.swift
//  BookStore
//
//  Created by babykang on 6/8/16.
//  Copyright © 2016 babykang. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    var hadTapped = true
    
     @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var  authorLabel:UILabel!
    @IBOutlet weak  var bookImage: UIImageView!
    @IBOutlet weak var markButton: UIButton!
    
    @IBAction func mark(sender: UIButton) {
        if markButton.enabled{
            markButton.titleLabel!.text = "★"
        }else {
            markButton.titleLabel?.text = "☆"
        }
    }
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

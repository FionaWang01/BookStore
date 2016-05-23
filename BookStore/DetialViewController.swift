//
//  DetialViewController.swift
//  BookStore
//
//  Created by babykang on 5/21/16.
//  Copyright © 2016 babykang. All rights reserved.
//

import UIKit

class DetialViewController: UIViewController {
    
    @IBOutlet weak var menuImage: UIImageView!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var translatorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    var searchDetailResult :SearchResult?
    var downloadTask:NSURLSessionDownloadTask?
    
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 231.0/255.0, green: 95.0/255.0, blue: 53.0/255.0, alpha: 0.3)
//        if let barFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 22.0){
//            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:barFont]
//            title = self.searchDetailResult?.title
//        }
//        scrollView.backgroundColor = UIColor.clearColor()
//        scrollView.contentSize = summaryLabel.bounds.size
//        scrollView.contentSize.width = 0
//        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
//        summaryLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        summaryLabel.numberOfLines = 0
//
        textView.backgroundColor = UIColor.clearColor()
        //textView.textColor = UIColor.whiteColor()
       // textView.font = UIFont.systemFontSize(20.0)
        textView.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 17.0)

        updateUI()
        
    }
    
    func updateUI(){
        if let url = NSURL(string: searchDetailResult!.mediumImage){
            downloadTask = menuImage.loadImageWithURL(url)
            print("imageURL:\(url)")
        }
        authorLabel.text = searchDetailResult?.author
        translatorLabel.text = searchDetailResult?.translator
        publisherLabel.text = searchDetailResult?.publisher
        priceLabel.text = searchDetailResult?.price
        textView.text = searchDetailResult?.summary
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

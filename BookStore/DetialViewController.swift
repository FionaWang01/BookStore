//
//  DetialViewController.swift
//  BookStore
//
//  Created by babykang on 5/21/16.
//  Copyright © 2016 babykang. All rights reserved.
//

import UIKit

protocol DetialViewControllerDelegate {

func addItemViewController(controller: DetialViewController, finishedAddItems item: SearchResult)
}

class DetialViewController: UIViewController {
    
    @IBOutlet weak var menuImage: UIImageView!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var translatorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bookNameText: UITextView!
    
   
    var searchDetailResult = SearchResult()
    
    var pushToStake = true
    
   var delegate : DetialViewControllerDelegate?

    var downloadTask:NSURLSessionDownloadTask?
    
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.backgroundColor = UIColor.clearColor()
         textView.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 17.0)

        updateUI()
    }
    
    
    func updateUI(){
        
        if let url = NSURL(string: searchDetailResult.mediumImage){
            downloadTask = menuImage.loadImageWithURL(url)
            print("imageURL:\(url)")
        }
        
        authorLabel.text = searchDetailResult.author
        translatorLabel.text = searchDetailResult.translator
        publisherLabel.text = searchDetailResult.publisher
        priceLabel.text = searchDetailResult.price
        textView.text = searchDetailResult.summary
        bookNameText.text = searchDetailResult.title
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowMarkCell"{
//            let navigation = segue.destinationViewController as! UINavigationController
//            let controller = navigation.topViewController as! BookMarkTableView
//            controller.delegate = self
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func markToStake(sender: UIButton) {
        let item = SearchResult()
        item.title = searchDetailResult.title
        delegate?.addItemViewController(self , finishedAddItems: item)
        }
}


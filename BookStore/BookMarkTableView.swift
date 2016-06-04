//
//  BookMarkTableView.swift
//  BookStore
//
//  Created by babykang on 5/26/16.
//  Copyright © 2016 babykang. All rights reserved.
//

import UIKit

class BookMarkTableView: UITableViewController {
    
    var downloadTask:NSURLSessionDownloadTask?
    
    var searchResult = [SearchResult]()
    
    @IBOutlet var bookMarkTableView: UITableView!
   
    @IBOutlet weak var textField: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 260.0/255.0, green: 72.0/255.0, blue: 117.0/255.0, alpha: 1)
        bookMarkTableView.rowHeight = 50
       
    }

    @IBAction func returnButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true , completion: nil )
    }
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResult.count
    }

    func configure(cell:UITableViewCell, cellForRowPathItems item: SearchResult){
        let image = cell.viewWithTag(101) as! UIImageView
        let title = cell.viewWithTag(102) as! UILabel
        let time = cell.viewWithTag(103) as! UILabel
       image.image = UIImage(named: "Placeholder")
        if let url = NSURL(string:item.mediumImage){
            downloadTask = image.loadImageWithURL(url)
        }
        title.text = item.title
        let currentTime = NSDate()
        time.text = "\(currentTime)"
        

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookMarkCell", forIndexPath: indexPath)
        let item = searchResult[indexPath.row]
       configure(cell, cellForRowPathItems: item)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            let item = searchResult[indexPath.row]
            configure(cell, cellForRowPathItems: item)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
   
}

extension BookMarkTableView: DetialViewControllerDelegate{
    
    func addItemViewController(controller: DetialViewController, finishedAddItems item: SearchResult){
        let newRowIndex = searchResult.count
        searchResult.append(item)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)

    }
}





















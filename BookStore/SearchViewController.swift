//
//  SearchViewController.swift
//  BookStore
//
//  Created by babykang on 5/21/16.
//  Copyright © 2016 babykang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults = [SearchResult]()
    var hasSearch = false
    var downloadTask: NSURLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = 80.0
        searchBar.becomeFirstResponder()
        self.title = searchBar.text
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 260.0/255.0, green: 72.0/255.0, blue: 117.0/255.0, alpha: 1)
        if let barFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 22.0){
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:barFont]
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func urlWithSearchText(searchText:String) -> NSURL{
        let api = "https://api.douban.com/v2/book/search?tag=%@"
        let escaopSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let urlString = String(format: api, escaopSearchText!)
        let url = NSURL(string: urlString)
        return url!
    }
    
    func performRequestWithURL(url:NSURL)->String?{
        do {
            return try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        }catch{
            print("Download error:\(error)")
            return nil
        }
    }
    
    func parseJSON(jsonString: String)->NSDictionary?{
        guard let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
            else {return nil}
        do {
            return try NSJSONSerialization.JSONObjectWithData(data , options: []) as? NSDictionary
        }catch{
            print("JSON ERROR :\(error)")
            return nil
        }
    }
    
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Whoops...",
            message:
            "There was an error reading from the iTunes Store. Please try again.",
            preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func parseDictionary (dictionary:[String: AnyObject])->[SearchResult]{
        if let books = dictionary["books"] as? [[String: AnyObject]] {
            //                print("----- \(books)")
            for book in books {
                let searchResult = SearchResult()
                
                if let images = book["images"] as? [String:AnyObject]{
                    for _ in images{
                        if let smallImage = images["small"] as? String{
                            searchResult.smallImage = smallImage
                        }
                        if let largeImage = images["large"] as? String{
                            searchResult.largeImage = largeImage
                        }
                        if let mediumImage = images["medium"] as? String{
                            searchResult.mediumImage = mediumImage
                        }
                    }
                }
                if let title = book["title"] as? String{
                    searchResult.title = title
                }
                if let publisher = book["publisher"] as? String{
                    searchResult.publisher = publisher
                }
                
                if let pubdate = book["pubdate"] as? String{
                    searchResult.pubdate = pubdate
                }
                
                if let price = book["price"] as? String{
                    searchResult.price = price
                }
                
                if let pages = book["pages"] as? String{
                    searchResult.pages = pages
                }
                
                if let authorInfor = book["author_intro"] as? String{
                    searchResult.authorIntro = authorInfor
                }
                
                if let summary = book["summary"] as? String{
                    searchResult.summary = summary
                }
                
                if let authors = book["author"] as? [String]{
                    let author = authors[0]
                    searchResult.author = author
                }
                
                if let translators = book["translator"] as? [String]{
                    if translators.count > 0 {
                        let translator = translators[0]
                        searchResult.translator = translator
                    }else {
                        print("translator.count is null")
                    }
                }
                
                
                let result = searchResult
                searchResults.append(result)
            }
        }
        return searchResults
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItem"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let navigationController = segue.destinationViewController as! UINavigationController
                let controller = navigationController.topViewController as! DetialViewController
                controller.searchDetailResult = searchResults[indexPath.row]
            }
        }
    }
    
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearch{
            return 0
        }else if searchResults.count == 0 {
            return 1
        }else{
            return searchResults.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let nameLabel = cell.viewWithTag(1000) as! UILabel
        let detailLabel = cell.viewWithTag(2000) as! UILabel
        let image = cell.viewWithTag(3000) as! UIImageView
        let indexPath = searchResults[indexPath.row]
        nameLabel.text = indexPath.title
        detailLabel.text = indexPath.author
        image.image = UIImage(named: "Placeholder")
//        image.layer.cornerRadius = image.frame.size.width/2
//        image.clipsToBounds = true
        if let url = NSURL(string:indexPath.largeImage){
            downloadTask = image.loadImageWithURL(url)
        }
        
        //image.backgroundColor = UIColor.yellowColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.count == 0 {
            return nil
        }else{
            return indexPath
        }
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty{
            searchBar.resignFirstResponder()
            searchResults = [SearchResult]()
            hasSearch = true
            
            let url = urlWithSearchText(searchBar.text!)
            print("URL: \(url)")
            if let jsonData = performRequestWithURL(url){
                print("Recieved JSON data: \(jsonData)")
                if let dictionary = parseJSON(jsonData){
                    print("Parse Dictionary:\(dictionary)")
                    parseDictionary(dictionary as! [String:AnyObject])
                    tableView.reloadData()
                    return
                }
            }
            
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}





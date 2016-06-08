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
    var isLoading = false
    static let loadingCell = "LoadingView"
    var hadTap = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)

        tableView.rowHeight = 80.0
        searchBar.becomeFirstResponder()
        self.title = searchBar.text
        
        var cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "NothingFoundCell")
        
        cellNib = UINib(nibName: "LoadingView", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "LoadingView")
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 260.0/255.0, green: 72.0/255.0, blue: 117.0/255.0, alpha: 1)
//        if let barFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 22.0){
//            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:barFont]
//            
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func urlWithSearchText(searchText:String) -> NSURL{
        let api = "https://api.douban.com/v2/book/search?tag=%@&limit=200"
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
                
                if let id = book["id"] as?String{
                    searchResult.id = id
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
                    if authors.count > 0{
                    let author = authors[0]
                     searchResult.author = author
                    }else{
                        print("Index Out OF Range")
                    }
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
        
//        if segue.identifier == "ShowStarBook"{
//                let navigationController = segue.destinationViewController as! UINavigationController
//                let controller = navigationController.topViewController as! DetialViewController
//                let secNavi = segue.destinationViewController as! UINavigationController
//                let desController = secNavi.topViewController as! BookMarkTableView
//                controller.results = desController.searchResult
//
//        }
//    
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading{
            return 1
        }else if !hasSearch{
            return 0
        }else if searchResults.count == 0 {
            return 1
        }else{
            return searchResults.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isLoading{
            let cell = tableView.dequeueReusableCellWithIdentifier("LoadingView", forIndexPath: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        }else if searchResults.count == 0 {
            return  tableView.dequeueReusableCellWithIdentifier("NothingFoundCell", forIndexPath: indexPath)
        }else{
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SearchTableViewCell
//        let nameLabel = cell.viewWithTag(1000) as! UILabel
//        let detailLabel = cell.viewWithTag(2000) as! UILabel
//        let image = cell.viewWithTag(3000) as! UIImageView
//        let starButton = cell.viewWithTag(4000) as! UIButton

        let indexPath = searchResults[indexPath.row]
        cell.bookNameLabel.text = indexPath.title
        cell.authorLabel.text = indexPath.author
        cell.bookImage.image = UIImage(named: "Placeholder")
        cell.bookImage.layer.cornerRadius = cell.bookImage.frame.size.width/2
        cell.bookImage.clipsToBounds = true
        if let url = NSURL(string:indexPath.largeImage){
            downloadTask = cell.bookImage.loadImageWithURL(url)
        }
        
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.count == 0 || isLoading{
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
            isLoading = true
            tableView.reloadData()
            
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            
            dispatch_async(queue){
            
            let url = self.urlWithSearchText(searchBar.text!)
            print("URL: \(url)")
            if let jsonData = self.performRequestWithURL(url){
                print("Recieved JSON data: \(jsonData)")
                if let dictionary = self.parseJSON(jsonData){
                    print("Parse Dictionary:\(dictionary)")
                    self.parseDictionary(dictionary as! [String:AnyObject])
                    self.isLoading = false
                    self.tableView.reloadData()
                    print("DONE!")
                    return
                }
                }
                print("Error!")
            }
            
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}





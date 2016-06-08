//
//  SearchResult.swift
//  BookStore
//
//  Created by babykang on 5/21/16.
//  Copyright © 2016 babykang. All rights reserved.
//

import Foundation

class SearchResult{
    var id = ""
    var title = ""
    var author = ""
    var translator = ""
    var publisher = ""
    var authorIntro = ""
    var summary = ""
    var pages = ""
    var price = ""
    var pubdate = ""
    var mediumImage = ""
    var smallImage = ""
    var largeImage = ""
     var checked = false
    func toggleChecked() {
        checked = !checked
    }

}

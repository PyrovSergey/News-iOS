//
//  Article.swift
//  News
//
//  Created by Sergey on 01/04/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class Article: Object {
    @objc dynamic var sourceTitle: String = ""
    @objc dynamic var sourceImageUrl: String = ""
    @objc dynamic var articleTitle: String = ""
    @objc dynamic var articleImageUrl: String = ""
    @objc dynamic var articleUrl: String = ""
    @objc dynamic var articlePublicationTime: String = ""
}

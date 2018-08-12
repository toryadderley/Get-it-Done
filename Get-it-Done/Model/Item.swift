//
//  Item.swift
//  Get-it-Done
//
//  Copyright © 2018 Tory Adderley. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // linking item and category 
}

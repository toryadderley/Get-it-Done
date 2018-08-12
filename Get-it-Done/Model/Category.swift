//
//  Category.swift
//  Get-it-Done
//
//  Copyright © 2018 Tory Adderley. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()  // linking item and category 
}

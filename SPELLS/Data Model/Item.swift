//
//  Item.swift
//  SPELLS
//
//  Created by D Spafford on 11/10/2018.
//  Copyright © 2018 D Spafford. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
   @objc dynamic var title: String = ""
    
   @objc dynamic var done: Bool = false
    
    var parentTopic = LinkingObjects(fromType: Topic.self, property: "items")

}

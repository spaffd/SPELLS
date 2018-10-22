//
//  Topic.swift
//  SPELLS
//
//  Created by D Spafford on 11/10/2018.
//  Copyright © 2018 D Spafford. All rights reserved.
//

import Foundation
import RealmSwift

class Topic: Object {

    @objc dynamic var colour: String = ""
    
    @objc dynamic var name: String = ""

let items = List<Item>()

}

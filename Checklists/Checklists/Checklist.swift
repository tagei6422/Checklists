//
//  Checklist.swift
//  Checklists
//
//  Created by 朱宏基 on 2021/1/8.
//

import UIKit

class Checklist: NSObject, Codable {

    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String){
        self.name = name
        super.init()
    }
}

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
    var iconName = "No Icon"
    
    init(name: String, iconName: String = "No Icon"){
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    //统计没有勾选的项目数量
    func countUncheckedItems() -> Int{
        var count = 0
        for item in items where !item.checked{
            count += 1
        }
        return count
    }
}

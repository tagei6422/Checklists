//
//  ChecklistItem.swift
//  Checklists
//
//  Created by 朱宏基 on 2020/12/17.
//

import Foundation

class ChecklistItem: NSObject, Codable{
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
    
}

//
//  DataModel.swift
//  Checklists
//
//  Created by 朱宏基 on 2021/1/13.
//

import Foundation

class DataModel{
    var lists = [Checklist]()
    var indexOfSelectedChecklist: Int{
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set{
            UserDefaults.standard.set(newValue,forKey: "ChecklistIndex")
        }
    }
    
    init(){
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    //MARK:- Data Saving
    //获取Document路径
    func documentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    //获取保存文件URL
    func dataFilePath() -> URL{
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    //保存
    func saveChecklists(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(),options: Data.WritingOptions.atomic)
        }catch{
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    //加载
    func loadChecklists(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            let decoder = PropertyListDecoder()
            do{
                lists = try decoder.decode([Checklist].self, from: data)
                //确保现有的lists也是排好序的
                sortChecklists()
            }catch{
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
    
    //初始化UserDefaults，解决重新安装app导致的UserDefaults初值为0的问题
    func registerDefaults(){
        let dictionary = ["ChecklistIndex": -1, "FirstTime": true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    
    func handleFirstTime(){
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false,forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    //用闭包写排序的代码
    func sortChecklists(){
        lists.sort(by: {list1, list2 in return list1.name.localizedStandardCompare(list2.name) == .orderedAscending })
    }
    
    
    //获取当前的ChecklistItemID，class方法，可以不用具体的对象来调用，直接用类来调用这个方法
    class func nextChecklistItemID() -> Int{
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        //同步到disk
        userDefaults.synchronize()
        return itemID
    }
}

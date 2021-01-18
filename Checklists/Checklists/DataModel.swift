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
            }catch{
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
    
    //初始化UserDefaults，解决重新安装app导致的UserDefaults初值为0的问题
    func registerDefaults(){
        let dictionary = ["ChecklistIndex": -1]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    
}

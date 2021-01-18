//
//  ViewController.swift
//  Checklists
//
//  Created by 朱宏基 on 2020/12/17.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!


    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    
        //取消大标题
        navigationItem.largeTitleDisplayMode = .never
        
        title = checklist.name
        
    }

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)

        let item = checklist.items[indexPath.row]
        
        configureCheckmark(for: cell, with: item)
        configureText(for: cell, with: item)

        return cell
    }

    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
           
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
            
        }
        //恢复不选择该row
        tableView.deselectRow(at: indexPath, animated: true)
        
    
    }

    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked{
            label.text = "√"
        }else{
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    //允许删除
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath){
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
     
    }
    
    
    //MARK: - ItemDetailViewControllerDelegate
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        //修改Model和View的内容，将新增的数据加入到Model，并告知View更新显示
        //获取现有项目个数
        let newRowIndex = checklist.items.count
        //添加到model里面
        checklist.items.append(item)
        
        //创建一个IndexPath，标注为要添加的位置（因为从0开始计数，所以之前的个数即为现在要添加的位置）
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        //创建一个只有indexPath的数组
        let indexPaths = [indexPath]
        //让View显示一个新的行
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        //退出Add Item页面
        navigationController?.popViewController(animated: true)
        
       
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        

    }
    
    
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //若segue为AddItem，则将itemDetailViewController的delegate设置为ChecklistViewController（即self）
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        }else if segue.identifier == "EditItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            //这里设置itemDetailViewController的itemToEdit属性值！！！即要编辑的item
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

    
}

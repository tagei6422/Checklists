//
//  AllListsViewController.swift
//  Checklists
//
//  Created by 朱宏基 on 2021/1/8.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    //需要使用在多个方法中，把cellIdentifier提升到class等级
    let cellIdentifier = "ChecklistCell"
    
    //一个带有Checklist类的array变量，同 var lists = Array<Checklist>()
//    var lists = [Checklist]()
    
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取消注册，手动创建不同类型的cell，具体见tableView(_:cellForRowAt:)方法
        //注册cell
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        //大标题
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count{
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataModel.lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell :UITableViewCell!
        //如果复用池里面有cell，则取出，没有则新建一个cell，样式为subtitle
        if let c = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            cell = c
        }else{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        }else{
            cell.detailTextLabel!.text = count == 0 ? "All Done!" : "\(checklist.countUncheckedItems()) Remaining"
        }
        
        return cell
    }
   
    //当点击cell的时候调用
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //存储选择的行
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        //用代码打开segue，而非storyboard
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)//将checklist传递给segue
    }
    
    //删除操作
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destination as! ChecklistViewController
            //在prepare中将sender传给ChecklistViewController的checklist变量
            controller.checklist = sender as? Checklist
        }else if segue.identifier == "AddChecklist"{
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    //MARK:- List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = dataModel.lists.index(of: checklist){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                cell.textLabel!.text = checklist.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //在代码中获取一个controller，从storyboard获取，需要去对应的storyboard的特定controller设置Storyboard ID，与下面的identifier一致
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK:- Navigation Controller Delegates
    
    //当一个新的页面要被展示的时候调用
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        //如果要展示的是AllListsViewController的页面，则表示没有需要被记住的行，赋值-1
        if viewController === self{//===表示是否指向同个对象，==表示值是否相等
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    
    

}

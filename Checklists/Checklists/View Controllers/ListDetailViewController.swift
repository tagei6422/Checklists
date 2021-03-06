//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by 朱宏基 on 2021/1/8.
//

import Foundation
import UIKit

protocol ListDetailViewControllerDelegate: class{
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishAdding checklist: Checklist)
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate{
    @IBOutlet weak var textFeild: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    var iconName = "Folder"
    
    //修改页面title
    override func viewDidLoad() {
        if let checklist = checklistToEdit{
            title = "Eidt Checklist"
            textFeild.text = checklist.name
            doneBarButton.isEnabled = true
            
            iconName = checklist.iconName
        }
        iconImage.image = UIImage(named: iconName)
    }
    
    //启动键盘为第一响应
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFeild.becomeFirstResponder()
    }
    
    
    //MARK:- Actions
    @IBAction func cancel(){
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        if let checklist = checklistToEdit{
            checklist.name = textFeild.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        }else{
            let checklist = Checklist(name: textFeild.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    
    //MARK:- Table View Delegates
    //让行不可被选中
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        //当为1的时候，点击的是icon的section，要允许点击，从而跳转到选择icon的界面
        return indexPath.section == 1 ? indexPath : nil
    }
    
    
    //MARK:- Text field Delegates
    //修改textfield内容时，done键的改变情况
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    //确保清空时，done键不可按
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    //MARK:- Icon Picker View Controller Delegate
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImage.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon"{
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
}

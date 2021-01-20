//
//  AppDelegate.swift
//  Checklists
//
//  Created by 朱宏基 on 2020/12/17.
//

import UIKit
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let dataModel = DataModel()


    func applicationDidEnterBackground(_ application: UIApplication) {
        saveData()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        saveData()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel
        
        let center = UNUserNotificationCenter.current()
        //Notification authorization 申请获取权限（有声音的提示）
//        center.requestAuthorization(options: [.alert, .sound]){
//            granted, error in
//            if granted {
//                print("We have permission")
//            }else{
//                print("Permission denied")
//            }
//        }
        
        //设置delegate
        center.delegate = self
        
//        //增加通知的内容
//        let content = UNMutableNotificationContent()
//        content.title = "Hello!"
//        content.body = "I am a local notification"
//        content.sound = UNNotificationSound.default
//        //通知的时间
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
//        //内容和时间封装为请求
//        let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)
//        //请求交给center处理
//        center.add(request)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
   
    
    
    //MARK:- Helper Methods
    func saveData(){
        dataModel.saveChecklists()
    }
    
    //MARK:- User Notification Delegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Received local notification \(notification)")
    }


}


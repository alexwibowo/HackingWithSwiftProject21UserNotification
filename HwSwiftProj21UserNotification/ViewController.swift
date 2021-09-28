//
//  ViewController.swift
//  HwSwiftProj21UserNotification
//
//  Created by Alex Wibowo on 28/9/21.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(register))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(schedule))
    }
    
    @objc func register(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.sound, .badge, .alert]) { granted, error in
            if granted {
                print("Granted")
            } else {
                print("Doh")
            }
        }
        
        
    }
    
    @objc func schedule(){
        doSchedule(title:  "Late wake up call",
                   body: "The early bird catches the worm, but the second mouse gets the cheese",
                   interval: 5)
    }
    
    
    func doSchedule(title: String,
                    body: String,
                    interval: TimeInterval){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
       
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "alarm"
        content.userInfo = ["MyData" : "FizzBuzz"]
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
        
        
        let tellMoreAction = UNNotificationAction(identifier: "show", title: "Tell me more..", options: [.foreground])
        let secondActionAction = UNNotificationAction(identifier: "remindLater", title: "Remind later..", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [tellMoreAction, secondActionAction], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
        
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["MyData"] as? String {
            print("Recieved data \(customData)")
            
            switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    print("Default selected")
                case "show":
                    print("Show more info had been selected")
                case "remindLater":
                
                doSchedule(title: "Hey Lazy Head", body: "Wake up you lazy head", interval: 15)
                    print("Remind later selected")
                default:
                    break
            }
            
        }
        
        
        completionHandler()
    }
    
}


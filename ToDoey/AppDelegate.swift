//
//  AppDelegate.swift
//  ToDoey
// 
//  Created by Evgeniy Uskov on 16/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // check if Realm has any errors when being intialized
        do{
            _ = try Realm()
        }catch{
            print("Error initializing Realm \(error)" )
        }
        return true
    }
    
}


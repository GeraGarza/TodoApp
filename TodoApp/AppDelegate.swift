//
//  AppDelegate.swift
//  TodoApp
//
//  Created by Gera Garza on 6/14/18.
//  Copyright © 2018 Gera Garza. All rights reserved.
//

import UIKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //file location
       
        //print(Realm.Configuration.defaultConfiguration.fileURL)

        do{
            _ = try Realm()
            
        }catch{
            print(error)
        }

        
        return true
    }


    
}


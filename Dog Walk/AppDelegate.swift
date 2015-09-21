//
//  AppDelegate.swift
//  Dog Walk
//
//  Created by Pietro Rea on 7/10/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		let navigationController = self.window!.rootViewController as! UINavigationController
		let viewController = navigationController.topViewController as! ViewController
		// 上下文传递
		viewController.managedContext = coreDataStack.context
		return true
	}
	
	// 保存数据，进入后台
	func applicationDidEnterBackground(application: UIApplication) {
		coreDataStack.saveContext()
	}
	
	// 保存数据，推出应用
	func applicationWillTerminate(application: UIApplication) {
		coreDataStack.saveContext()
	}
	
	// MARK: lazy
	lazy var coreDataStack = CoreDataStack()

}


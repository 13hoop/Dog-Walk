//
//  CoreDataStack.swift
//  Dog Walk
//
//  Created by YongRen on 15/9/18.
//  Copyright © 2015年 Razeware. All rights reserved.
//

// built a separate class to encapsulate the CoreData stack, rather than rely on the default starter template
import CoreData

class CoreDataStack {
	// 四大关键类
	let context: NSManagedObjectContext
	let psc: NSPersistentStoreCoordinator
	let model: NSManagedObjectModel
	let store: NSPersistentStore?
	
	// 初始化和配置每个组件
	init() {
		
		//1 加载“磁盘上的被托管对象的模型（.momd文件）”到“托管对象模型（NSManagedObjectModel）”
        // 可以简单的比对理解为从 “.xcdatamodeld［xib］”读取“model...［视图］“
		let bundle = NSBundle.mainBundle()
		let modelURL = bundle.URLForResource("Dog Walk", withExtension: "momd")
		model = NSManagedObjectModel(contentsOfURL: modelURL!)!
		
		//2	使用托管对象模型,创建协调器(NSPersistentStoreCoordinator)
		psc = NSPersistentStoreCoordinator(managedObjectModel: model)
		
		//3 创建上下文(NSManagedObjectContext),关联协调器
		context = NSManagedObjectContext()
		context.persistentStoreCoordinator = psc
		
		//4 创建持久化方式（NSPersistentStore），并不是直观初始化而是借助协调器配置 && 错误处理
		let documentsURL = CoreDataStack.applicationDocumentsDirectory()
		let storeURL = documentsURL.URLByAppendingPathComponent("Dog Walk")
		let options = [NSMigratePersistentStoresAutomaticallyOption: true]
		do {
			store = try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
		} catch let error as NSError {
			print(__FUNCTION__  + "持久化数据出错\(error)")
			abort() // C 库函数 void abort(void) 中止程序执行，直接从调用的地方跳出
		}
	}
	
	// 保存添加到上下文的更改  && 错误处理
	func saveContext() {
		if context.hasChanges {
			do {
				try context.save()
			} catch let error as NSError {
				print("没能保存！\(error)")
				abort()
			}
		}
	}
	
	
	class func applicationDocumentsDirectory() -> NSURL {
		let fileManager = NSFileManager.defaultManager()

		// returns a URL to your application’s documents directory
		// 返回App文件路径的url，指定数据存储的路径，不管你是否要使用CoreData都是必须的
		let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
		return urls[0]
	}
	
}
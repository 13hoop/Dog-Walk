//
//  ViewController.swift
//  Dog Walk
//
//  Created by Pietro Rea on 7/10/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet var tableView: UITableView!
//  var walks:Array<NSDate> = []
	var managedContext: NSManagedObjectContext!
	
	var currentDog: Dog!

  
  override func viewDidLoad() {
    super.viewDidLoad()
		
		// insert Dog entity
		insertDogEntity()
		
		tableView.registerClass(UITableViewCell.self,
      forCellReuseIdentifier: "Cell")
	}
	
	/*
	首先获取所有叫“Fido”的实体，如果得到空数组［］，表示这是第一次使用App
	首次使用，需要用户添加一个dog，命名为“Fido”
	－ 外层do catch 表示获取Fido的处理
	－ 里面do catch 是用户添加Fido的处理
	*/
	
	func insertDogEntity() {
		
		let dogEntity = NSEntityDescription.entityForName("Dog", inManagedObjectContext: managedContext)
		let dogName = "Fido"
		let dogFetch = NSFetchRequest(entityName: "Dog")
		// 设置查找“Fido”请求
		dogFetch.predicate = NSPredicate(format: "name == %@", dogName)
		
		do {
			// 执行查找请求
			let results = try managedContext.executeFetchRequest(dogFetch) as! [Dog]
			let dogs = results
			
			if dogs.count == 0 {
				print("-------")
				currentDog = Dog(entity: dogEntity!, insertIntoManagedObjectContext: managedContext)
				currentDog.name = dogName
				do{
					try managedContext.save()
				}catch let error as NSError {
					print("不能保存 \(error)")
				}
			}else {
				currentDog = dogs[0] as Dog!
				print("成功获取到Fido: \(currentDog)")
			}
			
		}catch let error as NSError {
			print("未能获取数据 \(error)")
		}
	}

	/*
		增加溜狗
	*/
	@IBAction func add(sender: AnyObject) {
		
		// 添加Walk到CoreData
		let walkEntity = NSEntityDescription.entityForName("Walk", inManagedObjectContext: managedContext)
		let walk = Walk(entity: walkEntity!, insertIntoManagedObjectContext: managedContext)
		walk.date = NSDate()
		
		// 添加walk到Dog的walk集合
		let walks = currentDog.walks?.mutableCopy() as! NSMutableOrderedSet
		walks.addObject(walk)
		currentDog.walks = walks.copy() as? NSOrderedSet
		
		// 保存上下文
		do {
			try managedContext.save()
			print("ok")
		} catch let error as NSError {
			print("添加walk失败\(error)")
		}
		
		// 刷新UI
		tableView.reloadData()
	}
	
	// MARK: -- UITableViewDataSource --
	func tableView(tableView: UITableView,
		numberOfRowsInSection section: Int) -> Int {
//			return walks.count;
			return (currentDog.walks?.count)!
	}
	
	func tableView(tableView: UITableView,
		titleForHeaderInSection section: Int) -> String? {
			return "List of Walks";
	}
	
	func tableView(tableView: UITableView,
		cellForRowAtIndexPath
		indexPath: NSIndexPath) -> UITableViewCell {
			
			let cell =
			tableView.dequeueReusableCellWithIdentifier("Cell",
				forIndexPath: indexPath)
			
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateStyle = .ShortStyle
			dateFormatter.timeStyle = .MediumStyle
			
//			let date =  walks[indexPath.row]
//			cell.textLabel!.text = dateFormatter.stringFromDate(date)
			let walk = currentDog.walks![indexPath.row]
			cell.textLabel?.text = dateFormatter.stringFromDate(walk.date!!)
			print(walk)
			
			return cell
	}
}






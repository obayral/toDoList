//
//  ViewController.swift
//  ToDoList
//
//  Created by Oguz Bayral on 5.12.2018.
//  Copyright © 2018 CentennialCollege. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var itemName: [ NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Title")
        
        do{
            itemName = try context.fetch(fetchRequest)
        }
        catch{
            print("Error in retrieving data!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var titleTextField: UITextField!
    
    
    func titleTextField(textField: UITextField!){
        titleTextField = textField
        titleTextField.placeholder = "Item Name"
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Your Item", message: "Add Your Item Name Below", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Save", style: .default, handler: self.save)
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: titleTextField)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(itemName[indexPath.row])
            itemName.remove(at: indexPath.row)
        
            do{
              try context.save()
            }
            catch{
                print("Error in deleting")
            }
            self.tableView.reloadData()
        }
    }

    func save(alert:UIAlertAction!){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Title", in: context)!
        let theTitle = NSManagedObject.init(entity: entity, insertInto: context)
        theTitle.setValue(titleTextField.text, forKey: "title")
        
        do{
            try context.save()
            itemName.append(theTitle)
        }
        catch{
            print("Error in saving")
        }
        self.tableView.reloadData()
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = itemName[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = title.value(forKey: "title") as? String
        return cell
    }



}


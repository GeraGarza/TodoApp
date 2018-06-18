//
//  ViewController.swift
//  TodoApp
//
//  Created by Gera Garza on 6/14/18.
//  Copyright © 2018 Gera Garza. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
   // let defaults = UserDefaults.standard
    //store keyvalue pairs through app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        print(dataFilePath)
        

        loadItems()

//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
        
       //  Do any additional setup after loading the view, typically from a nib.
    }

    
    //MARK - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" , for: indexPath)
      
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        //ternary
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    
        
    }
    
    
    // MARK - TableView Delegate Methods
    //fired when we click on any cell
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print (itemArray[indexPath.row])
        //grabbing reference to the cell at a perticular path
       
      
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
  
        
        
    }
    
    
    
    @IBAction func addButtonPresse(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks add item button on alert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("now")//it only triggeres when addtextfield starts
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
        
   
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error encoding item array , \(error)")
        }
        
        self.tableView.reloadData()
        
        
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item arrat, \(error)")
            }
        
        }
        
    }
    
}


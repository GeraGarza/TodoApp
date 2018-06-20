//
//  ViewController.swift
//  TodoApp
//
//  Created by Gera Garza on 6/14/18.
//  Copyright © 2018 Gera Garza. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   // let defaults = UserDefaults.standard
    //store keyvalue pairs through app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        

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
       
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
  
        
        
    }
    
    
    
    @IBAction func addButtonPresse(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks add item button on alert
           
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
        
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate?  = nil){

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
  
        do{
        itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
        
    }
    
    

    
    
    
}
//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
       request.predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                //no longer editing
                searchBar.resignFirstResponder()
            }
            

        }
        
        
    }
    
}

//
//  ViewController.swift
//  TodoApp
//
//  Created by Gera Garza on 6/14/18.
//  Copyright © 2018 Gera Garza. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    

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
        
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" , for: indexPath)
      
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            //ternary
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            
        cell.textLabel?.text = "No Items Added"
        }

        
        
        return cell
    
        
    }
    
    
    // MARK - TableView Delegate Methods
    //fired when we click on any cell
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print (itemArray[indexPath.row])
        //grabbing reference to the cell at a perticular path
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write{
              
                    item.done = !item.done
            }
            }catch{
                print ("error saving \(error)")
            }
        }
        
        tableView.reloadData()
  
        tableView.deselectRow(at: indexPath, animated: true)
  
        
        
    }
    
    
    
    @IBAction func addButtonPresse(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks add item button on alert
           
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//
            if let currentCategory = self.selectedCategory{
                do{
                try self.realm.write{
                    let newItem = Item()
                   newItem.dateCreated = Date()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                    }}
                catch{
                    print(error)
                }
            }
            //calls didselectRow
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
           // print("now")//it only triggeres when addtextfield starts
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
        
   
    }
    


func loadItems(){

    //selectedCategoty.items, sorted by title, listend in alphabetical
    todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    

        tableView.reloadData()

    }

    

    
    
    
}
//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
   
        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()

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

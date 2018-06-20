//
//  CategoryTableViewController.swift
//  TodoApp
//
//  Created by Gera Garza on 6/19/18.
//  Copyright © 2018 Gera Garza. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    
    
    //set up an array of items, taped into context, set up tableview to load from context, ibAction, to add new items, then save items to persist items inside container, then load through context
    
    
    
    var categoryArray = [Category]()
    
    //CRUD
    //grab ref to context we will use, its going to communicate with container
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        //print(dataFilePath)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        // Configure the cell...
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    @IBAction func AddButtonClicked(_ sender: UIBarButtonItem) {
        
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
           // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newCategory = Category(context: self.context)
            
            newCategory.name = textFeild.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create Category"
            textFeild = alertTextField
        }
        
        

        present(alert, animated :true)
        
    }
 

     //MARK: - Load Categories
    
    func loadCategory(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)}
        catch{
            print(error)
        }
        tableView.reloadData()

    }
    
    
    

    


    
    
    //MARK: - Data Manipulation Methods
   
    func saveCategory(){
        
        
        do{
            try context.save()
            
        }catch{
            
            print("Error saving context \(error)")
        }
        
        
        tableView.reloadData()
    }
    
    
    
    
    //MARK: - Add New Categories
    
    

    
    // what should happen when we click one of the cells
    //MARK: -  TaleView Delegate Methods
    
    
    
    
    
}

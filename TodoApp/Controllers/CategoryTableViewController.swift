//
//  CategoryTableViewController.swift
//  TodoApp
//
//  Created by Gera Garza on 6/19/18.
//  Copyright © 2018 Gera Garza. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    
    //coreData
    //set up an array of items, taped into context, set up tableview to load from context, ibAction, to add new items, then save items to persist items inside container, then load through context
    
    
    ///initalize new access point
    let realm = try! Realm()
    
    //change category from array to new collection type (collection of results)
    var categories: Results<Category>?
    
    //CRUD
    //grab ref to context we will use, its going to communicate with container

    
    override func viewDidLoad() {
        super.viewDidLoad()

       // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        //print(dataFilePath)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //load categories
        
        loadCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //nil coalescing operator, if nill then 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        // Configure the cell...
       
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        
        return cell
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // tableView.deselectRow(at: indexPath, animated: true)
       //if clicked cell, go to todolistviewcontroller
        performSegue(withIdentifier: "goToItems", sender: self)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //before we leave, we create a new instance of destiation
        //set destinationVC selectedCategory to be the category clicked
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    @IBAction func AddButtonClicked(_ sender: UIBarButtonItem) {
        
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //create a new category that is a new category object
            //give name based on user input
            let newCategory = Category()
            newCategory.name = textFeild.text!

            //save
            self.save(category: newCategory)
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
        
        //set properties category to look inside realm, to fetch all
        //obj that belong to cat
        categories = realm.objects(Category.self)

        //reload tv with new data
        //calls numOfRows,CellForRowAt
         tableView.reloadData()

    }
    
    
    

    


    
    
    //MARK: - Data Manipulation Methods
   //pass in category we created
    func save(category: Category){
        
        
        do{
            //commit changes to realm
            //add category to database
            try realm.write{
                realm.add(category)
            }
        }catch{
            
            print("Error saving context \(error)")
        }
        
        
        tableView.reloadData()
    }
    
    
    
    
    //MARK: - Add New Categories
    
    

    
    // what should happen when we click one of the cells
    //MARK: -  TaleView Delegate Methods
    
    
    
    
    
}

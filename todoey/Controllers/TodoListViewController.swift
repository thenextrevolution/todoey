//
//  ViewController.swift
//  todoey
//
//  Created by C on 10/1/18.
//  Copyright © 2018 C. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
  
        
//        print(dataFilePath)
        
     
        
//        loadItems()
        
//        if let items =  defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
//
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
//MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //ternery operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell


    }

    //Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
//
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        itemArray.remove(at: indexPath.row)
//        context.delete(itemArray[indexPath.row])
        saveItems()
        
      
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//   Mark Add New Itmes
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
//            action once user adds an item
//          let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
//            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
           
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated:  true, completion : nil)
    
    
    
    }
    
 //Mark model manupulation methods
    func saveItems(){
        do{
            
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else{
            request.predicate = categoryPredicate
        }
        

        do{
        itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data \(error)")
        }
    tableView.reloadData()
    }
    
    
    }



//MARK - Search bar Methods
extension TodoListViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
         let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
      
////
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)


    }


//extension TodoListViewController: UISearchBarDelegate{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print ("error fetching data from context \(error)")
//
//
//    }
//        tableView.reloadData()
//    }
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0{
                loadItems()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                    self.tableView.reloadData()
                    }
                }

            //    func searchBar end
            }

    
//extension end
}

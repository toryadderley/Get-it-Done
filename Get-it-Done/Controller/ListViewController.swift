//
//  ViewController.swift
//  Get-it-Done
//  Copyright © 2018 Tory Adderley. All rights reserved.
//

/*
 diiferent ui elements: navigation controller, ui table view, buttons
 persist data on phone
 features:
 not allowing the user to submit an empty text field
 Using NScoder and plist to hold itemsm
 */


import UIKit
import RealmSwift

class ListViewController: SwipeCellsTableViewController { //inheritance
    
    var todoItems: Results<Item>? // Array of Custom Item Objects
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    //Only use UserDefaults for simple stuff, volume on, volume off,
    //UserDefaults only take simple data not custom data like a custom class
    
    //to navigate up the directory, use command and up to eventually get to the directory

    override func viewDidLoad() {
        super.viewDidLoad()
        super.tableView.reloadData()


    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if  let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title // returns the title of an item obj
            
            //Tenary Operator
            //Sets the done property of the item obj depending of the value of done property
            //if a item obj in a row .done is true then the ceel accessory = checkmark/
            //if false it will be .none
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = " No Items added "
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do {try realm.write {
                item.done = !item.done
                }
            }catch {
                print("Error saving done attribute")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item to List", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default){(alertAction) in
            
            if let curCategory = self.selectedCategory{
                
                do{
                    try self.realm.write {
                        let newItem = Item() // Item object
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        curCategory.items.append(newItem)
                    }
                    
                }catch{
                    print("Error saving New Items")
                }
            }
           
            self.tableView.reloadData()
        }
        alertAction.isEnabled = false
        alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Create new item"
            
            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: alertTextField, queue: OperationQueue.main, using:
                {_ in
                    let textCount = alertTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count ?? 0
                    let textIsNotEmpty = textCount > 0
                    alertAction.isEnabled = textIsNotEmpty
                    textField = alertTextField
            })
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                realm.delete(item)
                }
            } catch{
                print("Error deleting Item")
            }
        }
    }
    

}

//MARK: - Search Bar Methods

extension ListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true) // render todoItems based on the filter of whats in the search bar
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}


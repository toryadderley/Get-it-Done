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
import SCLAlertView

class ListViewController: SwipeCellsTableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>? // Array of Custom Item Objects
    let realm = try! Realm()
    
    var selectedCategory : Category? { //When you selesct a particular category, the corresponding items will load
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
        Utils.insertGradientIntoTableView(viewController: self, tableView: tableView)
        Utils.navBarClear(viewController: self)
        clearBackgroundColor()
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.backgroundColor =  UIColor.clear
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
    
    //MARK: - Data Manipulation Methods
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{  //returns the specific element in the row
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch{
                print("Error deleting Item")
            }
        }
    }
    
    
    //MARK: - Add New Item Method
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kCircleHeight: 100.0,
            kCircleIconHeight: 60.0,
            kTitleTop: 62.0,
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "Flexed_Biceps_Emoji")
        let textField = alertView.addTextField("Add New Item")
        
        alertView.addButton("Add") {
            if !textField.text!.isEmpty {
                if let curCategory = self.selectedCategory{
                    
                    do{
                        try self.realm.write { //adds item to realm after block of code is completed
                            let newItem = Item() // Item object
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            curCategory.items.append(newItem) //adds new item to list of item objects for the selected category
                        }
                        
                    }catch{
                        print("Error saving New Items")
                    }
                }
                
                self.tableView.reloadData()
            }
        }
        alertView.addButton("Close") {}
        
        alertView.showCustom("Enter New Item", subTitle:"", color: Utils.hexStringToUIColor(hex: "fa709a"), icon: alertViewIcon!, animationStyle: .rightToLeft)
    }

}



//MARK: - Search Bar Methods
extension ListViewController: UISearchBarDelegate{
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true) // render todoItems based on the filter of whats in the search bar
        tableView.reloadData()
    }
    
    private func clearBackgroundColor() {
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
        
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview.isKind(of: UISearchBarBackground) {
                    subview.alpha = 0
                }
            }
        }
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


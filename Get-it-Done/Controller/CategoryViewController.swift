//
//  CategoryViewController.swift
//  Get-it-Done
//
//  Created by Tory Adderley on 8/11/18.
//  Copyright © 2018 Tory Adderley. All rights reserved.
//

import UIKit
import RealmSwift
import TableViewReloadAnimation


class CategoryViewController: SwipeCellsTableViewController {
    
    let realm = try! Realm()
    
    var categoryList: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData(
            with: .spring(duration: 0.45, damping: 0.65, velocity: 1, direction: .rotation(angle: Double.pi / 2),
                          constantDelay: 0))
        loadCategories()

    }
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1 // Nil Coalesing Operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No Categories"
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoitems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinatioVC = segue.destination as! ListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinatioVC.selectedCategory = categoryList?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(category: Category) {
        do {
            try realm.write { realm.add(category) }
        } catch{
            print("Error writing Category")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories()  {
        categoryList = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let categorytoDelete = self.categoryList?[indexPath.row]{
            
            do {
                try self.realm.write { self.realm.delete(categorytoDelete) }
            } catch{
                print("Error deleting the category")
                }
            }
    }
    
    //MARK: - Add New Categories 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Category", style: .default){(alertAction) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveCategories(category: newCategory)
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
}

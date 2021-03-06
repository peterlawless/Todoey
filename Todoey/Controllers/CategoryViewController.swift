//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Peter Lawless on 10/30/18.
//  Copyright © 2018 Peter Lawless. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    //realm.io/docs/swift/latest#error-handling
    // creating a Realm can fail if resources are constrained, but can only happen the first time a Realm instance is created on a given thread
    let realm = try! Realm()
    
    // Results is an auto-updating container, meaning we don't need to refresh or update
    var categories: Results<Category>? // Make optional in case we forget to load data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field // binding reference to variable outside the scope of this closure
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Nil coalescing operator
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // capture the return from the superclass method
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categories?[indexPath.row]
        guard let backgroundColor = UIColor(hexString: category?.color ?? "1D9BF6") else {fatalError()}
        
        cell.textLabel?.text = category?.name ?? "No Categories added yet!"
        
        cell.backgroundColor = backgroundColor
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
        
        return cell
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // trigger segue
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // you could check the identifier of the segue to determine what class to cast the destination as, but currently there is only one segue leaving this view so we don't need to
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK: - Data manipulation methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete data
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
}

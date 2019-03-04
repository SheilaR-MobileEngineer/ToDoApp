//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Sheila Rodríguez on 2/5/19.
//  Copyright © 2019 Sheila Rodríguez. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alerta = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let accion = UIAlertAction(title: "Add", style: .default) { (accion) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.tableView.reloadData()
        }
        
        alerta.addTextField { (alertTextField) in
          
            alertTextField.placeholder = "Add new category"
            
            textField = alertTextField
        }
        
        alerta.addAction(accion)
        
        present(alerta, animated: true, completion: nil)
        
        saveCategories()
        
    }
    
    //MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
         cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
  
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //Triggered just before performing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //asignar variable a el vc QUE NOS VA A LLEVAR
        let destinationVC = segue.destination as! ToDoListViewController
        
        //Use category de la row seleccionada. Como nos pide que indexPathForSelectedRow sea opcional, añadimos if para garantizar que tenga un valor:
        if let indexPath = tableView.indexPathForSelectedRow{
            
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    //MARK: Data Manipulation Methods
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){

        do {
            categories = try context.fetch(request)
        } catch {
            print("Error al cargar \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveCategories(){
        
        do{
            try context.save()
        } catch{
            print("error saving", error)
        }
        
        self.tableView.reloadData()
    }
}

//
//  ViewController.swift
//  ToDoApp
//
//  Created by Sheila Rodríguez on 1/31/19.
//  Copyright © 2019 Sheila Rodríguez. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Eggs", "Destroy Mordor"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemsCell", for: indexPath)
        
        //indexpath es lo que la celda busca rellenar
        //igualamos el indexpath (numerodecolumna) al numero de elemento del array para que el primer elemento se escriba en la primera columna etc.
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - Delegates
    //Que sucedera si se selecciona una cell en el indexpath especificado
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //imprimir el item del array que corresponda al numero de la fila seleccionada
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            
            //Agregar checkmark cuando se selecciona un row
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //al seleccionar, hacer que no continue el color de seleccionado sobre la fila y en lugar de eso, desaparezca
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}


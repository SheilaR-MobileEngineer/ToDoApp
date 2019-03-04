//
//  ViewController.swift
//  ToDoApp
//
//  Created by Sheila Rodríguez on 1/31/19.
//  Copyright © 2019 Sheila Rodríguez. All rights reserved.
//

import UIKit
import CoreData

//Delegados para que todo lo que pase en los elementos que delegan, sea informado a la clase delegada.
class ToDoListViewController: UITableViewController{

    //var itemArray = ["Find Mike", "Buy Eggs", "Destroy Mordor"]
    var itemArray = [Item]()
    
    //Singleton para crear objeto de la clase AppDelegate: shared = current app as and object.
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   
    //items relevantes para esa categoria
    var selectedCategory : Category?{
        
        //Será desencadenado tan pronto como a selectedCategory se le asigne con un valor
        didSet{
            
            loadItems()
        }
    }
    
    //Crear un plist para almacenar la info apartir de la ubicacion de la app
    
    /*let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")*/
    
   //print(dataFilePath)
    /*inicializar variable para almacenar user defaults
    let defaults = UserDefaults.standard*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     
        /*igualar las preferncias de usuario al array que teniamos para mostrar el ultimo elemento guaradado en el array
         if let items = defaults.array(forKey: "ToDoArray") as? [Item] //buscar el array dentro de dafaults que tiene la key: "ToDoArray"
         {
            itemArray = items
         }*/
        
    }

    //MARK: - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemsCell", for: indexPath)
        
        //indexpath es lo que la celda busca rellenar
        //igualamos el indexpath (numerodecolumna) al numero de elemento del array para que el primer elemento se escriba en la primera columna etc.
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }

        return cell
    }
    
    //MARK: - Delegates
    //Que sucedera si se selecciona una cell en el indexpath especificado
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*if itemArray[indexPath.row].done == false{
            
            itemArray[indexPath.row].done = true
        } else{
            itemArray[indexPath.row].done = false
            
        }*/
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        /*imprimir el item del array que corresponda al numero de la fila seleccionada
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            
        //Agregar checkmark cuando se selecciona un row
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }*/
        
        tableView.reloadData()
        
        //al seleccionar, hacer que no continue el color de seleccionado sobre la fila y en lugar de eso, desaparezca
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add nuevos items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //crear alerta para appendearla al array a
        let alert = UIAlertController(title: "Add new ToDo item", message: "", preferredStyle: .alert)
        
        //Crear accion para el alert, boton que se presionará cuando se termine de crear el nuevo item
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            /*Lo que sucedera cuando el usuario presione el boton
            unwrapped porque aunque el textfield este vacio, nunca serà nil
            self.itemArray.append(textField.text!)*/
            
            //let newItem = Item()
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            /*Almacenar nuevo valor en userdafults para no perderlo
            self.defaults.set(self.itemArray, forKey: "ToDoArray")*/
            
            /*let encoder = PropertyListEncoder()
            
            do{
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            } catch{
                 print("Error encoding, \(error)")
            }*/
            
            //reloadData para que se cargue el nuevo item del array y se muestre en el tableView
            self.tableView.reloadData()
        }
        
        //agregar textfield al alert para que el usuario complete
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Item"
            
            //Texto agregado al textfield
            textField = alertTextField
        }
        //Agregar la accion anterior al alert
        alert.addAction(action)
        
        //Show alert
        present(alert, animated: true, completion: nil)
        
        saveItems()
    }
    
    //MARK: - Model manipulation methods
    
    func saveItems(){
        
        /*Para codificar y poder guardar en el plist
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("Error encoding, \(error)")
        }*/
        
        do{
           try context.save()
        } catch{
            print("error saving", error)
        }
        
        self.tableView.reloadData()
    }
    
  
    //with es el parametro externo que recibirá y request el interno dar valor default ( = Item.fetchRequest) en caso de que no pasemos nada a la funcion
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        
        //Item.fetchRequest para: Recuperar/extraer info en forma de objeto "Item". En este caso si se debe especificar el tipo de dato y a la entidad (NSFetchRequest<Item>).
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        //optional binding
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            
            request.predicate = categoryPredicate
        }
  
        
        do{
            //Siempre llamar al context antes de hacer cualquier cosa con el Persistencontainer. Muestra lo que está en el P.C.
            itemArray = try context.fetch(request)
        }catch{
            
            print("Error de fetch \(error)")
        }
        
        //volver a cargar los datos en el tableview con las modificaciones hechas
        tableView.reloadData()
    }
    
    /*func loadItems(){
        
        //Crear variable con los contenidos de la sig url:
        let data = try? Data(contentsOf: dataFilePath!)
        let decoder = PropertyListDecoder()
        
        //decodificar datos en el plist y guaradarlos en el array. Son del tipo [Item] y se rescataran de data (arriba)
        do{
            itemArray = try decoder.decode([Item].self, from: data!)
        } catch {
            
            print(error)
        }
     
    }*/

}

//MARK: SearchBar Methods
extension ToDoListViewController : UISearchBarDelegate{
    
    //Acciones cuando el boton "buscar" ha sido presionado
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        
        //query. title contains searchbar.text (el %@ es solo para asignarle al query el valor del argumento que sigue despues de la coma (searchBar.text))
        //[cd] elimina sensibilidad a case (mayus/mins) y diacritic (acentos)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //ordenar los datos recibidos en orden alfabetico
        //añadir los descriptor establecidos a mi request. nota: .sortDescriptors espera un array:
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //fetch los resultados de acuerdo a las reglas que establecimos arriba
        loadItems(with: request, predicate: predicate)
        
    }
    
    //Cada que el texto cambia en ala searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //cuando el texto cambia (en el metodo) y aparte el conteo == 0:
        if searchBar.text?.count == 0{
            
            //cargar items originales del P.C.
            loadItems()
            
            //Para realizar procesos en el Thread principal incluso cuando las task del background no se hayan completado aùn
            DispatchQueue.main.async {
                //regresa la searchBar a su estado original (sin cursor parpadeando y teclado escondido)
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}

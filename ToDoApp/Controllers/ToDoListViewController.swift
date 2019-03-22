//
//  ViewController.swift
//  ToDoApp
//
//  Created by Sheila Rodríguez on 1/31/19.
//  Copyright © 2019 Sheila Rodríguez. All rights reserved.
//

import UIKit
import RealmSwift

//Delegados para que todo lo que pase en los elementos que delegan, sea informado a la clase delegada.
class ToDoListViewController: UITableViewController{

    //var itemArray = ["Find Mike", "Buy Eggs", "Destroy Mordor"]
    var todoItems : Results<Item>?
    
    var realm = try! Realm()
    
    //Singleton para crear objeto de la clase AppDelegate: shared = current app as and object.
    //var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   
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
            todoItems = items
         }*/
        
    }

    //MARK: - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemsCell", for: indexPath)
        
        //indexpath es lo que la celda busca rellenar
        //igualamos el indexpath (numerodecolumna) al numero de elemento del array para que el primer elemento se escriba en la primera columna etc.
        /*cell.textLabel?.text = todoItems?[indexPath.row].title
        
        if todoItems?[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }*/
        
        if let item = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added yet"
        
        }

        return cell
    }
    
    //MARK: - Delegates
    //Que sucedera si se selecciona una cell en el indexpath especificado
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row]{
            
            do{
                
                //update realmDB
                try realm.write {
                    
                    //cambiar status del item sea cual sea
                    item.done = !item.done
                   
                    /*para eliminar
                    realm.delete(item)*/
                }
                
            }catch{
                
                print("Error al salvar los items \(error)")
            }
        }
        /*if todoItems[indexPath.row].done == false{
            
            todoItems[indexPath.row].done = true
        } else{
            todoItems[indexPath.row].done = false
            
        }*/
        
        //todoItems?[indexPath.row].done = !todoItems[indexPath.row].done
        
        //saveItems()
        /*imprimir el item del array que corresponda al numero de la fila seleccionada
        print(todoItems[indexPath.row])
        
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
        
        let alerta = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        
        let accion = UIAlertAction(title: "Add", style: .default) { (accion) in
            
           
            //self.categories.append(newCategory)
            
            if let currentCategory = self.selectedCategory{
                
                do{
                    try self.realm.write {
                        
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        
                        
                    }
                } catch{
                    print("error saving", error)
                }
                
            }
            
            self.tableView.reloadData()
        }
        
        alerta.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add new item"
            
            textField = alertTextField
        }
        
        alerta.addAction(accion)
        
        present(alerta, animated: true, completion: nil)
        
    }
    
    
    
            
//            self.todoItems.append(newItem)
//
            /*Almacenar nuevo valor en userdafults para no perderlo
            self.defaults.set(self.todoItems, forKey: "ToDoArray")*/
            
            /*let encoder = PropertyListEncoder()
            
            do{
                let data = try encoder.encode(self.todoItems)
                try data.write(to: self.dataFilePath!)
            } catch{
                 print("Error encoding, \(error)")
            }*/
            
            //reloadData para que se cargue el nuevo item del array y se muestre en el tableView
        
        
        //agregar textfield al alert para que el usuario complete
    
        
        
    
    
    //MARK: - Model manipulation methods
    

    
  
    //with es el parametro externo que recibirá y request el interno dar valor default ( = Item.fetchRequest) en caso de que no pasemos nada a la funcion
    func loadItems(){
        
         todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    //
    //        //Item.fetchRequest para: Recuperar/extraer info en forma de objeto "Item". En este caso si se debe especificar el tipo de dato y a la entidad (NSFetchRequest<Item>).
    //
    //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    //
    //
    //        //optional binding
    //        if let additionalPredicate = predicate {
    //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
    //        }else {
    //
    //            request.predicate = categoryPredicate
    //        }
    //
    //
    //        do{
    //            //Siempre llamar al context antes de hacer cualquier cosa con el Persistencontainer. Muestra lo que está en el P.C.
    //            todoItems = try context.fetch(request)
    //        }catch{
    //
    //            print("Error de fetch \(error)")
    //        }
    //
    //        //volver a cargar los datos en el tableview con las modificaciones hechas
            tableView.reloadData()
    //    }
        
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
    
    
}
//MARK: SearchBar Methods
extension ToDoListViewController : UISearchBarDelegate{

    //Acciones cuando el boton "buscar" ha sido presionado
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

        /*let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)

        //query. title contains searchbar.text (el %@ es solo para asignarle al query el valor del argumento que sigue despues de la coma (searchBar.text))
        //[cd] elimina sensibilidad a case (mayus/mins) y diacritic (acentos)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        //ordenar los datos recibidos en orden alfabetico
        //añadir los descriptor establecidos a mi request. nota: .sortDescriptors espera un array:
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        //fetch los resultados de acuerdo a las reglas que establecimos arriba
        loadItems(with: request, predicate: predicate)*/

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


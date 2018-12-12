//
//  ListaProductViewController.swift
//  IOS-Swift-SlideInMenuSW
//
//  Created by Mac Tecsup on 4/12/18.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


class ListaProductViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var TotalPrecio: UITextField!
    
    
    @IBOutlet weak var nproductos: UITextField!
    var ref : DatabaseReference!
    var vptotal = ""
    var ids = ""
    var nombre = ""
    var fecha = ""
var vtodouble: Double = 0.0

    var prec : Double = 0.0
var Array = [String]()
    var cou : Int = 0
    var cou1 : Double = 0.0

    
    
    var productos = [Producto](){
        didSet{
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        ref = Database.database().reference()
        // Hide separators for empty cells
        print("Resultado lista idLIstTbale.... \(ids)")


        
        // tableView.ta5bleFooterView = UIView()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ImageClasificationViewController
        siguienteVC.ids = ids
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.child("usuarios").child(Auth.auth().currentUser!.uid).child("lista").child(ids).child("producto").observe(.value) { snapshot in
            var productos = [Producto]()
            for productoSnapshot in snapshot.children {
                let producto = Producto(snapshot: productoSnapshot as! DataSnapshot)
                productos.append(producto)
            }
          //  print("Resultado arrayLista.... \(productos[nombre]!)")

            self.productos = productos
            
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let price = productos[productos.count].precio
      cou = productos.count
        if productos.count == 0 {
            TotalPrecio.text = "0"
            nproductos.text = "0"
        }
        return productos.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell", for: indexPath) as! ProductTableViewCell
       cell.producto = productos[indexPath.row]
     

    
        //let pt = prec + prec
        //let stri = String(prec)
      //  var i = 0
        var sum :Double = 0.0
        var sumi :Int = 0

        for var k in cou{
           /* Array = [productos[k].categoria]
            Array.append(productos[((k+1)-1)+1].categoria)
            //ordenarrrr*/
            sum = productos[k].totXpro + sum
            print("kkkkk..\(k)")
            print("coukk..\(cou)")


        }

        for var i in cou{
            sumi = productos[i].numprod + sumi
            print("kkkkk..\(i)")
            print("coukk..\(cou)")
            
            
        }

        //print("sumaaa...\(t)")
        TotalPrecio.text = String(sum)
        vptotal = TotalPrecio.text!
        nproductos.text = String(sumi)
        print("ARRAY DE PRECIO ......\(Array)")


        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let idp = productos[indexPath.row]
            
            print("id_Producto..: \(idp.id)")
            self.ref.child("usuarios").child(Auth.auth().currentUser!.uid).child("lista").child(self.ids).child("producto").child(idp.id).removeValue()
            productos.remove(at: indexPath.row)

            }
            // Delete the row from the TableView tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    
  //Button para finalizar la lista
    
    @IBAction func Guardar(_ sender: Any) {
        
        createAlert(title: "Guardar Lista", message: "¿Seguro de guardar la lista, luego no podra modificarlo?" )
     
        // Create the unicorn and record it
    }
    
    func createAlert(title: String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Si", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            print("Si")
            print("precio..\(self.vptotal)")
            self.vtodouble = Double(self.vptotal)!
            self.ref.child("usuarios").child(Auth.auth().currentUser!.uid).child("lista").child(self.ids).child("preciotot").setValue(self.vtodouble)
            self.dismiss(animated: true, completion: nil)

        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            print("No")
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    

    
    
    //FINN...
    
    
}
extension Int: Sequence {
    public func makeIterator() -> CountableRange<Int>.Iterator {
        return (0..<self).makeIterator()
    }
}





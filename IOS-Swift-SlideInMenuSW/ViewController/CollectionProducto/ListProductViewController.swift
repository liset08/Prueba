//
//  ListProductViewController.swift
//  IOS-Swift-SlideInMenuSW
//
//  Created by Mac Tecsup on 11/12/18.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import SBCardPopup

class ListProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {


    @IBOutlet weak var collections: UICollectionView!
    var listaID = ""
    var Array = [String]()
    var cou : Int = 0


    
    var ref : DatabaseReference!
    var productos = [Producto](){
        didSet{
            collections.reloadData()
            
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collections.dataSource = self
        collections.delegate = self
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.child("usuarios").child(Auth.auth().currentUser!.uid).child("lista").child(listaID).child("producto").observe(.value) { snapshot in
            var productos = [Producto]()
            for productoSnapshot in snapshot.children {
                let producto = Producto(snapshot: productoSnapshot as! DataSnapshot)
                productos.append(producto)
            }
            self.productos = productos
        }
    }
}

extension ListProductViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Resultado lista idCollections... \(productos.count)")
        cou = productos.count

        return productos.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collections.dequeueReusableCell(withReuseIdentifier: "CellListProduct", for: indexPath) as! ProductListCellCollectionView
        
        cell.producto = productos[indexPath.row]  //0-1-0 -- 1-0-1-2-
        
   //obtener el array de las categorias de los productos
        Array = [productos[0].categoria]
       // let chicos = Array[1...cou]
      //  print("los chicos de la serie son \(chicos)")
        for k in cou{
          
            var inc : Int = 0
            Array.append(productos[k].categoria)
          
            //codigo para contar los productos
            if k < cou{
            var c = cou - (k+1)
                print("c..\(c)")

           if productos[k].categoria == productos[c].categoria{
            let num = productos[k].numprod
                // inc = 1
            print("n..\(num)")

            }else{
             inc = 0
            print("n..\(inc)")


                }}
            //Fin acabar mañana

            //ordenarrrr
            print("kkkkk..\(k)")
            print("coukk..\(cou)")
        }
   Array.remove(at: 0)

        
        print("RESULTTT..modificable... \(Array)")

    //Fin de la obtencion de categorias

        //ordenarrrr
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chartSegue" {
            let siguienteVC = segue.destination as! BarGraphicViewController
            siguienteVC.Arrays = Array
            print("RESULTTT..IDLIST... \(Array)")
            
            
            
            
        }
    }
    
}


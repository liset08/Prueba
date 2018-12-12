//
//  ListaViewController.swift
//  IOS-Swift-SlideInMenuSW
//
//  Created by Mac Tecsup on 29/11/18.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import SBCardPopup



class ListaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collections: UICollectionView!
    //popup
    
    @IBOutlet weak var centerPopup: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundButton: UIButton!
    
    @IBOutlet weak var popupView: UIView!
    /////
    var idss = ""
    
    var ref : DatabaseReference!
    var listas = [Lista](){
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
    
    @IBAction func showPop2(_ sender: Any) {
        let popup = PopupViewController.create()
        let sbPopup = SBCardPopupViewController(contentViewController: popup)
        sbPopup.show(onViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.child("usuarios").child(Auth.auth().currentUser!.uid).child("lista").observe(.value) { snapshot in
            var listas = [Lista]()
            for listaSnapshot in snapshot.children {
                let lista = Lista(snapshot: listaSnapshot as! DataSnapshot)
                listas.append(lista)
            }
            self.listas = listas
        }
    }
    
    
}
    extension ListaViewController {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Resultado lista idCollections... \(listas.count)")

        return listas.count

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collections.dequeueReusableCell(withReuseIdentifier: "CellLista", for: indexPath) as! ListaCellCollectionViewCell
        
        cell.lista = listas[indexPath.row]

        return cell
        
    }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let lista = listas[indexPath.row]
             idss = lista.idlis
            performSegue(withIdentifier: "versnapsegue", sender: lista)
            
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "versnapsegue" {
                let siguienteVC = segue.destination as! ListProductViewController
                siguienteVC.listaID = idss
                print("RESULTTT..IDLIST... \(idss)")


                
                
            }
        }


}

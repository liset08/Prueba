//
//  PromocionesViewController.swift
//  IOS-Swift-SlideInMenuSW
//
//  Created by Mac Tecsup on 12/12/18.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import SBCardPopup

class PromocionesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collections: UICollectionView!
    var ref : DatabaseReference!
    var promos = [Promociones](){
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
        ref.child("promociones").observe(.value) { snapshot in
            var promos = [Promociones]()
            for listaSnapshot in snapshot.children {
                let promo = Promociones(snapshot: listaSnapshot as! DataSnapshot)
                promos.append(promo)
            }
           self.promos = promos
        }
    }
}


extension PromocionesViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Resultado lista idCollections... \(promos.count)")
        
        return promos.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collections.dequeueReusableCell(withReuseIdentifier: "CellPromo", for: indexPath) as! PromocionesCollectionViewCell
        
        cell.promo = promos[indexPath.row]
        
        return cell
        
    }
    

    }
    
    


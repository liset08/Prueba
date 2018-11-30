//
//  ListaCellCollectionViewCell.swift
//  IOS-Swift-SlideInMenuSW
//
//  Created by Mac Tecsup on 29/11/18.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit

class ListaCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fechaCell: UILabel!
    
    @IBOutlet weak var nombreListCell: UILabel!
    
    var lista: Lista? {
        didSet {
            if let lista = lista {
                fechaCell.text = lista.fecha
                nombreListCell.text = lista.nombre
                
                
            }
        }
    }
    
    override func prepareForReuse() {
       // productImageView.image = #imageLiteral(resourceName: "list_Camera")
        fechaCell.text = "fecha"
        nombreListCell.text = "nombre"
        
    }
}

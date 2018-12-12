//
//  PromocionesCollectionViewCell.swift
//  IOS-Swift-SlideInMenuSW
//
//  Created by Mac Tecsup on 12/12/18.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit

class PromocionesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var titulo: UILabel!
    
    
    @IBOutlet weak var lugar: UILabel!
    
    @IBOutlet weak var descrip: UITextView!
    
    var promo: Promociones? {
        didSet {
            if let promo = promo {
                titulo.text = promo.titulo
                lugar.text = promo.Lugar
                descrip.text = promo.descripcion
                
            }
        }
    }
    override func prepareForReuse() {
        // productImageView.image = #imageLiteral(resourceName: "list_Camera")
        titulo.text = "titulo"
        lugar.text = "Lugar"
        descrip.text = "descripcion"
        
        
    }
}

//
//  Promociones.swift
//  IOS-Swift-SlideInMenuSW
//
//  Created by Mac Tecsup on 12/12/18.
//  Copyright © 2018 Pooya. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Promociones {
    var Lugar : String
    var descripcion : String
    var titulo : String
    
    
    init(Lugar: String, descripcion: String, titulo: String) {
        self.Lugar = Lugar
        self.descripcion = descripcion
        self.titulo = titulo
        
        
    }
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        Lugar = snapshotValue["Lugar"] as! String
        descripcion = snapshotValue["descripcion"] as! String
        titulo = snapshotValue["titulo"] as! String
        
        
        
    }
    // Func converting model for easier writing to database
    func toAnyObject() -> Any {
        return [
            "Lugar": Lugar ,
            "descripcion": descripcion ,
            "titulo": titulo
            
            
            
        ]
    }
    
}

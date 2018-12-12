//
//  ProductListCellCollectionView.swift
//  IOS-Swift-SlideInMenuSW
//
//  Created by Mac Tecsup on 11/12/18.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit
import FirebaseStorage

class ProductListCellCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var Nproductos: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var precio: UILabel!
    var storageRef: StorageReference!
    var storageDownloadTask: StorageDownloadTask!
    
    
    var producto: Producto? {
        didSet {
            if let producto = producto {
                downloadImage(from: producto.imagePath)
                Nproductos.text = String(producto.numprod)
                name.text = producto.nombre
              precio.text = String(producto.totXpro)
                
            }
        }
    }
    
    func downloadImage(from storageImagePath: String) {
        // 1. Get a filePath to save the image at
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "file:\(documentsDirectory)/myimage.jpg"
        // 2. Get the url of that file path
        guard let fileURL = URL(string: filePath) else { return }
        
        // 3. Start download of image and write it to the file url
        storageDownloadTask = storageRef.child(storageImagePath).write(toFile: fileURL, completion: { (url, error) in
            // 4. Check for error
            if let error = error {
                print("Error downloading:\(error)")
                return
                // 5. Get the url path of the image
            } else if let imagePath = url?.path {
                // 6. Update the unicornImageView image
                self.image.image = UIImage(contentsOfFile: imagePath)
            }
        })
        // 7. Finish download of image
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        storageRef = Storage.storage().reference()
    }

    override func prepareForReuse() {
        // productImageView.image = #imageLiteral(resourceName: "list_Camera")
        Nproductos.text = "numprod"
       // name.text = "nombre"
       // precio.text = "totXpro"
        
        
    }
    
    
}

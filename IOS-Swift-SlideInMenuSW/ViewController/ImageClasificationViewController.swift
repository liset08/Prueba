//
//  ImageClasificationViewController.swift
//  IOS-Swift-SlideInMenuSW
//
//  Created by Mac Tecsup on 21/11/18.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit
import CoreML
import FirebaseMLVision
import ImageIO
import Vision
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ImageClasificationViewController: UIViewController {
    
    lazy var vision = Vision.vision()
    var textDetector: VisionTextDetector?
    var ids = ""

    var ide = ""
    //datos de la lista
    var nume : Double = 0.0
    var preciototXpro : Double = 0.0

    var conteofin : Int = 0

    var number = 0

    @IBOutlet weak var namelist: UILabel!
    @IBOutlet weak var fechlist: UILabel!
    
    //
    @IBOutlet weak var precio: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var classificationLabel: UILabel!

    @IBOutlet weak var resultView: UITextView!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    ///Stapped
    
    @IBOutlet weak var conteo: UILabel!
    @IBAction func stepped(_ sender: UIStepper) {
        
        number = Int(sender.value)
        conteo.text = String(number)
        conteofin = Int(conteo.text!)!
        
    }
    
    
    //Stapped
    
  /*  var producto: Producto? {
        didSet {
            if let producto = producto {
                downloadImage(from: producto.imagePath)
                nombre.text = producto.nombre
                categoria.text = producto.categoria
                
                
            }
        }
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup references for database and for storage
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        // Submit button should be disable initially
        addButton.isEnabled = false
        addButton.backgroundColor = .gray
        print("IDLIST_IMAGE.... \(ids)")
        ide = "p"+"\(Int(Date.timeIntervalSinceReferenceDate * 1000))"
        precio.layer.masksToBounds = true
        precio.layer.cornerRadius = 5
        picker.delegate = self
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // If VC is popping, stop showing networking activity indicator and cancel storageUploadTask if any
        if self.isMovingFromParentViewController {
            showNetworkActivityIndicator = false
            storageUploadTask?.cancel()
        }
    }
    
    ////*Imagens con firebase guardad
    
    @IBAction func didTapSubmit(_ sender: Any) {
        let classificationLabel = self.classificationLabel.text ?? ""
        let nombre = self.classificationLabel.text ?? ""
        let fin = self.precio.text
        var cat: String = ""
        self.preciototXpro = Double(fin!)! * Double(self.number)
        print("mirarrrrprecioo: ......***\(self.preciototXpro)")
        
        //Clasificar categoria por el nombre obtenido del reconocimineto
        
        let strdos = classificationLabel
        // Obtener un string de una cadena especificando el numero
        let indexd: String.Index = strdos.index(of: "_")!
        let string = String(strdos[indexd...])
        
        let index: String.Index = string.index(string.startIndex, offsetBy: 1)
        let result: String = string.substring(to: index)
        
        //Condicion para obtener solo los que comincen con la letra "S"
        if result == "_"{
            //Comprara para obtener datos de la cadena de string
            let a = string.substr(1)//"2345"
            cat = a!
            //  let result: String = strdos.substring(to: string)
            
            print("CATEGORIAASSSS: ......***\(cat)")}
        
        ///....
        
        let producto = Producto(nombre: nombre,categoria: cat,imagePath: productoImagePath, precio: nume , id: ide, numprod:conteofin,totXpro: preciototXpro)
    
        // Create the unicorn and record it
      
       
        writeProductToDatabase(producto)
        
        // Return to Unicorns Table VC
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    
    fileprivate let picker = UIImagePickerController()
    fileprivate var productoImagePath = ""
    fileprivate var ref: DatabaseReference!
    fileprivate var storageRef: StorageReference!
    fileprivate var storageUploadTask: StorageUploadTask!
    
    // Setup for activity indicator to be shown when uploading image
    fileprivate var showNetworkActivityIndicator = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = showNetworkActivityIndicator
        }
    }
   
    fileprivate func writeProductToDatabase(_ producto: Producto) {
        // Access the "unicorns" child reference and then access (create) a unique child reference within it and finally set its value
 ref.child("usuarios").child(Auth.auth().currentUser!.uid).child("lista").child(ids).child("producto").child(ide).setValue(producto.toAnyObject())
        
        print("Resultado.... \(ide)")

    }
    
    
    
    fileprivate func uploadSuccess(_ storagePath: String, _ storageImage: UIImage) {
        
        // Update the unicorn image view with the selected image
        imageView.image = storageImage
        // Updated global variable for the storage path for the selected image
        productoImagePath = storagePath
        
        // Enable submit button and change its color
        addButton.isEnabled = true
        addButton.backgroundColor = .green
        addButton.tintColor = .white
        

    }
    
    
    ///Fin de las imagenes de Firebase
    
    
    @IBAction func btnDissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
///
    // MARK: - Image Classification
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            // Initialize Vision Core ML model from base Watson Visual Recognition model
            
            //  Uncomment this line to use the tools model.
            let model = try VNCoreMLModel(for: ComradeApp_1599103352().model)
            //  Uncomment this line to use the plants model.
            // let model = try VNCoreMLModel(for: watson_plants().model)
            
            // Create visual recognition request using Core ML model
            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            }
            request.imageCropAndScaleOption = .scaleFit
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    //....
    
    func updateClassifications(for image: UIImage) {
        classificationLabel.text = "Classifying..."
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    ///..
    
    /// Updates the UI with the results of the classification.
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                self.classificationLabel.text = "Nothing recognized."
            } else {
                // Display top classification ranked by confidence in the UI.
                self.classificationLabel.text = classifications[0].identifier
                print("Resultado.... \(classifications[0].identifier)")
            }
        }
    }
    
    
    ///
    
    @IBAction func cerrar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //...
    
    // MARK: - Photo Actions
    
    @IBAction func takePicture(_ sender: Any) {
   
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
      }
    
    func presentPhotoPicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        
        ///texto eliminar
        
        textDetector = vision.textDetector()

        
        ///
        present(picker, animated: true)
 
    
     }
    
    
    
//...

       }
extension String {
    func substr(_ start:Int, length:Int=0) -> String? {
        guard start > -1 else {
            return nil
        }
        
        let count = self.characters.count - 1
        
        guard start <= count else {
            return nil
        }
        
        let startOffset = max(0, start)
        let endOffset = length > 0 ? min(count, startOffset + length - 1) : count
        
        return String(self[self.index(self.startIndex, offsetBy: startOffset)...self.index(self.startIndex, offsetBy: endOffset)])
    }
}
    extension ImageClasificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        // MARK: - Handling Image Picker Selection
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
            picker.dismiss(animated: true)
            
            // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
           guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imageData = UIImageJPEGRepresentation(image, 0.5) else {
                print("Could not get Image JPEG Representation")
                return
            }
             let imagePath = Auth.auth().app!.options.googleAppID + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            showNetworkActivityIndicator = true
            // 5. Start upload task
            storageUploadTask = storageRef.child(imagePath).putData(imageData, metadata: metadata) { (_, error) in
                // 6. Hide activity indicator because uploading is done with or without an error
                self.showNetworkActivityIndicator = false
                guard error == nil else {
                    print("Error uploading: \(error!)")
                    return
                }
                self.uploadSuccess(imagePath, image)
            }
        imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.image = image
            
            ///text
            
            let visionImage = VisionImage(image: image)
            textDetector?.detect(in: visionImage, completion: { (features, error) in
                guard error == nil, let features = features, !features.isEmpty else {
                    self.resultView.text = "Could not recognize any text"
                    self.dismiss(animated: true, completion: nil)
                    return
                }
             ///Detectar el texto y mostrarlo en un view
                self.resultView.text = "Detected Text Has \(features.count) Blocks:\n\n"

                    for block in features {
                       // print(arr[0].text)
                       // if (block as! String == "60.30"){
                        self.resultView.text = self.resultView.text + "\(block.text)\n\n"
                        
                        
                        let str = block.text
                   // Obtener un string de una cadena especificando el numero
                        let index: String.Index = str.index(str.startIndex, offsetBy: 1)
                        let result: String = str.substring(to: index)

                        //Condicion para obtener solo los que comincen con la letra "S"
                        if result == "S"{
                            //Comprara para obtener datos de la cadena de string
                            let abss = block.text.substr(4)//"2345"

                           let abs = block.text.substr(3)//"2345"
                            let ab2 = block.text.substr(2)//"2345"
                            let ab1 = block.text.substr(1)//"2345"


                                
                            //convertir double
                            print("text cortado: ......***\(abs!)")
                            //print(abs!)
                            let num = Double(abs!)
                            let num2 = Double(ab2!)
                            let num1 = Double(ab1!)
                            let num3 = Double(abss!)


                            //Condicion para el string y asi solo obtener numeros decimales
                            if num != nil {
                                print("text cortado1: ......***\(num!)")
                                self.precio.text = abs

                                self.nume = Double(num!)
                                
                            }else if num2 != nil {
                                print("text cortado2: ......***\(ab2!)")
                                self.precio.text = ab2
                                
                                self.nume = Double(num2!)
                            }else if num1 != nil {
                                print("text cortado3: ......***\(ab1!)")
                                self.precio.text = ab1
                                
                                self.nume = Double(num1!)
                            }else if num3 != nil {
                                print("text cortado4: ......***\(abss!)")
                                self.precio.text = abss
                                
                                self.nume = Double(num3!)
                            }
                 

                        }
                        //let num = Double(block.text)

                      /*  if tnum == "S.\(block.text)"{
                            print(tnum)

                        }*/
                    /*  if num != nil {
                            self.precio.text = block.text
                            self.nume = Double(block.text)!
                       
                        }else{
                            print("NoValido")

                        }*/
                     /*   if block.text == "S.\(num)"{
                            print("hola")
                            self.precio.text = block.text
                        }*/
                }
               
            })
            ///
            updateClassifications(for: image)
        }
        
    }
    
//..

    

    



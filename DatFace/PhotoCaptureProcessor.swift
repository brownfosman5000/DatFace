//
//  PhotoCaptureProcessor.swift
//  DatFace
//
//  Created by Foster Brown on 4/28/18.
//  Copyright © 2018 N. All rights reserved.
//

//Make an instance of class
//Set the base URL

import AVKit
import Alamofire
import algorithmia


//Class to capture image and send to trainer to train
class PhotoCaptureProcessor: NSObject,AVCapturePhotoCaptureDelegate{

    var image: UIImage?
    let client = Algorithmia.client(simpleKey: APIkey)
    let datFaceCollection: String = "data://brownfosman5000/DatFace/"

    
    
    var pictureCounter: Int!
    var baseURL: String!
    var fileManager = FileManager.default
    
    //Array of dictionary images -- ie.. {"url": "data://{0}".format(file.path), "person": label})

    var images = [[:]]
    
    
    override init() {
        super.init()
    }
    
    
    //Get data from other class
    func setBaseURL(URL: String){
        baseURL = URL
    }
    //Get data from other class
    func setCounter(counter: Int){
            pictureCounter = counter
    }

    //Function that is first triggered when we finish snapping photo
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("I took the picture")
        save(with: photo)
    }
    
    //Saves flat binary data of image and converts it to an image and uploads to API
    func save(with photo: AVCapturePhoto) {
        guard let rawData: Data  = photo.fileDataRepresentation() else{
            fatalError("No image present...")
        }
        image = UIImage(data: rawData)
        uploadToAlgorithmia()
    }
    
    
    //Uploads face image to algorithmia
    func uploadToAlgorithmia(){
        let face = client.dir(datFaceCollection)
        face.put(file: createImageURL()) { (file, error) in
            print("Uploaded")
        }
    }
    
    /*
        1) Gets jpeg file
        2) Gets image name
        3) Sets a counter
        4) Sets a path adding jpeg
        5) Creates file
    */
    func createImageURL()->URL{
        //1 for best quality
        let jpegData = UIImageJPEGRepresentation(image!, 1)
        
        let imageName = getImageName()
        //Update Counter
        pictureCounter = pictureCounter!+1
        
        let imagePath = getDirectoryPath().appending("/" + imageName + ".jpeg")
        
        let success = fileManager.createFile(atPath: imagePath, contents: jpegData, attributes: nil)
        
        if success{
            return URL(fileURLWithPath: imagePath)
        }
        else{
            fatalError("File not created successfully")
        }
        
        
    }
    

        
    //Where the images are stored locally
    func getDirectoryPath() -> String {
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    //Gives unique image name baseURL(username.age) + pictureCounter
    func getImageName()->String{
        print(String("\(baseURL!).\(String(describing: pictureCounter!))"))
        return String("\(baseURL!).\(String(describing: pictureCounter!))")
    }
}
    
    
  

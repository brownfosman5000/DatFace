//
//  Trainer.swift
//  DatFace
//
//  Created by Foster Brown on 4/28/18.
//  Copyright © 2018 N. All rights reserved.
//

import AVKit
import algorithmia

class Trainer{
    
    struct Image: Encodable {
        var url: String!
        var person: String
    }
    
    
    let AMOUNTOFIMAGES = 10
    var client:  AlgorithmiaClient!
    var datFaceCollection: String!
    //Number for id person
    var idCounter: Int
    var identification: String?
    
    var jsonData: [String:Any]!
    var images = [[String:Any]]()

    
    init(){
        client = Algorithmia.client(simpleKey: APIkey)
        datFaceCollection = "data://brownfosman5000/DatFace/"
        idCounter = 0

    }
    
    func setID(ID: String){
        identification = ID
//        print(identification!)
    }
    
    
    func getImages(){
        let image_dir = client.dir(datFaceCollection)
        self.jsonData = createJSONFormat()
        
        //Get rid of warning
        _ = image_dir.forEach(file: { (file) in
            
            if let baseName = file?.basename(){
                
                
                if let _imageJSON: Data = self.convertToJSON(fileName: baseName){
                    let imageJSON: Data = _imageJSON
                    
                    print(file?.basename())
                    
                    //Make a dictionary then pass that dictionary to an array and then set the value of the images array to that newly created array
                    let imageDictionary = try! JSONSerialization.jsonObject(with: imageJSON, options: []) as! [String : String]
                    
                    self.images.append(imageDictionary)
                }
                
            }
            else{
                print("Failed to convert to JSON....")
            }
            
            
        }) { (error) in
            print("Error: \(String(describing: error))")
            
            self.trainImages()
        }          

    }
    
    func trainImages(){
        jsonData["images"] = images
//        print(jsonData)
        
        let json = try! JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
        
//        print(JSONSerialization.isValidJSONObject(json))
        if let JSONString = String(data: json, encoding: .utf8) {
            print(JSONString)
        
            let client = Algorithmia.client(simpleKey: APIkey)
            let algo = client.algo(algoUri: "cv/FaceRecognition/0.2.2")
            algo.pipe(rawJson: JSONString) { (resp, error) in
                print(resp.getJson())
            }
        }

    }

    //
    func convertToJSON(fileName: String)->Data?{
        
        //Soon remove the previous classifier
        if fileName.hasPrefix("users_") && fileName.hasSuffix(".state"){
            return nil
        }
        let jsonFormat = Image(url: datFaceCollection + fileName, person: identification!)
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(jsonFormat)
        return jsonData

    }
        
    
    //Creates our template json
    func createJSONFormat()->[String: Any]{
        let jsonObject: [String: Any] = [
            "name_space" : String("users"),
            "data_collection" : String("DatFace"),
            "action" : String("add_images"),
            "images": "nil"
        ]
        return jsonObject
        
    }
}











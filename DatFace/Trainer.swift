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
    
    var client:  AlgorithmiaClient!
    var datFaceCollection: String!
    var photos: [[String:String]] = [[:]]
    var photoInfo: [String:String] = [:]
    init(){
        client = Algorithmia.client(simpleKey: APIkey)
        datFaceCollection = "data://brownfosman5000/DatFace/"
        
        
    }
    func getImages()->[[String:String]]{
        let image_dir = client.dir(datFaceCollection)
        image_dir.forEach(file: { (file) in

            self.photoInfo["url"] = file?.path
            self.photos.append(self.photoInfo)
            
            
        }) { (error) in
            
            print(error)
        }
        print(self.photos)
        predict()
        return self.photos
        
    }
    
    func trainImages()  {
        photos.remove(at: 0)
        let json: [String:Any] = [
            "action" : "add_images",
            "name_space": "datFace",
            "data_collection": "datFace",
            "images": photos
            ]
        
        print(JSONSerialization.isValidJSONObject(json))
        
        client = Algorithmia.client(simpleKey: APIkey)
        let algo = client.algo(algoUri: "cv/FaceRecognition/0.2.2")
        
        algo.pipe(json: json) { (resp, error) in
            print(resp.getJson())
        }
    }
    
    func predict(){
        photos.remove(at: 0)
        let json: [String:Any] = [
            "action" : "predict",
            "name_space": "datFace",
            "data_collection": "datFace",
            "images":
                [
                    "url": "data://brownfosman5000/DatFace/download.png",
                    "output": "data://brownfosman5000/DatFace/h.k.1.jpeg"
            ]
        ]
        
        print(JSONSerialization.isValidJSONObject(json))
        
        client = Algorithmia.client(simpleKey: APIkey)
        let algo = client.algo(algoUri: "cv/FaceRecognition/0.2.2")
        
        algo.pipe(json: json) { (resp, error) in
            print(resp.getJson())
        }
    }

}






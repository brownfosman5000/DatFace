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
    
    var photoInfo: [String:String] = [:]
    init(){
        client = Algorithmia.client(simpleKey: APIkey)
        datFaceCollection = "data://brownfosman5000/DatFace/"
        
        
    }
    func getImages(){
        let image_dir = client.dir(datFaceCollection)
        print("ImageDIR: \(image_dir)")

        image_dir.forEach(file: { (algoFile) in
            algoFile.
        }) { (error) in
            print(error)
        }
    
    //Create dictionary Format
    func configureDictionaryFormat(with url: String)-> [String:String]{
        return [
            String("url") : String("\(datFaceCollection)/\(url).jpeg"),
            String("person") : String(url)
        ]
    }

}

}


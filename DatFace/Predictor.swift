//
//  Predictor.swift
//  DatFace
//
//  Created by Foster Brown on 5/4/18.
//  Copyright © 2018 N. All rights reserved.
//

import Foundation
import algorithmia


class Predictor{
//    var predictionImageURL: String
    
    init(image: String ) {
//        predictionImageURL = image
    }
    
    
    
    func createJSONFormat()->[String: Any]{
        let jsonObject: [String: Any] = [
            "name_space" : String("users"),
            "action" : String("predict"),
            "data_collection" : "DatFace",
            "images": [ ["url": "data://brownfosman5000/Frames/IMG_476copy.jpg"]]
        ]
        return jsonObject
        
    }
    
    func predict(){
        let jsonData = createJSONFormat()
        var json = try! JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
        if let JSONString = String(data: json, encoding: .utf8) {
            print(JSONString)
            
            let client = Algorithmia.client(simpleKey: APIkey)
            let algo = client.algo(algoUri: "cv/FaceRecognition/0.2.2")
            algo.pipe(rawJson: JSONString) { (resp, error) in
                print(resp.getJson())
                print(resp.error)
            }
        }
    }

}

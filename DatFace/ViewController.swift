//
//  ViewController.swift
//  DatFace
//
//  Created by Foster Brown on 4/27/18.
//  Copyright © 2018 N. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Vision
import PKHUD


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate{
    
    
//    private var scanTimer: Timer? // how often to scan for faces
    var scannedFaceViews = [UIView]() // detected faces will be here
    var faces = [CALayer]()
    var previewLayer = CALayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bounds = view.frame
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = bounds
        
        let dataOutput = AVCaptureVideoDataOutput()
        captureSession.addOutput(dataOutput)
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQ"))
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        DispatchQueue.main.async {
            _ = faces.map { $0.removeFromSuperlayer() }
            faces.removeAll()
//        }
    
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        let request = VNDetectRectanglesRequest { (req, err) in
            if let err = err {
                print("Failed to detect faced")
            }
//            print(req.results)
            req.results?.forEach({ (res) in
                guard let faceObservation = res as? VNRectangleObservation else {return}
                DispatchQueue.main.async {
                    let box = CALayer()
                    let cyan = UIColor.cyan.withAlphaComponent(0.4)
                    box.backgroundColor = cyan.cgColor
//                    let height = self.previewLayer.frame.height * faceObservation.boundingBox.height
////                    let y = self.view.frame.width * (1 - faceObservation.boundingBox.origin.y) // height
//                    let y = self.previewLayer.frame.width * faceObservation.boundingBox.origin.y - height // height
//                    let x = self.previewLayer.frame.width * faceObservation.boundingBox.origin.x
//                    let width = self.previewLayer.frame.width * faceObservation.boundingBox.width
                    
                    
                    
//                    let height = self.view.frame.height * faceObservation.boundingBox.height
                    let height = CGFloat(100.0)
//                    let y = self.view.frame.width * (1 - faceObservation.boundingBox.origin.y) - height // height
                    let y = self.view.frame.height * (1 - faceObservation.boundingBox.origin.y) - height  // height
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    

                    box.frame = CGRect(x: x, y: y, width: width, height: height)
                    self.view.layer.insertSublayer(box, above: self.previewLayer)
                    self.faces.append(box)
                }
            })
        }
        let handler =  VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [ : ])
        do {
            try handler.perform([request])
        } catch let err {
            print("Failed to perform FD request", err)
        }
    }// end captureOutput

} // end class


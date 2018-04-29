//
//  CameraPreviewView.swift
//  DatFace
//
//  Created by Foster Brown on 4/28/18.
//  Copyright © 2018 N. All rights reserved.
//

import AVKit
//Class meant to render the photo capture screen to user
class CameraPreviewView: UIView{
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// Convenience wrapper to get layer as its statically known type.
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}

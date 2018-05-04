//
//  CameraViewController.swift
//  DatFace
//
//  Created by Foster Brown on 4/27/18.
//  Copyright © 2018 N. All rights reserved.
//
import AVKit
class CameraViewController: UIViewController{
        
    @IBOutlet weak var takePhotoButton: UIButton!
    
    var basePhotoURL: String?
    var pictureCounter: Int = 0
    var buttonCounter: Int = 0
    var captureSession = AVCaptureSession()
    
    
    
    //PhotoOutput capture
    let photoOutput = AVCapturePhotoOutput()
    //Settings for photo
    
    
    var basePhotoSettings = AVCapturePhotoSettings.init()
    //Processor for our captures
    let captureProcessor = PhotoCaptureProcessor()

    @IBOutlet weak var previewView: CameraPreviewView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Set captureProcessor
        captureProcessor.setBaseURL(URL: basePhotoURL!)
        captureProcessor.setCounter(counter: pictureCounter)
        
        
        captureSession.beginConfiguration()
        setInputDevice()
        setOutput()
        
        //Set base photosettings every photo will inherit from
        basePhotoSettings = setPhotoSettings()

        previewView.cameraPreviewLayer.session = self.captureSession
        captureSession.startRunning()
        
//        captureProcessor.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInputDevice(){
        let frontFaceCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video , position: .front)
        guard
            let cameraInput = try? AVCaptureDeviceInput(device: frontFaceCamera!),
            captureSession.canAddInput(cameraInput)
            else { return }
        captureSession.addInput(cameraInput)
        
    }
    func setOutput(){
        
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
    }
    
    //Setting Photo Settings
    func setPhotoSettings()->AVCapturePhotoSettings{
        
        basePhotoSettings = AVCapturePhotoSettings.init(from: basePhotoSettings)
    
        basePhotoSettings.flashMode = .auto
        basePhotoSettings.isAutoStillImageStabilizationEnabled = photoOutput.isStillImageStabilizationSupported
        
        return basePhotoSettings

    }
    @IBAction func takePhotoButtonClicked(_ sender: Any) {
        takePhotoButton.isEnabled = false
        let photoSettings = AVCapturePhotoSettings.init(from: basePhotoSettings)
        photoOutput.capturePhoto(with: photoSettings, delegate: captureProcessor)
        takePhotoButton.isEnabled = true
        
        buttonCounter = buttonCounter+1
        
        if buttonCounter > 9{
            performSegue(withIdentifier: "goToNext", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newVC = segue.destination as? MeetOthersViewController{
            let destinationVC = newVC
            destinationVC.baseURL = basePhotoURL
        }
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}




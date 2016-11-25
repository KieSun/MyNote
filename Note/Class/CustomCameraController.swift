//
//  CustomCameraController.swift
//  Note
//
//  Created by yck on 2016/11/24.
//  Copyright © 2016年 MyNote. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCameraController: UIViewController {

    let captureSession = AVCaptureSession()
    
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var photoLibrary: UIButton!
    
    var backDevice: AVCaptureDevice?
    var frontDevice: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto

        let devices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInDuoCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified).devices
        
        devices?.forEach {
            if $0.position == .back {
                backDevice = $0
            }else {
                frontDevice = $0
            }
        }
        
        currentDevice = backDevice
        
        do {
            let input = try AVCaptureDeviceInput(device: currentDevice)
            
            photoOutput = AVCapturePhotoOutput()
            
            captureSession.addInput(input)
            captureSession.addOutput(photoOutput)
            
            cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            view.layer.addSublayer(cameraPreviewLayer!)
            cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            cameraPreviewLayer?.frame = view.layer.frame
            
            toFront(view: photoBtn, changeBtn, dismissBtn, photoLibrary)
            captureSession.startRunning()
            
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    private func toFront(view: UIButton...) {
        
        view.forEach { [weak self] in
            
            self?.view.bringSubview(toFront: $0)
            
            
        }
    }
    
    @IBAction func openPhotoLibrary(_ sender: UIButton) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func capture(_ sender: UIButton) {
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 300,
                             kCVPixelBufferHeightKey as String: 300,
                             ]
        settings.previewPhotoFormat = previewFormat
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func changeInput(_ sender: UIButton) {
        
        captureSession.beginConfiguration()
        
        let newDevice = (currentDevice?.position == .back) ? frontDevice : backDevice
        
        captureSession.inputs.forEach { captureSession.removeInput($0 as! AVCaptureDeviceInput) }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: newDevice)
            
            if captureSession.canAddInput(newInput) {
                captureSession.addInput(newInput)
            }
            
            currentDevice = newDevice
            captureSession.commitConfiguration()
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveImage" {
            
            let vc = segue.destination as! SaveImageController
            vc.image = image
        }
    }
}

extension CustomCameraController: AVCapturePhotoCaptureDelegate {
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let photoSampleBuffer = photoSampleBuffer, let previewPhotoSampleBuffer = previewPhotoSampleBuffer {
            
            guard let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                
                return
            }
            
            image = UIImage(data: data)
            self.performSegue(withIdentifier: "saveImage", sender: self)
        }
    }
}

extension CustomCameraController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print(image)
        }else {
            print("error")
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension CustomCameraController: UINavigationControllerDelegate {
    
}

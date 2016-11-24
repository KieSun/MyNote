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
    
    var backDevice: AVCaptureDevice?
    var frontDevice: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
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
            
            toFront(view: photoBtn, changeBtn)
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
    
    @IBAction func capture(_ sender: UIButton) {
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160,
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
            
            let image = UIImage(data: data)
            print(image ?? 0)
        }
    }
}

//
//  FrameExtractor.swift
//  CrowdSense
//
//  Created by Mike Choi on 10/28/17.
//  Copyright © 2017 Mike Choi. All rights reserved.
//


import UIKit
import AVFoundation

protocol FrameExtractorDelegate: class {
  func captured(image: UIImage)
}

class FrameExtractor: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
  
  private let position = AVCaptureDevice.Position.back
  private let quality = AVCaptureSession.Preset.medium
  
  private var permissionGranted = false
  private let sessionQueue = DispatchQueue(label: "session queue")
  private let captureSession = AVCaptureSession()
  private let context = CIContext()
  
  var preview: AVCaptureVideoPreviewLayer!
  
  weak var delegate: FrameExtractorDelegate?
  
  init(on view: UIView) {
    super.init()
    checkPermission()
    sessionQueue.async { [unowned self] in
      self.configureSession()
      self.captureSession.startRunning()
      self.displayPreview(on: view)
    }
  }
  
  // MARK: AVSession configuration
  private func checkPermission() {
    switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
    case .authorized:
      permissionGranted = true
    case .notDetermined:
      requestPermission()
    default:
      permissionGranted = false
    }
  }
  
  private func requestPermission() {
    sessionQueue.suspend()
    AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] granted in
      self.permissionGranted = granted
      self.sessionQueue.resume()
    }
  }
  
  private func configureSession() {
    guard permissionGranted else { return }
    captureSession.sessionPreset = quality
    guard let captureDevice = selectCaptureDevice() else { return }
    guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
    guard captureSession.canAddInput(captureDeviceInput) else { return }
    captureSession.addInput(captureDeviceInput)
    
    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
    guard captureSession.canAddOutput(videoOutput) else { return }
    captureSession.addOutput(videoOutput)
    
    guard let connection = videoOutput.connection(with: AVMediaType.video) else { return }
    guard connection.isVideoOrientationSupported else { return }
    guard connection.isVideoMirroringSupported else { return }
    connection.videoOrientation = .portrait
    connection.isVideoMirrored = position == .back
  }
  
  private func selectCaptureDevice() -> AVCaptureDevice? {
    return AVCaptureDevice.devices().filter { device in
      device.hasMediaType(AVMediaType.video) &&
      device.position == position
    }.first
  }
  
  // MARK: Sample buffer to UIImage conversion
  private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
    let ciImage = CIImage(cvPixelBuffer: imageBuffer)
    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
    return UIImage(cgImage: cgImage)
  }
  
  // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let uiImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
    DispatchQueue.main.async { [unowned self] in
      self.delegate?.captured(image: uiImage)
    }
  }
  
  func displayPreview(on view: UIView) {
    if !(captureSession.isRunning) {
      return
    }
    
    preview = AVCaptureVideoPreviewLayer(session: captureSession)
    preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
    preview.connection?.videoOrientation = .portrait
    
    DispatchQueue.main.async {
      view.layer.insertSublayer(self.preview, at: 0)
      self.preview.frame = view.frame
    }
  }
}

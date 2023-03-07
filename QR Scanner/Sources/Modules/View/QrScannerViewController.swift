//
//  QrScannerViewController.swift
//  QR Scanner
//
//  Created by Артем Галай on 6.03.23.
//

import AVFoundation
import UIKit

final class QrScannerViewController: UIViewController {

    var video = AVCaptureVideoPreviewLayer()
    // Настроим сессию
    let session = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideo()
    }

    func setupVideo() {

        // Настроим устройство
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("Camera is not found") }
        // Настроим input
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        // Настроим output
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)

        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds

        view.layer.addSublayer(video)
        session.startRunning()
    }
}

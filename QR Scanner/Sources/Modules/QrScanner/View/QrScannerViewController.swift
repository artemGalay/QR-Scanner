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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.startRunning()
        }
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

        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds

        view.layer.addSublayer(video)
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.startRunning()
        }
    }
}

extension QrScannerViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }

        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
            if object.type == AVMetadataObject.ObjectType.qr {
                // переход на экран WebView
                guard let stringUrl = object.stringValue else { return }
                print(object.stringValue ?? "")

                let vc = WebViewController()
                navigationController?.pushViewController(vc, animated: true)
                vc.url = stringUrl
                vc.loadRequest()
            }
        session.stopRunning()
        }
    }

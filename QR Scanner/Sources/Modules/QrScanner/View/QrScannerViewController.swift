//
//  QrScannerViewController.swift
//  QR Scanner
//
//  Created by Артем Галай on 6.03.23.
//

import AVFoundation
import UIKit

// MARK: - QrScannerViewProtocol

protocol QrScannerViewProtocol: AnyObject {}

final class QrScannerViewController: UIViewController, QrScannerViewProtocol {

    // MARK: - Properties

    var presenter: QrScannerPresenter?
    private var video = AVCaptureVideoPreviewLayer()
    private let session = AVCaptureSession()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }

    // MARK: - Methods

    private func setupVideo() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("Camera is not found")
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }

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

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QrScannerViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0,
              let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              object.type == AVMetadataObject.ObjectType.qr,
              let stringUrl = object.stringValue else { return }
            print(object.stringValue ?? "")
            presenter?.showWebView(link: stringUrl)
            session.stopRunning()
    }
}

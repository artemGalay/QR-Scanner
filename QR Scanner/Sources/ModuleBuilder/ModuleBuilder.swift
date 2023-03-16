//
//  ModuleBuilder.swift
//  QR Scanner
//
//  Created by Артем Галай on 10.03.23.
//

import UIKit

// MARK: - BuilderProtocol

protocol BuilderProtocol {
    func createQrScannerModule(router: RouterProtocol) -> UIViewController
    func createWebViewModule(link: String, router: RouterProtocol) -> UIViewController
}

final class ModuleBuilder: BuilderProtocol {

    // MARK: - Methods
    
    func createQrScannerModule(router: RouterProtocol) -> UIViewController {
        let view = QrScannerViewController()
        let presenter = QrScannerPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }

    func createWebViewModule(link: String, router: RouterProtocol) -> UIViewController {
        let view = WebViewController()
        let networkManager = NetworkManager()
        let presenter = WebViewPresenter(view: view, router: router, networkManager: networkManager, link: link)
        view.presenter = presenter
        return view
    }
}

//
//  ModuleBuilder.swift
//  QR Scanner
//
//  Created by Артем Галай on 10.03.23.
//

import UIKit

protocol BuilderProtocol {
    func createQrScannerModule(router: RouterProtocol) -> UIViewController
    func createWebViewModule(link: String, router: RouterProtocol) -> UIViewController
}

final class ModuleBuilder: BuilderProtocol {
    func createQrScannerModule(router: RouterProtocol) -> UIViewController {
        let view = QrScannerViewController()
        let presenter = QrScannerPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }

    func createWebViewModule(link: String, router: RouterProtocol) -> UIViewController {
        let view = WebViewController()
        let presenter = WebViewPresenter(view: view, router: router, link: link)
        view.presenter = presenter
        return view
    }
}

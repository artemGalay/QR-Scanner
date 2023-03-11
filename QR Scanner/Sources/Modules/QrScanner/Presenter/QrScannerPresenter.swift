//
//  QrScannerPresenter.swift
//  QR Scanner
//
//  Created by Артем Галай on 10.03.23.
//

import Foundation

protocol QrScannerPresenterProtocol {
    func showWebView(link: String)
}

class QrScannerPresenter: QrScannerPresenterProtocol {

    weak var view: QrScannerViewController?
    private var router: RouterProtocol?

    init(view: QrScannerViewController, router: RouterProtocol) {
        self.view = view
        self.router = router
    }

    func showWebView(link: String) {
        router?.showWebView(link: link)
    }
}

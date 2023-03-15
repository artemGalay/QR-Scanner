//
//  QrScannerPresenter.swift
//  QR Scanner
//
//  Created by Артем Галай on 10.03.23.
//

import Foundation

// MARK: - QrScannerPresenterProtocol

protocol QrScannerPresenterProtocol {
    func showWebView(link: String)
}

final class QrScannerPresenter: QrScannerPresenterProtocol {

    // MARK: - Properties

    weak var view: QrScannerViewProtocol?
    private var router: RouterProtocol?

    //MARK: - Initialization

    init(view: QrScannerViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }

    // MARK: - Methods

    func showWebView(link: String) {
        router?.showWebView(link: link)
    }
}

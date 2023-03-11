//
//  WebViewPresenter.swift
//  QR Scanner
//
//  Created by Артем Галай on 11.03.23.
//

import Foundation

protocol WebViewPresenterProtocol {
    func loadRequest()
    func share()
    func closeWebView()
}

final class WebViewPresenter: WebViewPresenterProtocol {

    weak var view: WebViewProtocol?
    private var router: RouterProtocol?
    private var link: String

    init(view: WebViewController, router: RouterProtocol, link: String) {
        self.view = view
        self.router = router
        self.link = link
    }

    func loadRequest() {
        guard let url = URL(string: link) else { return }
        let urlRequest = URLRequest(url: url)
        view?.loadRequest(request: urlRequest)
    }

    func share() {
        NetworkManager.shared.fetchData(url: link) { [weak self] result in
            switch result {
            case .success(let data):
                self?.view?.configureSaveFiles(data: data)

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func closeWebView() {
        router?.popToRoot()
    }
}

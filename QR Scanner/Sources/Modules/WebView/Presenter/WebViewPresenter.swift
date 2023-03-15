//
//  WebViewPresenter.swift
//  QR Scanner
//
//  Created by Артем Галай on 11.03.23.
//

import Foundation

// MARK: - WebViewPresenterProtocol

protocol WebViewPresenterProtocol {
    func loadRequest()
    func share()
    func closeWebView()
}

final class WebViewPresenter: WebViewPresenterProtocol {

    // MARK: - Properties
    
    weak var view: WebViewProtocol?
    private var router: RouterProtocol?
    private let networkManager: NetworkManagerProtocol?
    private var link: String

    //MARK: - Initialization

    init(view: WebViewProtocol, router: RouterProtocol, networkManager: NetworkManagerProtocol, link: String) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
        self.link = link
    }

    // MARK: - Methods

    func loadRequest() {
        guard let url = URL(string: link) else { return }
        let urlRequest = URLRequest(url: url)
        view?.loadRequest(request: urlRequest)
    }

    func share() {
        networkManager?.fetchData(url: link) { [weak self] result in
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

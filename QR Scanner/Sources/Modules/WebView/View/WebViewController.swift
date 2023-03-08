//
//  WebViewController.swift
//  QR Scanner
//
//  Created by Артем Галай on 8.03.23.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {

    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        loadRequest()
    }

    private func setupHierarchy() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadRequest() {
        guard let url = URL(string: "https://unec.edu.az/application/uploads/2014/12/pdf-sample.pdf") else { return }

        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
    }
}

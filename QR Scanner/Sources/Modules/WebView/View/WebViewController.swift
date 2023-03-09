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
    private let progressView = UIProgressView(progressViewStyle: .default)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        configureUI()
    }

    private func setupHierarchy() {
        view.addSubview(webView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func configureUI() {
//        let progressButton = UIBarButtonItem(customView: progressView)
//        toolbarItems = [progressButton]
//        navigationController?.isToolbarHidden = false
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.titleView = progressView
        progressView.trackTintColor = .white

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
    }

    func loadRequest(link: String) {
        guard let url = URL(string: link) else { return }

        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
    }
}

extension WebViewController: WKNavigationDelegate {

    override func observeValue(forKeyPath keyPath: String?,
                                     of object: Any?,
                                     change: [NSKeyValueChangeKey : Any]?,
                                     context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        progressView.isHidden = false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
}

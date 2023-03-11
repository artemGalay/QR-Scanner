//
//  WebViewController.swift
//  QR Scanner
//
//  Created by Артем Галай on 8.03.23.
//

import UIKit
import WebKit

protocol WebViewProtocol: AnyObject {
    func loadRequest(request: URLRequest)
    func configureSaveFiles(data: Any)
}

final class WebViewController: UIViewController, WebViewProtocol {

    var presenter: WebViewPresenterProtocol?
    private let webView = WKWebView()
    private let progressView = UIProgressView(progressViewStyle: .default)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupHierarchy()
        setupLayout()
        presenter?.loadRequest()
    }

    private func setupHierarchy() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureUI() {
        view.backgroundColor = .white

        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(shareInfo))
        let backButton = UIBarButtonItem(title: "Back",
                                         style: .plain,
                                         target: self,
                                         action: #selector(tappedBackButton))

        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = shareButton
        navigationController?.hidesBarsOnSwipe = true
        
        progressView.trackTintColor = .white
        progressView.translatesAutoresizingMaskIntoConstraints = false

        webView.backgroundColor = .white
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func loadRequest(request: URLRequest) {
        webView.load(request)
    }

    func configureSaveFiles(data: Any) {
        let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityViewController.modalPresentationStyle = .fullScreen

        activityViewController.completionWithItemsHandler = { _, success, _, error in
            if success {
                AlertManager.showAlert(AlertType.successSaved, viewController: self)
            }
            if error != nil {
                AlertManager.showAlert(AlertType.errorSaved, viewController: self)
            }
        }

        DispatchQueue.main.async() {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }

    @objc private func shareInfo() {
        presenter?.share()
    }

    @objc private func tappedBackButton() {
        presenter?.closeWebView()
    }
}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        progressView.isHidden = false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
}

//
//  WebViewController.swift
//  QR Scanner
//
//  Created by Артем Галай on 8.03.23.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {

    var url = String()
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
        webView.backgroundColor = .white
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareInfo))
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(tappedBackButton))

        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = shareButton
        navigationController?.hidesBarsOnSwipe = true
        
        progressView.trackTintColor = .white
        progressView.translatesAutoresizingMaskIntoConstraints = false

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
    }

    func loadRequest() {
        guard let url = URL(string: url) else { return }
        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
    }

    @objc func shareInfo() {

        NetworkManager.shared.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async() {
                    let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                    activityViewController.completionWithItemsHandler = { _, success, _, error in
                        if success {
                            let alert = UIAlertController(title: "Поздравляем!", message: "Ваш файл успешно загружен", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true, completion: nil)
                        }
                        if error != nil {

                        }
                    }
                    self.present(activityViewController, animated: true, completion: nil)
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    @objc func tappedBackButton() {
        navigationController?.popViewController(animated: true)
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

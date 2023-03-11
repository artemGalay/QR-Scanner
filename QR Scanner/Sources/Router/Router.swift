//
//  Router.swift
//  QR Scanner
//
//  Created by Артем Галай on 10.03.23.
//

import UIKit

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: BuilderProtocol? { get set }

    func initialViewController()
    func showWebView(link: String)
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?

    var assemblyBuilder: BuilderProtocol?

    init(navigationController: UINavigationController, assemblyBuilder: BuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createQrScannerModule(router: self) else {
                return
            }
            navigationController.viewControllers = [mainViewController]
        }
    }

    func showWebView(link: String) {
        if let navigationController = navigationController {
            guard let webViewController = assemblyBuilder?.createWebViewModule(link: link, router: self) else {
                return
            }
            navigationController.pushViewController(webViewController, animated: true)
        }
    }

    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}

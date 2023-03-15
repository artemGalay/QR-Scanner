//
//  Router.swift
//  QR Scanner
//
//  Created by Артем Галай on 10.03.23.
//

import UIKit

// MARK: - RouterProtocol

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: BuilderProtocol? { get set }

    func initialViewController()
    func showWebView(link: String)
    func popToRoot()
}

final class Router: RouterProtocol {

    // MARK: - Properties

    var navigationController: UINavigationController?
    var assemblyBuilder: BuilderProtocol?

    //MARK: - Initialization
    
    init(navigationController: UINavigationController, assemblyBuilder: BuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    // MARK: - Methods

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

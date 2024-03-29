//
//  SceneDelegate.swift
//  QR Scanner
//
//  Created by Артем Галай on 6.03.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let navigationViewController = UINavigationController()
        let builder = ModuleBuilder()
        let router = Router(navigationController: navigationViewController, assemblyBuilder: builder)
        router.initialViewController()

        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }
}

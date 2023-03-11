//
//  AlertManager.swift
//  QR Scanner
//
//  Created by Артем Галай on 10.03.23.
//

import UIKit

final class AlertManager {

    static func showAlert(_ type: AlertType, viewController: UIViewController) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: type.actionText, style: .default))
        viewController.present(alert, animated: true, completion: nil)
    }
}

struct AlertType {
    var title: String
    var message: String
    var actionText: String
}

extension AlertType {

    static var successSaved = AlertType(title: "Поздравляем!",
                                       message: "Файл сохранен",
                                       actionText: "ОК")

    static var errorSaved = AlertType(title: "Ошибка!",
                                       message: "Не удалось сохранить файл",
                                       actionText: "Назад")
}

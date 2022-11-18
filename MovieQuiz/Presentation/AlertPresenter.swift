//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Andrei on 13.11.2022.
//

import Foundation
import UIKit


class AlertPresenter {
    
    init(alertModel: AlertModel, viewController: UIViewController) {
        self.alertModel = alertModel
        self.viewController = viewController
    }
    
    let alertModel: AlertModel
    weak var viewController: UIViewController?
    
    func showAlert(quiz result: AlertModel) {
        
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default)  {_ in
            self.alertModel.completion()
    }
        guard let viewController = viewController else { return }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }

}


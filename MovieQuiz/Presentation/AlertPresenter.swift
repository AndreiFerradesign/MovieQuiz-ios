//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Andrei on 13.11.2022.
//


import UIKit


class AlertPresenter {
    
    func showAlert(showController: UIViewController?, model: AlertModel) {
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default)  { _ in
            model.completion()
    }
        guard let viewController = showController else { return }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}


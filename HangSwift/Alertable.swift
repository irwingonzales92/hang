//
//  Alertable.swift
//  Come
//
//  Created by Kenton D. Raiford on 9/17/17.
//  Copyright © 2017 Kenton D. Raiford. All rights reserved.
//

import UIKit

protocol Alertable {}

extension Alertable where Self: UIViewController {
    func showAlert(_ msg: String) {
        let alertController = UIAlertController(title: "Error:", message: msg, preferredStyle: .alert)
        let action =  UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

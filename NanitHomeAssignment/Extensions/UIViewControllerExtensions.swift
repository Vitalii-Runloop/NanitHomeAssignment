//
//  UIViewControllerExtensions.swift
//  NanitHomeAssignment
//
//  Created by Vitalii on 12.06.2022.
//

import UIKit

extension UIViewController {
    
    static func instantiate(withIdentifier storyboardId: String? = nil, from storyboardName: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId ?? String(describing: self))
        return controller
    }
    
    func presentAlert(title: String?, message: String?,
                      style: UIAlertController.Style = .alert, defaultAction: Bool = true,
                      configuration: (_ alertController: UIAlertController) -> () = {_ in}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        if defaultAction {
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        present(alertController, animated: true, completion: nil)
        
        configuration(alertController)
    }
    
}

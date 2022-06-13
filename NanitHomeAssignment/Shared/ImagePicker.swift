//
//  ImagePicker.swift
//  NanitHomeAssignment
//
//  Created by Vitalii on 13.06.2022.
//

import UIKit
import PhotosUI

protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

class ImagePicker: NSObject {
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    private var pickerController: UIImagePickerController?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.presentationController = presentationController
        self.delegate = delegate
    }
    
    func present(from sourceView: UIView) {
        presentationController?.presentAlert(title: "Select picture", message: nil, style: .actionSheet, defaultAction: false) { alertController in
            alertController.popoverPresentationController?.sourceView = sourceView
            
            alertController.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { _ in
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                imagePickerController.mediaTypes = ["public.image"]
                imagePickerController.sourceType = .camera
                self.presentationController?.present(imagePickerController, animated: true, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "Select from library", style: .default, handler: { _ in
                var configuration = PHPickerConfiguration()
                configuration.filter = .images
                let pickerController = PHPickerViewController(configuration: configuration)
                pickerController.delegate = self
                self.presentationController?.present(pickerController, animated: true, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
    }
}

extension ImagePicker: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let item = results.first?.itemProvider,
              item.canLoadObject(ofClass: UIImage.self) else {
            delegate?.didSelect(image: nil)
            return
        }
        
        item.loadObject(ofClass: UIImage.self) { (image, error) in
            if let error = error {
                NSLog("Image picking error: \(error)")
            }
            DispatchQueue.main.async {
                self.delegate?.didSelect(image: image as? UIImage)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        delegate?.didSelect(image: (info[.editedImage] ?? info[.originalImage]) as? UIImage)
    }
    
}

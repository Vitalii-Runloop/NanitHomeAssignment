//
//  InitialViewController.swift
//  NanitHomeAssignment
//
//  Created by Vitalii on 12.06.2022.
//

import UIKit

class InitialViewController: UIViewController {
    @IBOutlet private weak var showBirthdayScreenButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var selectPictureImageView: UIImageView!
    
    private var imagePicker: ImagePicker?
    
    private var user: UserModel? {
        didSet {
            DispatchQueue.global().async {
                AppUserSettings.userModel = self.user
            }
            
            DispatchQueue.main.async {
                self.updateState()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.maximumDate = Date()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global().async {
            self.user = AppUserSettings.userModel
            DispatchQueue.main.async {
                self.updateState()
            }
        }
    }
        
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateUser()
    }
    
    @IBAction func selectPictureButtonAction(_ sender: UIButton) {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        imagePicker?.present(from: sender)
    }
    
    @IBAction func showBirthdayScreenAction(_ sender: Any) {
    }
    
}

extension InitialViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateUser()
        return true
    }
    
}

extension InitialViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if let image = image {
            user?.setPicture(image)
            AppUserSettings.userModel = user
        }
        selectPictureImageView.image = image
        
        imagePicker = nil
    }
    
}

private extension InitialViewController {
    
    func updateUser() {
        guard let name = nameTextField.text, name.count > 0 else {
            user = nil
            return
        }
        
        user = UserModel(name: name, birthday: datePicker.date, picture: selectPictureImageView.image)
    }
    
    func updateState() {
        if let name = user?.name {
            nameTextField.text = name
        }
        if let date = user?.birthdayDate {
            datePicker.date = date
        }
        if let picture = user?.picture {
            selectPictureImageView.image = picture
        }
        showBirthdayScreenButton.isEnabled = user != nil
    }
    
}

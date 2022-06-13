//
//  BirthdayViewController.swift
//  NanitHomeAssignment
//
//  Created by Vitalii on 13.06.2022.
//

import UIKit

class BirthdayViewController: UIViewController {
    enum Theme: CaseIterable {
        case blue
        case green
        case yellow
        
        static var random: Theme {
            return allCases.randomElement() ?? .blue
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .blue:
                return UIColor(red: (CGFloat(218) / 255), green: (CGFloat(241) / 255), blue: (CGFloat(246) / 255), alpha: 1)
            case .green:
                return UIColor(red: (CGFloat(197) / 255), green: (CGFloat(232) / 255), blue: (CGFloat(223) / 255), alpha: 1)
            case .yellow:
                return UIColor(red: (CGFloat(254) / 255), green: (CGFloat(239) / 255), blue: (CGFloat(203) / 255), alpha: 1)
            }
        }
        
        var backgroundImage: UIImage {
            switch self {
            case .blue:
                return UIImage(named: "iOsBgPelican2")!
            case .green:
                return UIImage(named: "iOsBgFox")!
            case .yellow:
                return UIImage(named: "iOsBgElephant")!
            }
        }
        
        var imagePickerIcon: UIImage {
            switch self {
            case .blue:
                return UIImage(named: "cameraIconBlue")!
            case .green:
                return UIImage(named: "cameraIconGreen")!
            case .yellow:
                return UIImage(named: "cameraIconYellow")!
            }
        }
        
        var userPicturePlaceholder: UIImage {
            switch self {
            case .blue:
                return UIImage(named: "defaultPlaceHolderBlue")!
            case .green:
                return UIImage(named: "defaultPlaceHolderGreen")!
            case .yellow:
                return UIImage(named: "defaultPlaceHolderYellow")!
            }
        }
        
        var userPictureBorderColor: UIColor {
            switch self {
            case .blue:
                return UIColor(red: (CGFloat(139) / 255), green: (CGFloat(211) / 255), blue: (CGFloat(228) / 255), alpha: 1)
            case .green:
                return UIColor(red: (CGFloat(111) / 255), green: (CGFloat(197) / 255), blue: (CGFloat(175) / 255), alpha: 1)
            case .yellow:
                return UIColor(red: (CGFloat(254) / 255), green: (CGFloat(190) / 255), blue: (CGFloat(32) / 255), alpha: 1)
            }
        }
    }
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var selectPictureButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    @IBOutlet private weak var userPictureImageView: UIImageView!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var dateImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    private var user: UserModel!
    private var theme: Theme = .random
    
    private var imagePicker: ImagePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateState()
    }
    
    func setUser(_ user: UserModel) {
        self.user = user
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userPictureImageView.layer.cornerRadius = userPictureImageView.frame.width / 2
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectPictureAction(_ sender: UIButton) {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        imagePicker?.present(from: sender)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        defer {
            backButton.alpha = 1
            selectPictureButton.alpha = 1
            shareButton.alpha = 1
        }
        
        backButton.alpha = 0
        selectPictureButton.alpha = 0
        shareButton.alpha = 0
        
        guard let image = view.takeScreenshot() else { return }
        
        shareImage(image, from: sender)
    }
    
}

extension BirthdayViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        user.setPicture(image)
        updateState()
        
        imagePicker = nil
        
        DispatchQueue.global().async {
            AppUserSettings.userModel = self.user
        }
    }
    
}

private extension BirthdayViewController {
    
    func updateState() {
        view.backgroundColor = theme.backgroundColor
        backgroundImageView.image = theme.backgroundImage
        selectPictureButton.setImage(theme.imagePickerIcon, for: .normal)
        userPictureImageView.image = user.picture ?? theme.userPicturePlaceholder
        userPictureImageView.layer.borderColor = theme.userPictureBorderColor.cgColor
        
        titleLabel.text = "Today \(user.name) is".appending((user.age.year ?? 0) > 12 ? " over" : "").uppercased()
        dateLabel.text = { () -> String in
            if let years = user.age.year, years > 0 {
                return years == 1 ? "year" : "years"
            } else {
                let months = user.age.month ?? 0
                return months == 1 ? "month" : "months"
            }
        }().appending(" old!").uppercased()
        
        dateImageView.image = UIImage(named: "ageNumber".appending(String(min(12, {
            if let years = user.age.year, years > 0 {
                return years
            } else {
                return user.age.month ?? 0
            }
        }()))))
    }
    
    func shareImage(_ image: UIImage, from sourceView: UIView) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sourceView
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

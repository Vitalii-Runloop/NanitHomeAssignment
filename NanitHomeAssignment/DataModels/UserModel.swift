//
//  UserModel.swift
//  NanitHomeAssignment
//
//  Created by Vitalii on 13.06.2022.
//

import Foundation
import UIKit

class UserModel: Codable {
    private(set) var name: String
    private(set) var birthdayDate: Date
    private(set) var picture: UIImage?
    
    var age: DateComponents {
        return Date().components([.year, .month, .day], from: birthdayDate)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case birthdayDate
        case picture
    }
    
    func setBirthday(_ date: Date) {
        birthdayDate = date
    }
    
    func setPicture(_ picture: UIImage) {
        self.picture = picture
    }
    
    init(name: String, birthday: Date, picture: UIImage?) {
        self.name = name
        self.birthdayDate = birthday
        self.picture = picture
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        birthdayDate = try container.decode(Date.self, forKey: .birthdayDate)
        picture = (try container.decodeIfPresent(Data.self, forKey: .picture)).map({ UIImage(data: $0) }) ?? nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(birthdayDate, forKey: .birthdayDate)
        try container.encode(picture?.jpegData(compressionQuality: 0.8), forKey: .picture)
    }
}

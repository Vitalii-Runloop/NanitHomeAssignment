//
//  DateExtensions.swift
//  NanitHomeAssignment
//
//  Created by Vitalii on 13.06.2022.
//

import Foundation

extension Date {
    
    func components(_ components: Set<Calendar.Component> = [], from date: Date) -> DateComponents {
        return Calendar.current.dateComponents(components, from: date, to: self)
    }
    
}

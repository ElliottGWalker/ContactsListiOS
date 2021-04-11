//
//  SmarterDateFormatter.swift
//  ContactsList
//
//  Created by Elliott Walker on 09/04/2021.
//

import Foundation
import UIKit



enum SmarterDateFormat: String {
    case laravel = "yyyy-MM-dd HH:mm:ss"
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    case date = "yyyy-MM-dd"
    case ukDate = "dd/MM/yyyy"
    case usDate = "MM-dd-yyyy"
    case yearNumber = "yyyy"
    case monthNumber = "MM"
    case monthShort = "MMM"
    case monthFull = "MMMM"
    case dayNumber = "dd"
    case dayShort = "EEE"
    case dayFull = "EEEE"
    case time = "HH:mm:ss"
    case hourMinute = "HH:mm"
    case hour = "HH"
    case hourInDay = "KK"
    case minutes = "mm"
    case seconds = "ss"
}



class SmarterDateFormatter: DateFormatter {
    
    // MARK: - Initializer
    
    init(_ format: SmarterDateFormat) {
        super.init()
        
        calendar = Calendar.autoupdatingCurrent
        locale = Locale.autoupdatingCurrent
        timeZone = TimeZone.autoupdatingCurrent
        dateFormat = format.rawValue
    }
    
    
    init(rawFormat: String) {
        super.init()
        
        calendar = Calendar.autoupdatingCurrent
        locale = Locale.autoupdatingCurrent
        timeZone = TimeZone.autoupdatingCurrent
        dateFormat = rawFormat
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}


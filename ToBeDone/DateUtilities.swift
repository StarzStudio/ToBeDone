//
//  DateUtilities.swift
//  ToBeDone
//
//  Created by 周星 on 4/19/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation
// utility functions about date

class DateUtilities {
    
    // MARK: constant
    static let customDateFormat = "MM-dd-yyyy HH:mm"
    
    /*
     function operation:  calculate the date from today based on the number of days passed in
     */
    static func stringFromScheduledDate (numOfDatesSinceToday: Int) -> String {
        let secondsSinceToday  = Double(numOfDatesSinceToday * 24 * 60 * 60)
        let scheduledDate = Date.init(timeIntervalSinceNow: secondsSinceToday)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = customDateFormat
        //w = .medium
        //dateformatter.timeStyle = .short
        
        return dateformatter.string(from: scheduledDate)
        
    }
    
    static func dateFrom(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = customDateFormat
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 0)
        //dateFormatter.dateStyle = .medium
        //dateFormatter.timeStyle = .short
        return dateFormatter.date(from: dateString)
    }
    
    //    static func localDateFrom(dateString: String) -> Date? {
    //        let dateFormatter = DateFormatter()
    //        //   dateFormatter.dateFormat = "MM-dd-YYYY HH:mm:ss"
    //        dateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 0)
    //        dateFormatter.dateStyle = .medium
    //        dateFormatter.timeStyle = .short
    //        return dateFormatter.date(from: dateString)
    //    }
    
    
    static func stringFromCurrentDate () -> String {
        
        let currentDate = Date()
        return stringFrom(date:currentDate)
        
    }
    
    static func stringFrom (date: Date) -> String {
        
        let dateformatter = DateFormatter()
        //     dateformatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 0)
        //dateformatter.dateStyle = .medium
        //dateformatter.timeStyle = .short
        dateformatter.dateFormat = customDateFormat
        return dateformatter.string(from: date)
        
    }
    
}

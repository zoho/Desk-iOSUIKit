//
//  DataExtension.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 14/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import Foundation
internal extension Date{
    
    func convert(_ format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
        
    }

    
    func feedDateToString() -> String{
        var format = ""
        if isInSameDay(){
            format = "HH:mm a"
        }
        else if isInSameYear(){
            format = "d MMM"
        }
        else {
            format = "d MMM yy"
        }
        return self.convert(format)
    }
    
    func isInSameWeek() -> Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    func isInSameMonth() -> Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    func isInSameYear() -> Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    func isInSameDay() -> Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .day)
    }
    var isInThisWeek: Bool {
        return isInSameWeek()
    }
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    var isInTheFuture: Bool {
        return Date() < self
    }
    var isInThePast: Bool {
        return self < Date()
    }
    func timeAgoSinceDate(_ currentDate:Date, numericDates:Bool) -> (String,Bool) {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(self)
        let latest = (earliest == now) ? self : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        var dateStr = ""
        
        if (components.year! >= 2) {
            dateStr = "\(components.year!) years"
            
        } else if (components.year! >= 1){
            if (numericDates){
                dateStr = "1 year"
            } else {
                dateStr = "Last year"
            }
        }
        else if (components.month! >= 2) {
            dateStr = "\(components.month!) months"
        } else if (components.month! >= 1){
            if (numericDates){
                dateStr = "1 month"
            } else {
                dateStr = "Last month"
            }
        }
        else if (components.weekOfYear! >= 2) {
            dateStr = "\(components.weekOfYear!) weeks"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                dateStr = "1 week"
            } else {
                dateStr = "Last week"
            }
        }
        else  if (components.day! >= 2) {
            dateStr = "\(components.day!) days"
        } else if (components.day! >= 1){
            if (numericDates){
                dateStr = "1 day"
            } else {
                dateStr = "Yesterday"
            }
        }
        else if (components.hour! >= 2) {
            dateStr = "\(components.hour!) hours"
        } else if (components.hour! >= 1){
            if (numericDates){
                dateStr = "1 hour"
            } else {
                dateStr = "An hour ago"
            }
        }
        else  if (components.minute! >= 2) {
            dateStr = "\(components.minute!) minutes"
        }
        else if (components.minute! >= 1){
            if (numericDates){
                dateStr = "1 minute"
            } else {
                dateStr = "A minute ago"
            }
        }

        dateStr = earliest == now ? dateStr + " " +  "left" :     "late by " + dateStr
        
        return (dateStr,(earliest == now))
    }

    

    func DueDate() -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: Date(), to: self);
        
        let hours = "\(difference.hour ?? 0)h" + " "
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        return ""
    }
    
    func addMinutes(_ minutesToAdd: Int) -> Date {
        let secondsInMinutes: TimeInterval = Double(minutesToAdd) * 60
        let dateWithMinutesAdded: Date = self.addingTimeInterval(secondsInMinutes) as Date
        
        //Return Result
        return dateWithMinutesAdded
    }
    
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
}

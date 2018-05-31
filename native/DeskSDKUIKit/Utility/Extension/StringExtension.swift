//
//  StringExtension.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 14/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import Foundation
internal extension String{
    
    func makeLog(){
        print(self)
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: "ZDEnglish", bundle: ZDUtility.getBundle()!, value: "", comment: "")
    }
    
    func encodeFileName() ->String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
    
    func stringToDate(dateFormat:String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z") -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat =  dateFormat
        guard let date = formatter.date(from: self) else{return Date()}
        let milliSecond = date.timeIntervalSinceNow
        
        let currentTimeZone = TimeZone.current
    
        let timeZoneMilliSecond = TimeInterval(currentTimeZone.secondsFromGMT(for: date)) + milliSecond
        return Date(timeIntervalSinceNow: timeZoneMilliSecond)
        
    }
    
    func extractEmailAddress() -> [String] {
        var results = [String]()
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let nsText = self as NSString
        do {
            let regExp = try NSRegularExpression(pattern: emailRegex, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            let matches = regExp.matches(in: self, options: .reportProgress, range: range)
            
            for match in matches {
                let matchRange = match.range
                results.append(nsText.substring(with: matchRange))
            }
            
        } catch _ {
        }
        
        return results
    }
}

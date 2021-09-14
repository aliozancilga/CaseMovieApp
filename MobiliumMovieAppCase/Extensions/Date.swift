//
//  Date.swift
//  MobiliumMovieAppCase
//
//  Created by Ali Ozan CILGA on 14.09.2021.
//

import Foundation

extension DateFormatter {

    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension Date {

    func toString (dateFormatter: DateFormatter) -> String? {
        return dateFormatter.string(from: self)
    }
}

extension String {

    func toDate (dateFormatter: DateFormatter) -> Date? {
        return dateFormatter.date(from: self)
    }

    func toDateString (dateFormatter: DateFormatter, outputFormat: String) -> String? {
        guard let date = toDate(dateFormatter: dateFormatter) else { return nil }
        return DateFormatter(format: outputFormat).string(from: date)
    }
}

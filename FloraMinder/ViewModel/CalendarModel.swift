//
//  CalendarModel.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/23/23.
//

import Foundation

struct CalendarModel {
    static var shared = CalendarModel()

    // items have to be unique or else errpr
    var datesModified: Set<DateComponents> = []
}

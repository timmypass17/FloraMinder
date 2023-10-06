//
//  CalendarModel.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/23/23.
//

import Foundation

struct CalendarModel {
    static var shared = CalendarModel()
    
    var changedDate: Date?
    var movedDate: Date?
}

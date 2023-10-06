//
//  FloraMinderWidgetBundle.swift
//  FloraMinderWidget
//
//  Created by Timmy Nguyen on 9/30/23.
//

import WidgetKit
import SwiftUI

// Note the usage of the @main attribute on this widget. This attribute indicates that the GameStatusWidget is the entry point for the widget extension, implying that the extension contains a single widget. To support multiple widgets, see the WidgetBundle.
@main
struct FloraMinderWidgetBundle: WidgetBundle {
    var body: some Widget {
        WaterReminderWidget()
    }
}

//
//  SettingsView.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/25/23.
//

import SwiftUI

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}

struct SettingsView: View {
    @AppStorage("notificationIsOn") var notificationsIsOn = false
    @AppStorage("notificationTime") var notificationTime = Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!

    @State var selectedSort: SortPref = .alphabetically
    
    enum SortPref: String, CaseIterable, Identifiable {
        case alphabetically
        case waterDue = "Time Remaining"
        var id: Self { self }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Enable Water Reminders", isOn: $notificationsIsOn)
                    
                    if notificationsIsOn {
                        DatePicker("Notificaiton Time",
                                   selection: $notificationTime, displayedComponents: .hourAndMinute)
                    }
                } header: {
                    Text("Notifcations")
                } footer: {
                    if notificationsIsOn {
                        Text("*Receive a notification at \(notificationTime.formatted(date: .omitted, time: .shortened)) to water plants (if there are any).")
                    }
                }
                
                Section("Help & Support") {
                    Text("Contact Us")
                    Text("Bug Report")
                }
                
                Section("Privacy") {
                    Text("Privacy Policy")
                }
                
                Button("Clear Data", role: .destructive) {
                    
                }
            }
            .navigationTitle("Settings")
            .onChange(of: notificationsIsOn) { newValue in
                Task {
                    if newValue {
                        await Plant.scheduleWaterReminderNotification()
                    } else  {
                        Plant.removeAllWaterReminderNotification()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

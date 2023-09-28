//
//  SettingsView.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/25/23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationIsOn") var notificationsIsOn = false

    @State var notificationTime = DateComponents(hour: 12)  // noon
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
                        NavigationLink {
                            Text("Select Date")
                        } label: {
                            HStack {
                                Text("Notification Time")
                                Spacer()
                                Text(Calendar.current.date(from: notificationTime)?.formatted(date: .omitted, time: .shortened) ?? "Invalid Date")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("Notifcations")
                } footer: {
                    if notificationsIsOn {
                        Text("Receive a notification at \(Calendar.current.date(from: notificationTime)?.formatted(date: .omitted, time: .shortened) ?? "Invalid Date") to water plant.")
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

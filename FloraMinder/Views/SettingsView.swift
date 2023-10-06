//
//  SettingsView.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/25/23.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    @AppStorage("notificationIsOn") var notificationsIsOn = false
    @AppStorage("notificationTime") var notificationTime = Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!

    @StateObject var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Notifications") {
                    Toggle("Enable Water Reminders", isOn: $notificationsIsOn)
                    
                    if notificationsIsOn {
                        DatePicker("Notificaiton Time",
                                   selection: $notificationTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                Section("Help & Support") {
                    Button(action: {
                        settingsViewModel.isShowingContactMailView.toggle()
                    }) {
                        HStack {
                            Text("Contact Us")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $settingsViewModel.isShowingContactMailView) {
                        MailView(result: $settingsViewModel.contactResult, subject: "Contact Us")
                    }
                    
                    Button(action: {
                        settingsViewModel.isShowingBugMailView.toggle()
                    }) {
                        HStack {
                            Text("Bug Report")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $settingsViewModel.isShowingBugMailView) {
                        MailView(result: $settingsViewModel.bugResult, subject: "Bug Report")
                    }
                }
                
                Button("Clear Data", role: .destructive) {
                    settingsViewModel.isPresentingAlert.toggle()
                }
            }
            .navigationTitle("Settings")
            .alert("Delete All Data", isPresented: $settingsViewModel.isPresentingAlert, actions: {
                Button(role: .destructive) {
                    settingsViewModel.clearDataButtonTapped()
                } label: {
                    Text("Delete")
                }
            }, message: {
                Text("This action will permanently delete all of your plant data. This data cannot be recovered. Are you sure you want to proceed?")
            })
            .onChange(of: notificationsIsOn) { newValue in
                Task {
                    await settingsViewModel.notificationToggledValueChanged(newValue)
                }
            }
        }
    }
}

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

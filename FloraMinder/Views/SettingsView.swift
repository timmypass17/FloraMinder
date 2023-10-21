//
//  SettingsView.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/25/23.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    @AppStorage("notificationTime") var notificationTime = Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!

    @StateObject var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        SettingsCellView(text: "Notification Time", imageString: "clock.fill", labelColor: .indigo)
                        Spacer()
                        DatePicker("Notification Time",
                                   selection: $notificationTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Get notified of plants that require watering today (if there are any).")
                }
                
                Section {
                    HStack {
                        SettingsCellView(text: "Water Reminder Widgets", imageString: "drop.fill", labelColor: .blue)
                    }
                } header: {
                    Text("Widgets")
                } footer: {
                    Text("Add widgets to preview daily watering tasks!")
                }
                
                
                Section("Help & Support") {
                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            settingsViewModel.isShowingContactMailView.toggle()
                        } else {
                            settingsViewModel.isPresentingMissingMailAlert.toggle()
                        }
                    }) {
                        HStack {
                            SettingsCellView(text: "Contact Us", imageString: "envelope.fill", labelColor: .green)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .contentShape(Rectangle())  // make spacer clickable
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $settingsViewModel.isShowingContactMailView) {
                        MailView(
                            result: $settingsViewModel.contactResult,
                            subject: "Contact Us",
                            supportEmail: settingsViewModel.supportEmail)
                    }
                    
                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            settingsViewModel.isShowingBugMailView.toggle()
                        } else {
                            settingsViewModel.isPresentingMissingMailAlert.toggle()
                        }
                    }) {
                        HStack {
                            SettingsCellView(text: "Bug Report", imageString: "ladybug.fill", labelColor: .orange)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $settingsViewModel.isShowingBugMailView) {
                        MailView(result: $settingsViewModel.bugResult,
                                 subject: "Bug Report",
                                 supportEmail: settingsViewModel.supportEmail)
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
            .alert("No Email Found", isPresented: $settingsViewModel.isPresentingMissingMailAlert, actions: {

            }, message: {
                Text("There is no email associated with this device. Please email \(settingsViewModel.supportEmail) for any questions.")
            })
            .onChange(of: notificationTime) { newValue in
                Task {
                    await settingsViewModel.notificationTimeValueChanged(newValue)
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

struct SettingsCellView: View {
    var text: String
    var imageString: String
    var labelColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: imageString)
                .foregroundColor(.white)
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(labelColor)
                        .frame(width: 30, height: 30)
                }
                .padding(.trailing, 8)
            
            Text(text)
        }
    }
}

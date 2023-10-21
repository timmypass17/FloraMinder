//
//  SettingsViewModel.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/29/23.
//

import Foundation
import CoreData
import MessageUI

class SettingsViewModel: ObservableObject {
    
    @Published var contactResult: Result<MFMailComposeResult, Error>? = nil
    @Published var bugResult: Result<MFMailComposeResult, Error>? = nil
    @Published var isShowingContactMailView = false
    @Published var isShowingBugMailView = false
    @Published var isPresentingAlert = false
    @Published var isPresentingMissingMailAlert = false
    
    let plantService = PlantService()
    let supportEmail = "floraminder@gmail.com"
    var context = PersistenceController.shared.container.viewContext

    func clearDataButtonTapped() {
        do {
            try plantService.deleteAllPlants()
        } catch {
            print("Error clearing data")
        }
    }
    
    func notificationTimeValueChanged(_ newTime: Date) async {
        await PlantService.scheduleWaterReminderNotification()
    }
}

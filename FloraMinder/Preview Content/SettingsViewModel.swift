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
    
    var context = PersistenceController.shared.container.viewContext

    func clearDataButtonTapped() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Plant")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error clearing data")
        }
    }
    
    func notificationToggledValueChanged(_ notificationIsOn: Bool) async {
        if notificationIsOn {
            await Plant.scheduleWaterReminderNotification()
        } else  {
            Plant.removeAllWaterReminderNotification()
        }
    }
}

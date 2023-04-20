//
//  mvg1App.swift
//  mvg1
//
//  Created by Maruf Siddiqui on 20.04.23.
//

import SwiftUI
import UserNotifications

@main
struct mvg1App: App {
    // 1
    @State var currentNumber: String = "1"
    
    var body: some Scene {
        WindowGroup {
            EmptyView()
                .onAppear {
                    let notificationCenter = UNUserNotificationCenter.current()
                    
                    // Request permission to display notifications
                    notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        if granted {
                            print("Notification permission granted")
                        } else if let error = error {
                            print("Notification permission denied: \(error.localizedDescription)")
                        }
                    }
                    
                    // Make an API call to retrieve data from https://rickandmortyapi.com/api/character/158
                    let url = URL(string: "https://rickandmortyapi.com/api/character/158")!
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data {
                            let decoder = JSONDecoder()
                            if let character = try? decoder.decode(Character.self, from: data) {
                                // Set the notification content
                                let content = UNMutableNotificationContent()
                                content.title = "My Menu App"
                                content.body = "The character \(character.name) is waiting for you!"
                                content.sound = UNNotificationSound.default
                                // Set the notification request
                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                                notificationCenter.add(request) { error in
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                    } else {
                                        print("Notification sent!")
                                    }
                                }
                            }
                        } else if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                    task.resume()
                    
//                    // Show a notification with the message "Hello World"
//                    let content = UNMutableNotificationContent()
//                    content.title = "Hello World"
//                    content.body = "Welcome to my app"
//                    content.sound = UNNotificationSound.default
//                    
//                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//                    
//                    UNUserNotificationCenter.current().add(request) { error in
//                        if let error = error {
//                            print("Failed to add notification: \(error.localizedDescription)")
//                        }
//                    }
                }
        }
        
        MenuBarExtra(currentNumber, systemImage: "\(currentNumber).circle") {
            Button("One") {
                currentNumber = "1"
            }
            .keyboardShortcut("1")
            
            Button("Two") {
                currentNumber = "2"
            }
            .keyboardShortcut("2")
            
            Button("Three") {
                currentNumber = "3"
            }
            .keyboardShortcut("3")
            Divider()
            
            Button("Quit") {
                
                NSApplication.shared.terminate(nil)
                
            }.keyboardShortcut("q")
        }
    }
}

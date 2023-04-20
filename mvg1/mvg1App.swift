import SwiftUI
import UserNotifications

@main
struct mvg1App: App {
    // 1
    @State var currentNumber: String = "1"
    let notificationManager = NotificationManager()
    // Set the date and time to trigger the API call and notification
    let targetDateTime = "2023-04-20T14:30:00+02:00"
    
//    func fetchDepartures(completion: @escaping ([Departure]?) -> Void) {
//        let url = URL(string: "https://www.mvg.de/api/fib/v2/departure?globalId=de:09162:1464&limit=10&offsetInMinutes=0&transportTypes=BUS")!
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                let decoder = JSONDecoder()
//                do {
//                    let departures = try decoder.decode([Departure].self, from: data)
//                    completion(departures)
//                } catch {
//                    print("Error decoding data: \(error.localizedDescription)")
//                    completion(nil)
//                }
//            } else if let error = error {
//                print("Error: \(error.localizedDescription)")
//                completion(nil)
//            }
//        }
//        task.resume()
//    }
    
//    func getMessage(departure: Departure) -> String {
//        let dateString = getFormattedDate(timestamp: departure.realtimeDepartureTime)
//        return "The next bus \(departure.label) is leaving at \(dateString) from \(departure.label)"
//    }
//
//    func getNotificationContent(departure: Departure) -> UNMutableNotificationContent {
//        let content = UNMutableNotificationContent()
//
//        content.title = "Bus Departure"
//        content.body = getMessage(departure: departure)
//        content.sound = UNNotificationSound.default
//
//        return content
//    }
    
//    func createNotification(for departure: Departure) {
//        let content = getNotificationContent(departure: departure)
//        content.sound = UNNotificationSound.default
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//            } else {
//                print("Notification sent!")
//            }
//        }
//    }
//
//    func getFormattedDate(timestamp: Int) -> String {
//        let date = Date(timeIntervalSince1970: TimeInterval(timestamp/1000))
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm:ss"
//        return formatter.string(from: date)
//    }
    
//    func scheduleNotification() {
//        // Get the target date and time
//        guard let targetDate = getFormattedDate(from: targetDateTime) else {
//            print("Invalid target date format")
//            return
//        }
//
//        // Get the current date and time
//        let currentDate = Date()
//
//        // Calculate the time interval between the current date and time and the target date and time
//        let timeInterval = targetDate.timeIntervalSince(currentDate)
//
//        // Schedule the notification
//        let notification = createNotification()
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
//        let request = UNNotificationRequest(identifier: "mvg1Notification", content: notification, trigger: trigger)
//        UNUserNotificationCenter.current().add(request)
//    }
    
//    func requestNotification() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                print("Notification permission granted")
//            } else if let error = error {
//                print("Notification permission denied: \(error.localizedDescription)")
//            }
//        }
//    }
    
    init() {
        notificationManager.requestPermission()
        notificationManager.scheduleNotification()
    }
    
    var body: some Scene {
//        WindowGroup {
//            EmptyView()
//                .onAppear {
//                    requestNotification()
//                    // Schedule the notification
//                    scheduleNotification()
//                }
//        }
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

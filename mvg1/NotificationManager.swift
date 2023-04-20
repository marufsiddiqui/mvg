import Foundation
import UserNotifications


class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    let IDENTIFIER = "API_CALL_NOTIFICATION"
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                print("Notifications permission granted")
            } else {
                print("Notifications permission denied")
            }
        }
    }
    
    func scheduleNotification() {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.hour = 01 // 2 PM
        dateComponents.minute = 11
        dateComponents.second = 00
        let date = calendar.date(from: dateComponents)!
        
        let timer = Timer(fire: date, interval: 86400, repeats: true) { _ in // fire at 2 PM every day
            self.makeAPICall()
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == IDENTIFIER {
            makeAPICall()
        }
        completionHandler()
    }
    
    func makeAPICall() {
        fetchDepartures { departures in
            guard let aidenbachDepartures = departures?.filter({ $0.destination == "Aidenbachstraße" }),
                  let departure = aidenbachDepartures.first
            else { return }
            self.showNotification(withData: departure)
        }
    }
    
    func createNotification(for departure: Departure) {
        let content = getNotificationContent(departure: departure)
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Notification sent!")
            }
        }
    }
    
    func showNotification(withData departure: Departure) {
        let content = getNotificationContent(departure: departure)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "API_RESPONSE_NOTIFICATION", content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error showing notification: \(error)")
            }
        }
    }
    
    func getMessage(departure: Departure) -> String {
        let dateString = getFormattedDate(timestamp: departure.realtimeDepartureTime)
        return "The next bus \(departure.label) is leaving at \(dateString) from \(departure.label)"
    }
    
    func getNotificationContent(departure: Departure) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = "Bus Departure"
        content.body = getMessage(departure: departure)
        content.sound = UNNotificationSound.default
        
        return content
    }
    
    func getFormattedDate(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp/1000))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    func fetchDepartures(completion: @escaping ([Departure]?) -> Void) {
        let url = URL(string: "https://www.mvg.de/api/fib/v2/departure?globalId=de:09162:1464&limit=10&offsetInMinutes=0&transportTypes=BUS")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let departures = try decoder.decode([Departure].self, from: data)
                    completion(departures)
                } catch {
                    print("Error decoding data: \(error.localizedDescription)")
                    completion(nil)
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}

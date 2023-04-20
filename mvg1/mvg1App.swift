import SwiftUI
import UserNotifications


//struct Departure: Decodable {
//    let label: String
//    let realtimeDepartureTime: String
//
//    enum CodingKeys: String, CodingKey {
//        case label = "label"
//        case realtimeDepartureTime = "realtimeDepartureTime"
//    }
//}

struct Departure: Codable {
    //    let bannerHash: String
    //    let cancelled: Int
    //    let delayInMinutes: Int
        let destination: String
    let label: String
    //    let messages: [String]
    //    let network: String
    //    let occupancy: String
    //    let plannedDepartureTime: Int
    //    let realtime: Int
        let realtimeDepartureTime: Int
    //    let sev: Int
    //    let stopPointGlobalId: String
    //    let trainType: String
    //    let transportType: String
}

@main
struct mvg1App: App {
    // 1
    @State var currentNumber: String = "1"
    @State var departures: [Departure] = []
    
    func fetchDepartures(completion: @escaping ([Departure]?) -> Void) {
        guard let url = URL(string: "https://www.mvg.de/api/fib/v2/departure?globalId=de:09162:1464&limit=10&offsetInMinutes=0&transportTypes=BUS") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let departures = try decoder.decode([Departure].self, from: data)
                    completion(departures)
                } catch {
                    completion(nil)
                }
            } else if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
        }
        task.resume()
    }
    
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
                    let url = URL(string: "https://www.mvg.de/api/fib/v2/departure?globalId=de:09162:1464&limit=10&offsetInMinutes=0&transportTypes=BUS")!
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data {
                            let decoder = JSONDecoder()
                            do {
                                let departures = try decoder.decode([Departure].self, from: data)
                                let aidenbachDepartures = departures.filter { $0.destination == "Aidenbachstraße" }

                                
                                if let departure = aidenbachDepartures.first {
                                    // Set the notification content
                                    let content = UNMutableNotificationContent()
                                    let timestamp = departure.realtimeDepartureTime
                                    let date = Date(timeIntervalSince1970: TimeInterval(timestamp/1000))
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "HH:mm:ss"
                                    let dateString = formatter.string(from: date)
                                    content.title = "Bus Departure"
                                    content.body = "The next bus \(departure.label) is leaving at \(dateString) from \(departure.label)"
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
                            } catch {
                                print("Error decoding data: \(error.localizedDescription)")
                            }
                        } else if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                    task.resume()
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

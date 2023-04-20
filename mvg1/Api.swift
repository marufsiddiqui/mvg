import Foundation

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
//
//class Api {
//    static func fetchDepartures() async -> [Departure] {
//        do {
//            let url = URL(string: "https://www.mvg.de/api/fib/v2/departure?globalId=de:09162:1464&limit=10&offsetInMinutes=0&transportTypes=BUS")!
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            let response = try decoder.decode([Departure].self, from: data)
//            return response
//        } catch {
//            print("Error fetching departures: \(error.localizedDescription)")
//            return []
//        }
//    }
//}

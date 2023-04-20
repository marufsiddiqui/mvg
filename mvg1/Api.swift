//
//  Api.swift
//  mvg1
//
//  Created by Maruf Siddiqui on 20.04.23.
//

import Foundation

struct Departure: Decodable {
    let label: String
    let realtimeDepartureTime: String
}

class Api {
    static func fetchDepartures() async -> [Departure] {
        do {
            let url = URL(string: "https://www.mvg.de/api/fib/v2/departure?globalId=de:09162:1464&limit=10&offsetInMinutes=0&transportTypes=BUS")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode([Departure].self, from: data)
            return response
        } catch {
            print("Error fetching departures: \(error.localizedDescription)")
            return []
        }
    }
}

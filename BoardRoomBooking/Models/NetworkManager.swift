import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.airtable.com/v0/appElKqRPusTLsnNe"
    private let apiKey = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"

    private func createRequest(endpoint: String, method: String, body: Data? = nil) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }

    func fetchBoardRooms(completion: @escaping (BoardRoomResponse?) -> Void) {
        guard let request = createRequest(endpoint: "boardrooms", method: "GET") else { return }
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            let boardRooms = try? JSONDecoder().decode(BoardRoomResponse.self, from: data)
            completion(boardRooms)
        }.resume()
    }

    func fetchEmployees(completion: @escaping (EmployeeResponse?) -> Void) {
        guard let request = createRequest(endpoint: "employees", method: "GET") else { return }
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let employees = try? JSONDecoder().decode(EmployeeResponse.self, from: data)
            completion(employees)
        }.resume()
    }

    func fetchBookings(completion: @escaping (BookingResponse?) -> Void) {
        guard let request = createRequest(endpoint: "bookings", method: "GET") else { return }
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let bookings = try? JSONDecoder().decode(BookingResponse.self, from: data)
            completion(bookings)
        }.resume()
    }
}

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.airtable.com/v0/appElKqRPusTLsnNe"
    private let apiKey = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"

    // 🔹 Create API Request Function
    private func createRequest(endpoint: String, method: String, body: Data? = nil) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            print("❌ Invalid URL for endpoint: \(endpoint)") // DEBUG
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }

    // 🔹 Fetch BoardRooms
    func fetchBoardRooms(completion: @escaping (BoardRoomResponse?) -> Void) {
        guard let request = createRequest(endpoint: "boardrooms", method: "GET") else { return }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("❌ Error fetching boardrooms: \(error.localizedDescription)") // DEBUG
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    let boardRooms = try JSONDecoder().decode(BoardRoomResponse.self, from: data)
                    print("✅ Successfully fetched \(boardRooms.records.count) boardrooms") // DEBUG
                    completion(boardRooms)
                } catch {
                    print("❌ Failed to decode boardrooms: \(error.localizedDescription)") // DEBUG
                    completion(nil)
                }
            }
        }.resume()
    }

    // 🔹 Fetch Employees
    func fetchEmployees(completion: @escaping (EmployeeResponse?) -> Void) {
        guard let request = createRequest(endpoint: "employees", method: "GET") else { return }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("❌ Error fetching employees: \(error.localizedDescription)") // DEBUG
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    let employees = try JSONDecoder().decode(EmployeeResponse.self, from: data)
                    print("✅ Successfully fetched \(employees.records.count) employees") // DEBUG
                    completion(employees)
                } catch {
                    print("❌ Failed to decode employees: \(error.localizedDescription)") // DEBUG
                    completion(nil)
                }
            }
        }.resume()
    }

    // 🔹 Fetch Bookings
    func fetchBookings(completion: @escaping (BookingResponse?) -> Void) {
        guard let request = createRequest(endpoint: "bookings", method: "GET") else {
            print("❌ Failed to create request for bookings")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error fetching bookings: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 API Response Code: \(httpResponse.statusCode)")
            }

            if let data = data {
                // 🔹 Print the raw JSON response
                print("📝 Raw JSON Response: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")

                do {
                    let decodedResponse = try JSONDecoder().decode(BookingResponse.self, from: data)
                    print("✅ Successfully fetched \(decodedResponse.records.count) bookings")
                    completion(decodedResponse)
                } catch {
                    print("❌ Failed to decode bookings: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }

    // 🔹 Post New Booking
    func postBooking(employeeID: String, boardroomID: String, date: Int, completion: @escaping (Bool) -> Void) {
        let payload: [String: Any] = [
            "fields": [
                "employee_id": employeeID,
                "boardroom_id": boardroomID,
                "date": date
            ]
        ]

        guard let body = try? JSONSerialization.data(withJSONObject: payload, options: []),
              let request = createRequest(endpoint: "bookings", method: "POST", body: body) else {
            print("❌ Failed to create POST request for booking") // DEBUG
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Failed to post booking: \(error.localizedDescription)") // DEBUG
                completion(false)
                return
            }

            // ✅ Check the Response Status Code
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("✅ Booking posted successfully!") // DEBUG

                // 🔹 Fetch updated bookings to verify if the booking exists
                NetworkManager.shared.fetchBookings { bookings in
                    if let bookings = bookings?.records,
                       bookings.contains(where: { $0.fields.employeeID == employeeID &&
                                                  $0.fields.boardroomID == boardroomID &&
                                                  Int($0.fields.date ?? 0) == date }){
                        print("✅ Booking verified on the server!") // DEBUG
                    } else {
                        print("❌ Booking not found on the server.") // DEBUG
                    }
                }

                completion(true)
            } else {
                print("❌ Failed to post booking. Status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)") // DEBUG
                completion(false)
            }
        }.resume()
    }
}

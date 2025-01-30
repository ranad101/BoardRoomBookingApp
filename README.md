# 🏢 BoardRoomBooking

A SwiftUI-based app for booking boardrooms, managing employee reservations, and displaying real-time availability.

## 📌 Features

	•	📅 Boardroom Booking System: Employees can book boardrooms for specific dates.
	•	🔄 Real-Time Availability: Displays available/unavailable boardrooms dynamically.
	•	👥 Employee-Specific Bookings: Shows employees their latest reservations.
	•	🌍 API-Driven Data: Fetches boardrooms, bookings, and employees from an external database.

## 🔗 API Integration

The app integrates with Airtable API to fetch, update, and manage boardroom data.

### Endpoints Used:

### 1️⃣ Fetch Boardrooms 

```swift
func fetchBoardRooms(completion: @escaping (BoardRoomResponse?) -> Void) {
    guard let request = createRequest(endpoint: "boardrooms", method: "GET") else { return }
    URLSession.shared.dataTask(with: request) { data, _, _ in
        guard let data = data else { completion(nil); return }
        let boardRooms = try? JSONDecoder().decode(BoardRoomResponse.self, from: data)
        completion(boardRooms)
    }.resume()
}
```


### 2️⃣ Fetch Employee Bookings

```swift
func fetchBookings(completion: @escaping (BookingResponse?) -> Void) {
    guard let request = createRequest(endpoint: "bookings", method: "GET") else { return }
    URLSession.shared.dataTask(with: request) { data, _, _ in
        guard let data = data else { completion(nil); return }
        let bookings = try? JSONDecoder().decode(BookingResponse.self, from: data)
        completion(bookings)
    }.resume()
}
```

### 3️⃣ Post a Booking

```swift
func postBooking(employeeID: String, boardroomID: String, date: Int, completion: @escaping (Bool) -> Void) {
    let payload: [String: Any] = [
        "fields": ["employee_id": employeeID, "boardroom_id": boardroomID, "date": date]
    ]
    guard let body = try? JSONSerialization.data(withJSONObject: payload, options: []),
          let request = createRequest(endpoint: "bookings", method: "POST", body: body) else {
        completion(false)
        return
    }
    URLSession.shared.dataTask(with: request) { _, response, _ in
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            completion(true)
        } else {
            completion(false)
        }
    }.resume()
}
```

### 🛠 Implementation Methodology

1. SwiftUI for UI Development
	•	Uses VStack, HStack, ScrollView, and List for dynamic UI layout.
	•	AsyncImage to load images efficiently.

2. State Management with ViewModels
	•	MVVM Architecture ensures separation of UI and business logic.
	•	@StateObject & @Published used for dynamic updates.

3. API Handling with Network Manager
	•	Singleton NetworkManager to manage API requests.
	•	JSON Decoding to parse boardroom and booking data.

4. Dynamic UI Updates
	•	Uses onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("BookingUpdated")))
	•	Automatically reloads boardrooms and bookings when updated.


### 🔧 Tech Stack & Tools Used

	•	📱 SwiftUI – UI framework for building declarative interfaces.
	•	🗄️ Airtable API – Backend for boardroom and booking data.
	•	🌐 URLSession – Handles HTTP requests.
	•	🔄 Combine Framework – For data-binding and updates.
	•	🛠 Xcode – IDE for development and debugging.


 ### 📬 Contact & Support
 aldawoodranad@outlook.com

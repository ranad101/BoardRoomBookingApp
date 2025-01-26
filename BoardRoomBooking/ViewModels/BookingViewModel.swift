import Foundation

struct BookingDetails: Identifiable {
    let id: String
    let boardroomID: String
    let boardroomName: String // Add this property
    let employeeName: String  // Add this property
    let date: Date
}

class BookingViewModel: ObservableObject {
    @Published var bookings: [BookingDetails] = []

    func loadBookings() {
        NetworkManager.shared.fetchBookings { [weak self] response in
            guard let records = response?.records else { return }

            DispatchQueue.main.async {
                var bookingDetails: [BookingDetails] = []
                let group = DispatchGroup()

                for booking in records {
                    group.enter()

                    // Extract booking fields
                    let boardroomID = booking.fields.boardroomID
                    let employeeID = booking.fields.employeeID
                    let date = Date(timeIntervalSince1970: TimeInterval(booking.fields.date ?? 0))

                    var boardroomName = ""
                    var employeeName = ""

                    // Fetch boardroom name
                    group.enter()
                    NetworkManager.shared.fetchBoardRooms { boardroomResponse in
                        boardroomName = boardroomResponse?.records.first(where: { $0.fields.id == boardroomID })?.fields.name ?? "Unknown Room"
                        group.leave()
                    }

                    // Fetch employee name
                    group.enter()
                    NetworkManager.shared.fetchEmployees { employeeResponse in
                        employeeName = employeeResponse?.records.first(where: { "\($0.fields.id)" == employeeID })?.fields.name ?? "Unknown Employee"
                        group.leave()
                    }

                    group.notify(queue: .main) {
                        // Append the fetched booking details
                        let detail = BookingDetails(
                            id: booking.id,
                            boardroomID: boardroomID,
                            boardroomName: boardroomName,
                            employeeName: employeeName,
                            date: date
                        )
                        bookingDetails.append(detail)
                        self?.bookings = bookingDetails
                        group.leave() // Ensure `leave` is called after all async work
                    }
                }

                group.notify(queue: .main) {
                    // Update the published bookings list
                    self?.bookings = bookingDetails
                }
            }
        }
    }
}

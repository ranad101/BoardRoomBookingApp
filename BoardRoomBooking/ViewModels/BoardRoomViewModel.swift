import Foundation

class BoardRoomViewModel: ObservableObject {
    @Published var boardRooms: [BoardRoomFields] = []  // List of boardrooms
    @Published var bookings: [BookingFields] = []      // List of bookings
    @Published var selectedDate = Date()              // Currently selected date

    func loadBoardRooms() {
        NetworkManager.shared.fetchBoardRooms { [weak self] response in
            DispatchQueue.main.async {
                self?.boardRooms = response?.records.map { $0.fields } ?? []
            }
        }
    }

    func loadBookings() {
        NetworkManager.shared.fetchBookings { [weak self] response in
            DispatchQueue.main.async {
                self?.bookings = response?.records.map { $0.fields } ?? []
            }
        }
    }

    // Filter boardrooms to show availability on the selected date
    func filterBoardRooms(by date: Date) -> [BoardRoomFields] {
        let selectedDayStart = Calendar.current.startOfDay(for: date)
        let selectedDayEnd = Calendar.current.date(byAdding: .day, value: 1, to: selectedDayStart)!

        // Filter boardrooms based on bookings
        return boardRooms.map { room in
            let isBooked = bookings.contains { booking in
                booking.boardroomID == room.id &&
                (Date(timeIntervalSince1970: TimeInterval(booking.date ?? 0)) >= selectedDayStart &&
                 Date(timeIntervalSince1970: TimeInterval(booking.date ?? 0)) < selectedDayEnd)
            }

            // Mark boardrooms as "available" or "booked"
            return BoardRoomFields(
                description: room.description,
                floorNo: room.floorNo,
                imageURL: room.imageURL,
                name: "\(room.name) (\(isBooked ? "Not Available" : "Available"))",
                seatNo: room.seatNo,
                facilities: room.facilities,
                id: room.id
            )
        }
    }
}

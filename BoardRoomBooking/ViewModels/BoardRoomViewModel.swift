import Foundation

class BoardRoomViewModel: ObservableObject {
    @Published var boardRooms: [BoardRoomFields] = []  // List of boardrooms
    @Published var bookings: [BookingFields] = []      // List of bookings
    @Published var selectedDate = Date()              // Currently selected date
    @Published var employeeBookings: [BookingFields] = [] // Specific bookings for logged-in employee

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

    func loadEmployeeBookings(employeeID: String) {
        NetworkManager.shared.fetchBookings { [weak self] response in
            DispatchQueue.main.async {
                self?.employeeBookings = response?.records
                    .map { $0.fields }
                    .filter { $0.employeeID == employeeID } ?? []
            }
        }
    }

    // 🔹 FIX: Filter Boardrooms to show correct availability based on bookings
    func filterBoardRooms(by date: Date) -> [BoardRoomFields] {
        let selectedDayStart = Calendar.current.startOfDay(for: date)
        let selectedDayEnd = Calendar.current.date(byAdding: .day, value: 1, to: selectedDayStart)!

        return boardRooms.map { room in
            let isBooked = bookings.contains { booking in
                booking.boardroomID == room.id &&
                (Date(timeIntervalSince1970: TimeInterval(booking.date ?? 0)) >= selectedDayStart &&
                 Date(timeIntervalSince1970: TimeInterval(booking.date ?? 0)) < selectedDayEnd)
            }

            return BoardRoomFields(
                description: room.description,
                floorNo: room.floorNo,
                imageURL: room.imageURL,
                name: isBooked ? "\(room.name) (Unavailable)" : "\(room.name) (Available)",
                seatNo: room.seatNo,
                facilities: room.facilities,
                id: room.id
            )
        }
    }
}

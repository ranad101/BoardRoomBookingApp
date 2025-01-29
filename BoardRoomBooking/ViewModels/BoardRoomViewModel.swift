import Foundation

class BoardRoomViewModel: ObservableObject {
    @Published var boardRooms: [BoardRoomFields] = []  // All boardrooms
    @Published var bookings: [BookingFields] = []      // All bookings
    @Published var employeeBookings: [BookingFields] = [] // Employee's personal bookings
    @Published var selectedDate = Date()               // Currently selected date

    func loadBoardRooms() {
        NetworkManager.shared.fetchBoardRooms { [weak self] response in
            DispatchQueue.main.async {
                self?.boardRooms = response?.records.map { $0.fields } ?? []
                print("✅ Boardrooms fetched:", self?.boardRooms.count ?? 0) // DEBUG
            }
        }
    }

    func loadBookings() {
        NetworkManager.shared.fetchBookings { [weak self] response in
            DispatchQueue.main.async {
                self?.bookings = response?.records.map { $0.fields } ?? []
                print("✅ Bookings fetched:", self?.bookings.count ?? 0) // DEBUG
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

    // 🔹 **Fix: Show BOTH Available & Unavailable Boardrooms**
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
                id: room.id // ✅ Move `id` to the correct position
            )
        }
    }

    // ✅ **Get All Boardrooms for Selected Date**
    func getBoardroomsForDate(_ date: Date) -> [BoardRoomFields] {
        return filterBoardRooms(by: date)
    }

    // ✅ **Check If Boardroom is Available**
    func isBoardroomAvailable(roomID: String, date: Date) -> Bool {
        let selectedDayStart = Calendar.current.startOfDay(for: date)
        let selectedDayEnd = Calendar.current.date(byAdding: .day, value: 1, to: selectedDayStart)!

        return !bookings.contains { booking in
            booking.boardroomID == roomID &&
            (Date(timeIntervalSince1970: TimeInterval(booking.date ?? 0)) >= selectedDayStart &&
             Date(timeIntervalSince1970: TimeInterval(booking.date ?? 0)) < selectedDayEnd)
        }
    }

    // 🔹 **Get Upcoming Dates for UI**
    func getUpcomingDates() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    }

    // 🔹 **Format Day Name (e.g., "Mon", "Tue")**
    func getDayOfWeek(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // "Mon", "Tue", etc.
        return formatter.string(from: date)
    }

    // 🔹 **Format Date to Number (e.g., "2", "28")**
    func getDateNumber(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // Just the day
        return formatter.string(from: date)
    }

    // 🔹 **Check if Date is Selected**
    func isSelectedDate(_ date: Date) -> Bool {
        return Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }

    // 🔹 **Get Latest Booking for "My Booking"**
    func getLatestBooking() -> BookingFields? {
        return employeeBookings.sorted { ($0.date ?? 0) > ($1.date ?? 0) }.first
    }
}

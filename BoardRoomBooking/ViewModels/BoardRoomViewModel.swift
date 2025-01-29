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
                name: room.name + (isBooked ? " (Unavailable)" : " (Available)"),
                seatNo: room.seatNo,
                facilities: room.facilities,
                id: room.id
            )
        }
    }
}

import Foundation

class BoardRoomViewModel: ObservableObject {
    @Published var boardRooms: [BoardRoomFields] = []
    @Published var bookings: [BookingDetails] = []
    @Published var selectedDate: Date = Date() // Add this property to store the selected date

    func loadBoardRooms() {
        // Implement the fetch logic for boardrooms
    }

    func loadBookings() {
        // Implement the fetch logic for bookings
    }

    func isBoardRoomAvailable(boardroomID: String, on date: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = dateFormatter.string(from: date)
        return !bookings.contains { booking in
            booking.boardroomID == boardroomID && dateFormatter.string(from: booking.date) == selectedDateString
        }
    }
}

import Foundation

class BookingViewModel: ObservableObject {
    @Published var bookings: [BookingFields] = []

    func loadBookings() {
        NetworkManager.shared.fetchBookings { [weak self] response in
            DispatchQueue.main.async {
                // Extract the `fields` array from the response
                self?.bookings = response?.records.map { $0.fields } ?? []
            }
        }
    }
}

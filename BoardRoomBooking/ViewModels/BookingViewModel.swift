import Foundation

class BookingViewModel: ObservableObject {
    @Published var bookings: [BookingFields] = []

    func loadBookings() {
        NetworkManager.shared.fetchBookings { [weak self] response in
            DispatchQueue.main.async {
                self?.bookings = response?.records.map { $0.fields } ?? []
            }
        }
    }
}

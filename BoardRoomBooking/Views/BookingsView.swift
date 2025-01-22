import SwiftUI

struct BookingsView: View {
    @StateObject private var viewModel = BookingViewModel()

    var body: some View {
        List(viewModel.bookings, id: \.boardroomID) { booking in
            Text("Booking for: \(booking.boardroomID)")
        }
        .onAppear {
            viewModel.loadBookings()
        }
    }
}

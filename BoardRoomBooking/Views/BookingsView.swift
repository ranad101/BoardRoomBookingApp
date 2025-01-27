import SwiftUI

struct BookingsView: View {
    @StateObject private var viewModel = BookingViewModel()

    var body: some View {
        List(viewModel.bookings, id: \.boardroomID) { booking in
            VStack(alignment: .leading) {
                Text("Boardroom ID: \(booking.boardroomID)")
                if let date = booking.date {
                    Text("Date: \(Date(timeIntervalSince1970: TimeInterval(date)))")
                }
                Text("Employee ID: \(booking.employeeID)")
            }
        }
        .onAppear {
            viewModel.loadBookings()
        }
        .navigationTitle("Bookings")
    }
}
#Preview {
    BookingsView()
}

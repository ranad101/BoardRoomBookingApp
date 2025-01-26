import SwiftUI

struct BookingsView: View {
    @StateObject private var viewModel = BookingViewModel()

    var body: some View {
        List(viewModel.bookings) { booking in
            VStack(alignment: .leading, spacing: 8) {
                Text("Boardroom: \(booking.boardroomName)")
                    .font(.headline)
                Text("Employee: \(booking.employeeName)")
                    .font(.subheadline)
                Text("Date: \(formattedDate(booking.date))")
                    .font(.body)
            }
            .padding(.vertical, 8)
        }
        .onAppear {
            viewModel.loadBookings()
        }
        .navigationTitle("Bookings")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

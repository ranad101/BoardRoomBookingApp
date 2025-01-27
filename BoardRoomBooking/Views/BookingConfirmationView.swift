import SwiftUI

struct BookingConfirmationView: View {
    let boardroom: BoardRoomFields
    let selectedDate: Date

    var body: some View {
        VStack(spacing: 20) {
            // Confirmation Details
            Text("Booking Confirmation")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Boardroom: \(boardroom.name)")
                .font(.title2)
            Text("Date: \(selectedDate, formatter: dateFormatter)")
                .font(.headline)

            Spacer()

            // Confirm Button
            Button(action: {
                print("Booking confirmed!")
                // Add your NetworkManager logic here to create the booking
            }) {
                Text("Confirm Booking")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .navigationTitle("Confirmation")
    }
}

// Date formatter
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

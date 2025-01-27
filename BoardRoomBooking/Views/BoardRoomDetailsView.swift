import SwiftUI

struct BoardRoomDetailView: View {
    let boardroom: BoardRoomFields
    let employeeID: String

    @State private var isBookingSuccessful: Bool?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Display boardroom details
            AsyncImage(url: URL(string: boardroom.imageURL)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 200)
            .cornerRadius(10)
            
            Text(boardroom.name)
                .font(.title)
                .bold()
            
            Text("Floor: \(boardroom.floorNo)")
            Text("Seats: \(boardroom.seatNo)")
            Text(boardroom.description)
            
            HStack {
                ForEach(boardroom.facilities, id: \.self) { facility in
                    Text(facility)
                        .font(.caption)
                        .padding(5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }
            }
            
            Spacer()
            
            // Booking Button
            Button(action: {
                let currentDate = Int(Date().timeIntervalSince1970)
                NetworkManager.shared.postBooking(employeeID: employeeID, boardroomID: boardroom.id, date: currentDate) { success in
                    DispatchQueue.main.async {
                        if success {
                            isBookingSuccessful = true
                        } else {
                            isBookingSuccessful = false
                        }
                    }
                }
            }) {
                Text("Book Now")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .alert(isPresented: Binding<Bool>(get: { isBookingSuccessful != nil }, set: { _ in })) {
                if isBookingSuccessful == true {
                    return Alert(title: Text("Success"), message: Text("Boardroom booked successfully!"), dismissButton: .default(Text("OK")))
                } else {
                    return Alert(title: Text("Error"), message: Text("Failed to book boardroom. Please try again."), dismissButton: .default(Text("OK")))
                }
            }}    }
}

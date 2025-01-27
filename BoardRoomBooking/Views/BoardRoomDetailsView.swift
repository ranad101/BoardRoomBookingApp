import SwiftUI

struct BoardRoomDetailsView: View {
    let boardroom: BoardRoomFields
    let selectedDate: Date

    var body: some View {
        VStack(spacing: 20) {
            // Boardroom Image
            AsyncImage(url: URL(string: boardroom.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 200)
            .cornerRadius(10)

            // Boardroom Details
            Text(boardroom.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(boardroom.description)
                .font(.body)
                .padding(.horizontal)
                .multilineTextAlignment(.leading)

            HStack {
                Text("Floor: \(boardroom.floorNo)")
                Text("Seats: \(boardroom.seatNo)")
            }
            .font(.subheadline)

            // Facilities
            VStack(alignment: .leading, spacing: 5) {
                Text("Facilities:")
                    .font(.headline)
                ForEach(boardroom.facilities, id: \.self) { facility in
                    Text("- \(facility)")
                }
            }
            .padding(.horizontal)

            Spacer()

            // Book Now Button
            NavigationLink(destination: BookingConfirmationView(boardroom: boardroom, selectedDate: selectedDate)) {
                Text("Book Now")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .navigationTitle("Boardroom Details")
    }
}

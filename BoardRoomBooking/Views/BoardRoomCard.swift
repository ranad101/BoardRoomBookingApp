import SwiftUI

struct BoardRoomCard: View {
    let room: BoardRoomFields
    let isAvailable: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: room.imageURL)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 180)
            .cornerRadius(12)

            Text(room.name)
                .font(.title3)
                .bold()

            HStack {
                Text(isAvailable ? "Available" : "Unavailable")
                    .font(.caption)
                    .bold()
                    .foregroundColor(isAvailable ? .green : .red)
                Spacer()
                Text("\(room.seatNo) Seats")
                    .font(.caption)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

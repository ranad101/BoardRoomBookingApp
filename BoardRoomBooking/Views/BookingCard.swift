import SwiftUI

struct BookingCard: View {
    let room: BoardRoomFields
    let date: Int?

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: room.imageURL)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 100)
            .cornerRadius(10)

            Text(room.name)
                .font(.headline)
            if let bookingDate = date {
                Text("Booked on: \(formattedDate(from: bookingDate))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }

    func formattedDate(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}

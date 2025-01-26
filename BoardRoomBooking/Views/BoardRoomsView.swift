import SwiftUI

import SwiftUI

struct BoardRoomsView: View {
    @StateObject private var viewModel = BoardRoomViewModel()

    var body: some View {
        VStack {
            // Date Selector
            DatePicker(
                "Select Date",
                selection: $viewModel.selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()

            // Boardrooms List or Placeholder
            if viewModel.boardRooms.isEmpty {
                Text("No boardrooms available for the selected date.")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .padding()
            } else {
                List(viewModel.boardRooms, id: \.id) { boardroom in
                    VStack(alignment: .leading, spacing: 10) {
                        // Display the image
                        AsyncImage(url: URL(string: boardroom.imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 150)
                        .cornerRadius(10)

                        // Room details
                        Text(boardroom.name)
                            .font(.headline)
                        Text("Floor: \(boardroom.floorNo)")
                            .font(.subheadline)
                        Text(boardroom.description)
                            .font(.body)
                            .lineLimit(3)

                        // Seat number
                        Text("Seats: \(boardroom.seatNo)")
                            .font(.subheadline)

                        // Facilities
                        HStack {
                            ForEach(boardroom.facilities, id: \.self) { facility in
                                Text(facility)
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(5)
                            }
                        }

                        // Availability
                        let isAvailable = viewModel.isBoardRoomAvailable(
                            boardroomID: boardroom.id,
                            on: viewModel.selectedDate
                        )
                        Text(isAvailable ? "Available" : "Unavailable")
                            .foregroundColor(isAvailable ? .green : .red)
                            .font(.caption)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.loadBoardRooms()
            viewModel.loadBookings()
        }
        .onChange(of: viewModel.selectedDate) { _ in
            // Reload bookings or availability if needed
        }
        .navigationTitle("Board Rooms")
    }
}

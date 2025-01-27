import SwiftUI

struct BoardRoomsView: View {
    @StateObject private var viewModel = BoardRoomViewModel()
    @State private var selectedRoom: BoardRoomFields?

    var body: some View {
        VStack {
            // Date Picker
            DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            // List of Boardrooms
            List(viewModel.filterBoardRooms(by: viewModel.selectedDate), id: \.id) { room in
                NavigationLink(destination: BoardRoomDetailsView(boardroom: room, selectedDate: viewModel.selectedDate)) {
                    VStack(alignment: .leading, spacing: 10) {
                        // Display the image
                        AsyncImage(url: URL(string: room.imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 150)
                        .cornerRadius(10)

                        // Room details
                        Text(room.name)
                            .font(.headline)
                        Text("Floor: \(room.floorNo)")
                            .font(.subheadline)
                        Text(room.description)
                            .font(.body)
                            .lineLimit(3)

                        // Seat number
                        Text("Seats: \(room.seatNo)")
                            .font(.subheadline)

                        // Facilities
                        HStack {
                            ForEach(room.facilities, id: \.self) { facility in
                                Text(facility)
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.loadBoardRooms()
            viewModel.loadBookings()
        }
        .navigationTitle("Board Rooms")
    }
}

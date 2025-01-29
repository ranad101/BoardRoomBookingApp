import SwiftUI

struct BoardRoomsView: View {
    @StateObject private var viewModel = BoardRoomViewModel()
    @State private var selectedRoom: BoardRoomFields?
    let loggedInEmployeeID: String

    var body: some View {
        VStack {
            // Header
            Text("Board Rooms")
                .font(.largeTitle)
                .bold()
                .padding()

            // Date Picker
            DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            // **My Bookings Section**
            if !viewModel.employeeBookings.isEmpty {
                VStack(alignment: .leading) {
                    Text("My Bookings")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.employeeBookings, id: \.boardroomID) { booking in
                                if let room = viewModel.boardRooms.first(where: { $0.id == booking.boardroomID }) {
                                    VStack {
                                        AsyncImage(url: URL(string: room.imageURL)) { image in
                                            image.resizable().aspectRatio(contentMode: .fill)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 150, height: 100)
                                        .cornerRadius(10)

                                        Text(room.name)
                                            .font(.headline)
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            // **All Boardrooms List**
            List(viewModel.filterBoardRooms(by: viewModel.selectedDate), id: \.id) { room in
                Button(action: {
                    selectedRoom = room
                }) {
                    VStack(alignment: .leading, spacing: 10) {
                        AsyncImage(url: URL(string: room.imageURL)) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 150)
                        .cornerRadius(10)

                        Text(room.name)
                            .font(.headline)
                        Text("Floor: \(room.floorNo)")
                            .font(.subheadline)
                        Text("Seats: \(room.seatNo)")
                            .font(.subheadline)

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
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(item: $selectedRoom) { room in
                    BoardRoomDetailView(boardroom: room, employeeID: loggedInEmployeeID)
                }
            }
        }
        .onAppear {
            viewModel.loadBoardRooms()
            viewModel.loadBookings()
            viewModel.loadEmployeeBookings(employeeID: loggedInEmployeeID)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("BookingUpdated"))) { _ in
            viewModel.loadBookings()
            viewModel.loadBoardRooms() // Reload boardrooms after a booking update
        }
    }
}

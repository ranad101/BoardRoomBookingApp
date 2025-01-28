import SwiftUI

struct BoardRoomsView: View {
    @StateObject private var viewModel = BoardRoomViewModel()
    @State private var selectedRoom: BoardRoomFields? = nil  // ✅ Ensure it's optional
    let loggedInEmployeeID: String

    var body: some View {
        VStack {
            // **Header**
            Text("Board Rooms")
                .font(.largeTitle)
                .bold()
                .padding()

            // **Date Picker**
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
            List(viewModel.filterBoardRooms(by: viewModel.selectedDate)) { room in
                Button(action: {
                    selectedRoom = room  // ✅ Now boardrooms can be tapped and booked
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

                        // ✅ Display Availability Status for ALL Employees
                        if viewModel.isBoardroomAvailable(roomID: room.id, date: viewModel.selectedDate) {
                            Text("Available")
                                .font(.caption)
                                .foregroundColor(.green)
                                .bold()
                        } else {
                            Text("Unavailable")
                                .font(.caption)
                                .foregroundColor(.red)
                                .bold()
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .onAppear {
            viewModel.loadBoardRooms()
            viewModel.loadBookings()
            viewModel.loadEmployeeBookings(employeeID: loggedInEmployeeID)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("BookingUpdated"))) { _ in
            viewModel.loadBookings()
            viewModel.loadBoardRooms() // ✅ Reload boardrooms after a booking update
        }
        .sheet(item: $selectedRoom) { room in
            BoardRoomDetailView(boardroom: room, employeeID: loggedInEmployeeID)
        }
    }
}

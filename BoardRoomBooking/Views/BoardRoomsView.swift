import SwiftUI

struct BoardRoomsView: View {
    @StateObject private var viewModel = BoardRoomViewModel()
    @State private var selectedRoom: BoardRoomFields?
    let loggedInEmployeeID: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // **Header**
                Text("Board Rooms")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)

                // **Availability Banner**
                AvailabilityBanner()

                // **Date Selector**
                DateSelectorView(selectedDate: $viewModel.selectedDate)

                // **My Bookings**
                // **My Bookings**
                if let latestBooking = viewModel.employeeBookings.sorted(by: { ($0.date ?? 0) > ($1.date ?? 0) }).first,
                   let room = viewModel.boardRooms.first(where: { $0.id == latestBooking.boardroomID }) {
                    
                    MyBookingCard(room: room, bookingDate: Int(latestBooking.date ?? 0)) // ✅ Convert Double? to Int?
                }

                // **Available & Unavailable Boardrooms**
                Text("Boardrooms")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                ForEach(viewModel.filterBoardRooms(by: viewModel.selectedDate), id: \.id) { room in
                    BoardRoomCard(room: room, isAvailable: viewModel.isBoardroomAvailable(roomID: room.id, date: viewModel.selectedDate))
                        .onTapGesture {
                            selectedRoom = room
                        }
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
            viewModel.loadBoardRooms() // ✅ Reload boardrooms after a booking update
        }
        .sheet(item: $selectedRoom) { room in
            BoardRoomDetailsView(boardroom: room, employeeID: loggedInEmployeeID)
        }
    }
}

// **Reusable Components**
struct AvailabilityBanner: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("All board rooms")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                Text("Available today")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
            Spacer()
            Image(systemName: "arrow.right.circle.fill")
                .font(.title)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.orange)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct DateSelectorView: View {
    @Binding var selectedDate: Date
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<7, id: \.self) { offset in
                    let date = Calendar.current.date(byAdding: .day, value: offset, to: Date())!
                    VStack {
                        Text(date, format: .dateTime.weekday().locale(.current))
                            .font(.caption)
                        Text(date, format: .dateTime.day())
                            .font(.headline)
                    }
                    .padding()
                    .background(Calendar.current.isDate(selectedDate, inSameDayAs: date) ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct MyBookingCard: View {
    let room: BoardRoomFields
    let bookingDate: Int?

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: room.imageURL)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 120)
            .cornerRadius(10)

            VStack(alignment: .leading) {
                Text(room.name)
                    .font(.headline)
                if let bookingDate = bookingDate {
                    Text("Booked on: \(Date(timeIntervalSince1970: TimeInterval(bookingDate)), formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}


// **Date Formatter**
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()



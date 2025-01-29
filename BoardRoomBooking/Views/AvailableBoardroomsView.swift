import SwiftUI

struct AvailableBoardroomsView: View {
    @ObservedObject var viewModel: BoardRoomViewModel
    @Binding var selectedRoom: BoardRoomFields?
    let loggedInEmployeeID: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Available Boardrooms")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.filterBoardRooms(by: viewModel.selectedDate), id: \.id) { room in
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

                                HStack {
                                    Text(viewModel.isBoardroomAvailable(roomID: room.id, date: viewModel.selectedDate) ? "Available" : "Unavailable")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(viewModel.isBoardroomAvailable(roomID: room.id, date: viewModel.selectedDate) ? .green : .red)
                                    Spacer()
                                    Text("\(room.seatNo) Seats")
                                        .font(.caption)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

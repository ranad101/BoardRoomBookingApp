import SwiftUI

struct AvailableBoardroomsView: View {
    @ObservedObject var viewModel: BoardRoomViewModel
    @Binding var selectedRoom: BoardRoomFields?
    let loggedInEmployeeID: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Available Boardrooms")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            DateSelectorView(selectedDate: $viewModel.selectedDate)
                .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.getBoardroomsForDate(viewModel.selectedDate), id: \.id) { room in
                        Button(action: { selectedRoom = room }) {
                            BoardRoomCard(room: room, isAvailable: viewModel.isBoardroomAvailable(roomID: room.id, date: viewModel.selectedDate))
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadBoardRooms()
            viewModel.loadBookings()
        }
    }
}



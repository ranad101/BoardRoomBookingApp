import Foundation

class BoardRoomViewModel: ObservableObject {
    @Published var boardRooms: [BoardRoomFields] = []

    func loadBoardRooms() {
        NetworkManager.shared.fetchBoardRooms { [weak self] response in
            DispatchQueue.main.async {
                self?.boardRooms = response?.records.map { $0.fields } ?? []
            }
        }
    }
}

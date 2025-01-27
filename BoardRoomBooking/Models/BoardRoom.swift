import Foundation

struct BoardRoomResponse: Codable {
    let records: [BoardRoomRecord]
}

struct BoardRoomRecord: Codable {
    let id: String
    let createdTime: String
    let fields: BoardRoomFields
}

struct BoardRoomFields: Codable, Identifiable {
    let description: String
    let floorNo: Int
    let imageURL: String
    let name: String
    let seatNo: Int
    let facilities: [String]
    let id: String

    enum CodingKeys: String, CodingKey {
        case description
        case floorNo = "floor_no"
        case imageURL = "image_url"
        case name
        case seatNo = "seat_no"
        case facilities, id
    }
}

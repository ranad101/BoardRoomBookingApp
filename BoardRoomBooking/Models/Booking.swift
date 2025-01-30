import Foundation

struct BookingResponse: Codable {
    let records: [BookingRecord]
}

struct BookingRecord: Codable {
    let id: String
    let fields: BookingFields
}

struct BookingFields: Codable {
    let boardroomID: String
    let date: Double?  // Change from Int? to Double?
    let employeeID: String

    enum CodingKeys: String, CodingKey {
        case boardroomID = "boardroom_id"
        case date
        case employeeID = "employee_id"
    }
}


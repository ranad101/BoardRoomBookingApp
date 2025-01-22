import Foundation

struct EmployeeResponse: Codable {
    let records: [EmployeeRecord]
}

struct EmployeeRecord: Codable {
    let id: String
    let fields: EmployeeFields
}

struct EmployeeFields: Codable {
    let id: Int
    let name: String
    let jobTitle: String
    let password: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case jobTitle = "job_title"
        case password
        case email
    }
}

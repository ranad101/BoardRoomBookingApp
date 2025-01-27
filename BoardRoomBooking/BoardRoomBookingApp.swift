import SwiftUI

@main
struct BoardRoomBookingApp: App {
    @State private var loggedInEmployeeID: String?

    var body: some Scene {
        WindowGroup {
            if let employeeID = loggedInEmployeeID {
                NavigationView {
                    BoardRoomsView(loggedInEmployeeID: employeeID)
                }
            } else {
                EmployeesView(onLogin: { employeeID in
                    loggedInEmployeeID = employeeID
                })
            }
        }
    }
}

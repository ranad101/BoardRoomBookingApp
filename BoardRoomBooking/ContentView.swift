import SwiftUI

struct ContentView: View {
    @State private var loggedInEmployeeID: String?

    var body: some View {
        if let employeeID = loggedInEmployeeID {
            NavigationView {
                BoardRoomsView(loggedInEmployeeID: employeeID)  // Pass employeeID correctly
            }
        } else {
            EmployeesView(onLogin: { employeeID in
                loggedInEmployeeID = employeeID
            })
        }
    }
}

#Preview {
    ContentView()
}

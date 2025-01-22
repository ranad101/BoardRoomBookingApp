import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                BoardRoomsView()
            }
            .tabItem {
                Label("Board Rooms", systemImage: "building.2")
            }

            NavigationView {
                EmployeesView()
            }
            .tabItem {
                Label("Employees", systemImage: "person.3")
            }

            NavigationView {
                BookingsView()
            }
            .tabItem {
                Label("Bookings", systemImage: "calendar")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

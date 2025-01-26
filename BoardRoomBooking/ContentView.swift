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

import SwiftUI

@main
struct watch_displayApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PlantListView()
            }
        }
    }
}

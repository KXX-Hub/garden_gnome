import SwiftUI

struct PlantRowView: View {
    let plant: Plant
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(plant.name)
                .font(.headline)
            Text(plant.species)
                .font(.subheadline)
            Text("上次澆水: \(plant.lastWatered.formatted())")
                .font(.caption)
        }
        .padding(.vertical, 4)
    }
}

import SwiftUI

struct PlantRowView: View {
    @ObservedObject var viewModel: PlantViewModel
    let plant: Plant
    
    var body: some View {
        NavigationLink(destination: PlantDetailView(viewModel: viewModel, plant: plant)) {
            VStack(alignment: .leading) {
                Text(plant.name)
                    .font(.headline)
                Text(plant.species)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("上次澆水: \(plant.lastWatered.formatted())")
                    .font(.caption)
            }
            .padding(.vertical, 4)
        }
    }
}

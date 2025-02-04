import SwiftUI

struct PlantRowView: View {
    @ObservedObject var viewModel: PlantViewModel
    let plant: Plant
    
    var isWrongGrowthState: Bool {
        let currentMonth = Calendar.current.component(.month, from: Date())
        switch plant.growthType {
        case .winter:
            return plant.currentState == .active && (currentMonth >= 4 && currentMonth <= 9) ||
                   plant.currentState == .dormant && (currentMonth >= 10 || currentMonth <= 3)
        case .summer:
            return plant.currentState == .active && (currentMonth >= 10 || currentMonth <= 3) ||
                   plant.currentState == .dormant && (currentMonth >= 4 && currentMonth <= 9)
        case .evergreen:
            return false
        }
    }
    
    var body: some View {
        NavigationLink(destination: PlantDetailView(viewModel: viewModel, plant: plant)) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(plant.name)
                            .font(.headline)
                        Text(plant.currentState.rawValue)
                            .font(.caption2)
                            .foregroundColor(plant.currentState == .active ? .green : .red)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(plant.currentState == .active ?
                                         Color.green.opacity(0.1) :
                                         Color.red.opacity(0.1))
                            )
                        if isWrongGrowthState {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.yellow)
                                .imageScale(.small)
                        }
                        if plant.needsWater {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                                .imageScale(.small)
                        }
                    }
                    Text(plant.species)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack {
                        Text("上次澆水:")
                            .font(.caption)
                        Text(plant.lastWatered, style: .date)
                            .font(.caption)
                            .foregroundColor(plant.needsWater ? .blue : .secondary)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    isWrongGrowthState ? Color.yellow.opacity(0.1) :
                    plant.needsWater ? Color.blue.opacity(0.1) : Color.clear
                )
                .padding(2)
        )
    }
}

import SwiftUI

struct PlantListView: View {
    @StateObject private var viewModel = PlantViewModel()
    @State private var showingAddPlant = false
    
    var categorizedPlants: (abnormal: [Plant], needsWater: [Plant], normal: [Plant]) {
        let allPlants = viewModel.plants
        
        let abnormalPlants = allPlants.filter { plant in
            let currentMonth = Calendar.current.component(.month, from: Date())
            switch plant.growthType {
            case .winter:
                return (currentMonth >= 4 && currentMonth <= 9 && plant.currentState == .active) ||
                       ((currentMonth >= 10 || currentMonth <= 3) && plant.currentState == .dormant)
            case .summer:
                return ((currentMonth >= 10 || currentMonth <= 3) && plant.currentState == .active) ||
                       (currentMonth >= 4 && currentMonth <= 9 && plant.currentState == .dormant)
            case .evergreen:
                return false
            }
        }
        
        let needsWaterPlants = allPlants.filter { plant in
            let daysSinceLastWatered = Calendar.current.dateComponents([.day], from: plant.lastWatered, to: Date()).day ?? 0
            return daysSinceLastWatered >= plant.currentWateringInterval
        }
        
        let normalPlants = allPlants.filter { plant in
            !abnormalPlants.contains { $0.id == plant.id } &&
            !needsWaterPlants.contains { $0.id == plant.id }
        }
        
        return (abnormalPlants, needsWaterPlants, normalPlants)
    }
    
    var body: some View {
        List {
            if !categorizedPlants.abnormal.isEmpty {
                Section(header: Text("生長異常 (\(categorizedPlants.abnormal.count))").foregroundColor(.yellow)) {
                    ForEach(categorizedPlants.abnormal) { plant in
                        PlantRowView(viewModel: viewModel, plant: plant)
                    }
                }
            }
            
            if !categorizedPlants.needsWater.isEmpty {
                Section(header: Text("需要澆水 (\(categorizedPlants.needsWater.count))").foregroundColor(.blue)) {
                    ForEach(categorizedPlants.needsWater) { plant in
                        PlantRowView(viewModel: viewModel, plant: plant)
                    }
                }
            }
            
            if !categorizedPlants.normal.isEmpty {
                Section(header: Text("正常 (\(categorizedPlants.normal.count))")) {
                    ForEach(categorizedPlants.normal) { plant in
                        PlantRowView(viewModel: viewModel, plant: plant)
                    }
                }
            }
        }
        .navigationTitle("我的植物")
        .toolbar {
            Button(action: { showingAddPlant = true }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddPlant) {
            AddPlantView(viewModel: viewModel)
        }
    }
}

import Foundation

class PlantViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    
    func addPlant(name: String,
                 species: String,
                 growthType: GrowthType,
                 activeWateringInterval: Int,
                 dormantWateringInterval: Int) {
        let plant = Plant(
            name: name,
            species: species,
            growthType: growthType,
            activeWateringInterval: activeWateringInterval,
            dormantWateringInterval: dormantWateringInterval
        )
        plants.append(plant)
    }
    
    func removePlant(at indexSet: IndexSet) {
        plants.remove(atOffsets: indexSet)
    }
    
    func waterPlant(_ plant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index].lastWatered = Date()
        }
    }
    
    func togglePlantState(_ plant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index].currentState = plants[index].currentState == .active ? .dormant : .active
        }
    }
}

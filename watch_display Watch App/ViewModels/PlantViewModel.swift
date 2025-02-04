import Foundation

class PlantViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    
    init() {
        createSampleData()
    }
    
    private func createSampleData() {
        let calendar = Calendar.current
        let today = Date()
        
        // 1. 生長狀態異常的植物
        var plant1 = Plant(
            name: "Test1",
            species: "象牙宮",
            growthType: .summer,
            activeWateringInterval: 7,
            dormantWateringInterval: 14
        )
        plant1.currentState = .active  // 冬季強制設為生長期
        plants.append(plant1)
        
        // 2. 需要澆水的植物 (8天前澆水，週期7天)
        var plant2 = Plant(
            name: "Test2",
            species: "象牙宮",
            growthType: .summer,
            activeWateringInterval: 7,
            dormantWateringInterval: 14
        )
        if let waterDate = calendar.date(byAdding: .day, value: -15, to: today) {
            plant2.lastWatered = calendar.startOfDay(for: waterDate)
        }
        plants.append(plant2)
        
        // 3. 生長狀態異常的南非龜甲龍
        var plant3 = Plant(
            name: "Test3",
            species: "南非龜甲龍",
            growthType: .winter,
            activeWateringInterval: 7,
            dormantWateringInterval: 14
        )
        plant3.currentState = .dormant  // 冬季強制設為休眠期
        plants.append(plant3)
        
        // 4. 需要澆水的娜娜乳香 (10天前澆水，週期7天)
        var plant4 = Plant(
            name: "Test4",
            species: "娜娜乳香",
            growthType: .summer,
            activeWateringInterval: 7,
            dormantWateringInterval: 14
        )
        if let waterDate = calendar.date(byAdding: .day, value: -20, to: today) {
            plant4.lastWatered = calendar.startOfDay(for: waterDate)
        }
        plants.append(plant4)
        
        // 5. 正常的植物
        let plant5 = Plant(
            name: "Test5",
            species: "藍巖龍實珠",
            growthType: .summer,
            activeWateringInterval: 7,
            dormantWateringInterval: 14
        )
        plants.append(plant5)
        
        // 6. 正常的植物
        let plant6 = Plant(
            name: "Test6",
            species: "圓葉山烏龜",
            growthType: .summer,
            activeWateringInterval: 7,
            dormantWateringInterval: 14
        )
        plants.append(plant6)
    }
    
    // MARK: - 植物管理方法
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
    
    // MARK: - 植物狀態更新方法
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
    
    func updateWateringIntervals(_ plant: Plant, active: Int, dormant: Int) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index].activeWateringInterval = active
            plants[index].dormantWateringInterval = dormant
        }
    }
    
    func updatePlantedDate(_ plant: Plant, plantedDate: Date) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index].plantedDate = plantedDate
        }
    }
}

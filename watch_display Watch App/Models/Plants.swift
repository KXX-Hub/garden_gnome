import Foundation

// 生長類型
enum GrowthType: String, Codable {
    case summer = "夏型種"  // 夏季生長
    case winter = "冬型種"  // 冬季生長
    case evergreen = "常年生長"  // 無休眠期
}

// 生長狀態
enum GrowthState: String, Codable {
    case active = "生長期"
    case dormant = "休眠期"
}

struct Plant: Identifiable, Codable {
    let id: UUID
    var name: String
    var species: String
    var growthType: GrowthType
    var currentState: GrowthState
    var activeWateringInterval: Int  // 生長期澆水間隔
    var dormantWateringInterval: Int // 休眠期澆水間隔
    var plantedDate: Date
    var lastWatered: Date
    
    var currentWateringInterval: Int {
        currentState == .active ? activeWateringInterval : dormantWateringInterval
    }
    
    var daysSinceLastWatered: Int {
        let components = Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: lastWatered),
            to: Calendar.current.startOfDay(for: Date())
        )
        return components.day ?? 0
    }
    
    var needsWater: Bool {
        daysSinceLastWatered >= currentWateringInterval
    }
    
    init(id: UUID = UUID(),
         name: String,
         species: String,
         growthType: GrowthType,
         activeWateringInterval: Int,
         dormantWateringInterval: Int) {
        self.id = id
        self.name = name
        self.species = species
        self.growthType = growthType
        self.activeWateringInterval = activeWateringInterval
        self.dormantWateringInterval = dormantWateringInterval
        self.plantedDate = Date()
        self.lastWatered = Date()
        
        let currentMonth = Calendar.current.component(.month, from: Date())
        switch growthType {
        case .summer:
            self.currentState = (currentMonth >= 4 && currentMonth <= 9) ? .active : .dormant
        case .winter:
            self.currentState = (currentMonth >= 10 || currentMonth <= 3) ? .active : .dormant
        case .evergreen:
            self.currentState = .active
        }
    }
}

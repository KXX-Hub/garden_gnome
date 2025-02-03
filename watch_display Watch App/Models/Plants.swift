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
        
        // 根據當前月份和生長類型判斷狀態
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

// 植物預設資料
struct PlantTemplate {
    static let templates: [(String, String, GrowthType, Int, Int)] = [
        ("象牙宮", "Scindapsus", .summer, 7, 14),         // 夏型種
        ("南非龜甲龍", "Dioscorea elephantipes", .winter, 7, 30),  // 冬型種
        ("圓葉山烏龜", "Dioscorea sylvatica", .summer, 7, 30),    // 夏型種
        ("娜娜乳香", "Euphorbia leuconeura", .summer, 7, 21),     // 夏型種
        ("藍巖龍實珠", "Senecio herreianus", .summer, 10, 20)     // 夏型種
    ]
}

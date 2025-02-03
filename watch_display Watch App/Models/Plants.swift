import Foundation

struct Plant: Identifiable, Codable {
    let id: UUID
    var name: String
    var species: String
    var plantedDate: Date
    var lastWatered: Date
    var wateringInterval: Int // 以天為單位
    var notes: String
    
    init(id: UUID = UUID(), name: String, species: String, wateringInterval: Int) {
        self.id = id
        self.name = name
        self.species = species
        self.plantedDate = Date()
        self.lastWatered = Date()
        self.wateringInterval = wateringInterval
        self.notes = ""
    }
}

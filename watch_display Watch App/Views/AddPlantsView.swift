import SwiftUI

struct AddPlantView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PlantViewModel
    
    let plantOptions = [
        ("象牙宮", "Scindapsus", GrowthType.summer, 7, 14),
        ("南非龜甲龍", "Dioscorea elephantipes", GrowthType.winter, 7, 30),
        ("圓葉山烏龜", "Dioscorea sylvatica", GrowthType.summer, 7, 30),
        ("娜娜乳香", "Euphorbia leuconeura", GrowthType.summer, 7, 21),
        ("藍巖龍實珠", "Senecio herreianus", GrowthType.summer, 10, 20)
    ]
    
    @State private var selectedPlantIndex = 0
    @State private var customName = ""
    @State private var activeWateringInterval: Int
    @State private var dormantWateringInterval: Int
    
    init(viewModel: PlantViewModel) {
        self.viewModel = viewModel
        let defaultPlant = plantOptions[0]
        _activeWateringInterval = State(initialValue: defaultPlant.3)
        _dormantWateringInterval = State(initialValue: defaultPlant.4)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("植物品種") {
                    Picker("品種", selection: $selectedPlantIndex) {
                        ForEach(0..<plantOptions.count, id: \.self) { index in
                            Text(plantOptions[index].0)
                                .tag(index)
                        }
                    }
                    .onChange(of: selectedPlantIndex) { _, newValue in
                        let template = plantOptions[newValue]
                        activeWateringInterval = template.3
                        dormantWateringInterval = template.4
                    }
                }
                
                // ... 其餘部分保持不變 ...
            }
            .navigationTitle("新增植物")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("新增") { addPlant() }
                        .disabled(customName.isEmpty)
                }
            }
        }
    }
    
    private func addPlant() {
        let template = plantOptions[selectedPlantIndex]
        viewModel.addPlant(
            name: customName,
            species: template.0,
            growthType: template.2,
            activeWateringInterval: activeWateringInterval,
            dormantWateringInterval: dormantWateringInterval
        )
        dismiss()
    }
}

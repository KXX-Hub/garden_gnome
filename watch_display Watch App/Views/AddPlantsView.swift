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
    
    // 初始化時設定預設值
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
                    .onChange(of: selectedPlantIndex) { newValue in
                        // 當選擇不同植物時，更新預設澆水週期
                        let template = plantOptions[newValue]
                        activeWateringInterval = template.3
                        dormantWateringInterval = template.4
                    }
                }
                
                Section("植物暱稱") {
                    TextField("為您的植物取個名字", text: $customName)
                }
                
                let template = plantOptions[selectedPlantIndex]
                Section("澆水設定") {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("生長類型：\(template.2.rawValue)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("生長期澆水:")
                            .font(.caption2)
                        Spacer()
                        Text("\(activeWateringInterval) 天")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Stepper("", value: $activeWateringInterval, in: 1...30)
                    .scaleEffect(0.8)
                        
                    HStack {
                        Text("休眠期澆水:")
                            .font(.caption2)
                        Spacer()
                        Text("\(dormantWateringInterval) 天")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Stepper("", value: $dormantWateringInterval, in: 1...60)
                    .scaleEffect(0.8)
                }
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

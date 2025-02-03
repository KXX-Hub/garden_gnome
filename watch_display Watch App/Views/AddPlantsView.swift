import SwiftUI

struct AddPlantView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PlantViewModel
    
    @State private var plantName = ""
    @State private var species = ""
    @State private var wateringInterval = 7
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("植物資訊")) {
                    TextField("植物名稱", text: $plantName)
                    TextField("品種", text: $species)
                }
                
                Section(header: Text("澆水設定")) {
                    Stepper("澆水間隔: \(wateringInterval) 天",
                           value: $wateringInterval,
                           in: 1...30)
                }
            }
            .navigationTitle("新增植物")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("新增") {
                        addPlant()
                    }
                    .disabled(plantName.isEmpty)
                }
            }
        }
    }
    
    private func addPlant() {
        viewModel.addPlant(
            name: plantName,
            species: species,
            wateringInterval: wateringInterval
        )
        dismiss()
    }
}

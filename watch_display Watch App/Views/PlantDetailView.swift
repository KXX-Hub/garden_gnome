import SwiftUI

struct PlantDetailView: View {
    @ObservedObject var viewModel: PlantViewModel
    let plant: Plant
    @State private var showingStateAlert = false
    @State private var showingWarning = false
    
    var isWrongGrowthState: Bool {
        let currentMonth = Calendar.current.component(.month, from: Date())
        switch plant.growthType {
        case .winter:
            return plant.currentState == .active && (currentMonth >= 4 && currentMonth <= 9)
        case .summer:
            return plant.currentState == .active && (currentMonth >= 10 || currentMonth <= 3)
        case .evergreen:
            return false
        }
    }
    
    var body: some View {
        List {
            Section("基本資訊") {
                LabeledContent("名稱", value: plant.name)
                    .font(.footnote)
                LabeledContent("品種", value: plant.species)
                    .font(.footnote)
                LabeledContent("種植日期", value: plant.plantedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.footnote)
            }
            
            Section("生長狀態") {
                LabeledContent("生長類型", value: plant.growthType.rawValue)
                    .font(.footnote)
                HStack {
                    Text("目前狀態").font(.footnote)
                    Spacer()
                    Text(plant.currentState.rawValue)
                        .font(.footnote)
                        .foregroundColor(isWrongGrowthState ? .red : .primary)
                }
                
                Button(action: {
                    showingStateAlert = true
                }) {
                    Text("切換生長狀態")
                        .font(.caption)
                }
                
                if isWrongGrowthState {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                            .imageScale(.small)
                        Text("現在季節與生長狀態不符")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section("澆水資訊") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("目前週期：\(plant.currentWateringInterval) 天")
                        .font(.footnote)
                        
                    VStack(alignment: .leading, spacing: 2) {
                        Text("澆水間隔")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        HStack {
                            Text("生長期:")
                                .font(.caption2)
                            Text("\(plant.activeWateringInterval)天")
                                .font(.caption2)
                            Spacer()
                            Text("休眠期:")
                                .font(.caption2)
                            Text("\(plant.dormantWateringInterval)天")
                                .font(.caption2)
                        }
                        .foregroundColor(.secondary)
                    }
                }
                
                Button(action: {
                    viewModel.waterPlant(plant)
                }) {
                    Label("現在澆水", systemImage: "drop.fill")
                        .font(.footnote)
                }
                .tint(.blue)
            }
        }
        .navigationTitle("植物詳情")
        .alert("切換生長狀態", isPresented: $showingStateAlert) {
            Button("取消", role: .cancel) { }
            Button(plant.currentState == .active ? "進入休眠期" : "開始生長期") {
                viewModel.togglePlantState(plant)
                if isWrongGrowthState {
                    showingWarning = true
                }
            }
        } message: {
            Text("確定要切換\(plant.name)的生長狀態嗎？這會改變澆水週期。")
                .font(.caption)
        }
        .alert("生長狀態警告", isPresented: $showingWarning) {
            Button("我知道了", role: .cancel) { }
        } message: {
            Text("目前的季節與\(plant.name)的生長狀態不符，請注意觀察植物狀況。")
                .font(.caption)
        }
    }
}

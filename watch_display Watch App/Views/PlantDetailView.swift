import SwiftUI

struct PlantDetailView: View {
    @ObservedObject var viewModel: PlantViewModel
    let plant: Plant
    @State private var showingStateAlert = false
    @State private var showingWarning = false
    @State private var activeInterval: Int
    @State private var dormantInterval: Int
    
    init(viewModel: PlantViewModel, plant: Plant) {
        self.viewModel = viewModel
        self.plant = plant
        _activeInterval = State(initialValue: plant.activeWateringInterval)
        _dormantInterval = State(initialValue: plant.dormantWateringInterval)
    }
    
    var isWrongGrowthState: Bool {
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
    
    var shouldShowWarningAfterToggle: Bool {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let willBeActive = plant.currentState == .dormant
        
        switch plant.growthType {
        case .winter:
            if willBeActive {
                return currentMonth >= 4 && currentMonth <= 9
            } else {
                return currentMonth >= 10 || currentMonth <= 3
            }
        case .summer:
            if willBeActive {
                return currentMonth >= 10 || currentMonth <= 3
            } else {
                return currentMonth >= 4 && currentMonth <= 9
            }
        case .evergreen:
            return false
        }
    }
    
    var body: some View {
        List {
            Section("基本資訊") {
                LabeledContent("名稱", value: plant.name)
                    .font(.system(size: 14))
                LabeledContent("品種", value: plant.species)
                    .font(.system(size: 14))
                LabeledContent("種植日期", value: plant.plantedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 14))
            }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
            )
            
            Section("生長狀態") {
                LabeledContent("生長類型", value: plant.growthType.rawValue)
                    .font(.system(size: 14))
                HStack {
                    Text("目前狀態").font(.system(size: 14))
                    Spacer()
                    Text(plant.currentState.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(isWrongGrowthState ? .red : .primary)
                }
                
                Button(action: {
                    showingStateAlert = true
                }) {
                    Label("切換生長狀態", systemImage: "arrow.triangle.2.circlepath")
                        .font(.system(size: 14))
                }
                .buttonStyle(.plain)
                
                if isWrongGrowthState {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                            .imageScale(.small)
                        Text("現在季節與生長狀態不符")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.3))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
            )
            
            Section("澆水資訊") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("目前週期：\(plant.currentWateringInterval) 天")
                        .font(.system(size: 14))
                    
                    Text("澆水間隔")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 12) {
                        // 生長期
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("生長期:")
                                    .font(.system(size: 14))
                                Text("\(activeInterval)天")
                                    .font(.system(size: 14))
                                Spacer()
                                Button(action: {
                                    if activeInterval > 1 {
                                        activeInterval -= 1
                                        viewModel.updateWateringIntervals(plant, active: activeInterval, dormant: dormantInterval)
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 24))
                                }
                                .buttonStyle(.plain)
                                
                                Button(action: {
                                    if activeInterval < 30 {
                                        activeInterval += 1
                                        viewModel.updateWateringIntervals(plant, active: activeInterval, dormant: dormantInterval)
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.system(size: 24))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                        }
                        
                        // 休眠期
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("休眠期:")
                                    .font(.system(size: 14))
                                Text("\(dormantInterval)天")
                                    .font(.system(size: 14))
                                Spacer()
                                Button(action: {
                                    if dormantInterval > 1 {
                                        dormantInterval -= 1
                                        viewModel.updateWateringIntervals(plant, active: activeInterval, dormant: dormantInterval)
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 24))
                                }
                                .buttonStyle(.plain)
                                
                                Button(action: {
                                    if dormantInterval < 60 {
                                        dormantInterval += 1
                                        viewModel.updateWateringIntervals(plant, active: activeInterval, dormant: dormantInterval)
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.system(size: 24))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                        }
                    }
                }
                
                Button(action: {
                    viewModel.waterPlant(plant)
                }) {
                    Label("現在澆水", systemImage: "drop.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .padding(.top, 8)
            }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.1))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
            )
        }
        .navigationBarTitle("植物詳情")
        .alert("切換生長狀態", isPresented: $showingStateAlert) {
            Button("取消", role: .cancel) { }
            Button(plant.currentState == .active ? "進入休眠期" : "開始生長期") {
                viewModel.togglePlantState(plant)
                if shouldShowWarningAfterToggle {
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

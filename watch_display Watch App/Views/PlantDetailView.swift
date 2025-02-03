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
               
               Button(action: { showingStateAlert = true }) {
                   Label("切換生長狀態", systemImage: "arrow.triangle.2.circlepath")
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
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.3))
                    .padding(2)
            )
            
            Section("澆水資訊") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("目前週期：\(plant.currentWateringInterval) 天")
                        .font(.footnote)
                    
                    Text("澆水間隔")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("生長期: ")
                                .font(.caption2)
                            Text("\(activeInterval)天")
                                .font(.caption2)
                                .frame(minWidth: 40, alignment: .leading)
                            Spacer()
                            HStack {
                                CircleButton("-") {
                                    if activeInterval > 1 { activeInterval -= 1 }
                                }
                                CircleButton("+") {
                                    if activeInterval < 30 { activeInterval += 1 }
                                }
                            }
                            .onChange(of: activeInterval) { newValue in
                                viewModel.updateWateringIntervals(plant, active: newValue, dormant: dormantInterval)
                            }
                        }
                        
                        HStack {
                            Text("休眠期: ")
                                .font(.caption2)
                            Text("\(dormantInterval)天")
                                .font(.caption2)
                                .frame(minWidth: 40, alignment: .leading)
                            Spacer()
                            HStack {
                                CircleButton("-") {
                                    if dormantInterval > 1 { dormantInterval -= 1 }
                                }
                                CircleButton("+") {
                                    if dormantInterval < 60 { dormantInterval += 1 }
                                }
                            }
                            .onChange(of: dormantInterval) { newValue in
                                viewModel.updateWateringIntervals(plant, active: activeInterval, dormant: newValue)
                            }
                        }
                    }
                }
                
                Button(action: {
                      viewModel.waterPlant(plant)
                  }) {
                      Label("現在澆水", systemImage: "drop.circle.fill")
                          .font(.footnote)
                  }
                  .tint(.blue)
               }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.1))
                    .padding(2)
            )
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

struct CircleButton: View {
   let symbol: String
   let action: () -> Void
   
   init(_ symbol: String, action: @escaping () -> Void) {
       self.symbol = symbol
       self.action = action
   }
   
   var body: some View {
       Button(action: action) {
           Circle()
               .fill(symbol == "-" ? Color.red.opacity(0.5) : Color.green.opacity(0.5))
               .frame(width: 24, height: 24)
               .overlay(
                   Text(symbol)
                       .font(.system(size: 16, weight: .medium))
                       .foregroundColor(.primary)
               )
       }
   }
}

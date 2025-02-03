import SwiftUI

struct PlantListView: View {
    @StateObject private var viewModel = PlantViewModel()
    @State private var showingAddPlant = false
    
    var body: some View {
        List {
            ForEach(viewModel.plants) { plant in
                PlantRowView(viewModel: viewModel, plant: plant)
            }
            .onDelete(perform: viewModel.removePlant)
        }
        .navigationTitle("我的植物")
        .toolbar {
            Button(action: { showingAddPlant = true }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddPlant) {
            AddPlantView(viewModel: viewModel)
        }
    }
}

struct PlantListView_Previews: PreviewProvider {
   static var previews: some View {
       PlantListView()
   }
}

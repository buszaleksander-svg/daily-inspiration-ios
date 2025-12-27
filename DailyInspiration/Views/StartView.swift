import SwiftUI

struct StartView: View {
    var body: some View {
        VStack {
            Image(systemName: "sun.max")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("Daily Inspiration")
                .font(.title)
                .padding(.top, 8)
        }
        .padding()
    }
}

#Preview {
    StartView()
}


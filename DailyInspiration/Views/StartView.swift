import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                
                Image(systemName: "sun.max")
                    .imageScale(.large)
                    .foregroundStyle(.tint)

                Text("Daily Inspiration")
                    .font(.title)
                    .padding(.top, 8)

                Text("A small daily moment of calm and inspiration.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                NavigationLink {
                    InspirationView()
                } label: {
                    Text("Get today’s inspiration")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor.opacity(0.15))
                        .cornerRadius(12)
                }
                .padding(.top, 24)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    StartView()
}


import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationStack {
            ZStack {

                // MARK: - Background (light, calm, premium)
                LinearGradient(
                    colors: [
                        Color(red: 245/255, green: 242/255, blue: 250/255), // soft off-white
                        Color(red: 220/255, green: 214/255, blue: 235/255), // light lavender
                        Color(red: 190/255, green: 180/255, blue: 215/255)  // calm violet
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 32) {

                    Spacer()

                    // MARK: - Title
                    VStack(spacing: 4) {
                        Text("Daily")
                            .font(.system(size: 40, weight: .semibold, design: .serif))
                            .foregroundColor(.primary)

                        Text("Inspiration")
                            .font(.system(size: 40, weight: .semibold, design: .serif))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color.purple,
                                        Color.blue
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }

                    // MARK: - Subtitle
                    Text("One thought. One moment. Just for you.")
                        .font(.system(size: 16, design: .serif))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    Spacer()

                    // MARK: - CTA Button
                    NavigationLink(destination: InspirationView()) {
                        Text("Inspire me")
                            .font(.system(size: 14, weight: .semibold, design: .serif))
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 48)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color.purple,
                                        Color.blue
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Capsule())
                    }

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    StartView()
}


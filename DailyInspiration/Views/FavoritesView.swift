import SwiftUI
import UserNotifications

struct FavoritesView: View {

    @AppStorage("favoriteQuoteIDs") private var favoriteIDsData: Data = Data()
    @State private var favoriteIDs: [QuoteID] = []

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 245/255, green: 242/255, blue: 250/255),
                    Color(red: 220/255, green: 214/255, blue: 235/255),
                    Color(red: 190/255, green: 180/255, blue: 215/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer(minLength: 10)

                VStack(spacing: 16) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.purple, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("Favorites")
                        .font(.system(size: 22, weight: .semibold, design: .serif))

                    
                    Button("Enable Daily Inspiration") {
                        enableDailyNotification()
                    }
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(colors: [Color.purple, Color.blue],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(14)

                    favoritesContent
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, 30)

                Spacer(minLength: 10)
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { EditButton() }
        .onAppear { loadFavoriteIDs() }
        .onChange(of: favoriteIDsData) { _ in loadFavoriteIDs() }
    }

    @ViewBuilder
    private var favoritesContent: some View {
        if favoriteIDs.isEmpty {
            VStack(spacing: 10) {
                Text("No favorites yet.")
                    .font(.system(size: 16, design: .serif))
                    .foregroundColor(.secondary)

                Text("Save quotes you love and they’ll appear here.")
                    .font(.system(size: 14, design: .serif))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
            .padding(.top, 6)
        } else {
            List {
                ForEach(favoriteIDs, id: \.self) { id in
                    if let item = inspirationalQuotes[id] {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("“\(item.quote)”")
                                .font(.system(size: 16, weight: .medium, design: .serif))

                            Text("— \(item.author)")
                                .font(.system(size: 14, design: .serif))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color.white.opacity(0.0))
                    } else {
                        Text("Quote not found.")
                            .font(.system(size: 14, design: .serif))
                            .foregroundColor(.secondary)
                            .padding(.vertical, 8)
                            .listRowBackground(Color.white.opacity(0.0))
                    }
                }
                .onDelete(perform: deleteFavorites)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .frame(height: 360)
            .padding(.top, 4)
        }
    }

    private func loadFavoriteIDs() {
        guard !favoriteIDsData.isEmpty else {
            favoriteIDs = []
            return
        }
        favoriteIDs = (try? JSONDecoder().decode([QuoteID].self, from: favoriteIDsData)) ?? []
    }

    private func saveFavoriteIDs(_ ids: [QuoteID]) {
        favoriteIDsData = (try? JSONEncoder().encode(ids)) ?? Data()
    }

    private func deleteFavorites(at offsets: IndexSet) {
        favoriteIDs.remove(atOffsets: offsets)
        saveFavoriteIDs(favoriteIDs)
    }

    
    
    private func enableDailyNotification() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }

            guard let random = inspirationalQuotes.randomElement() else { return }
            let item = random.value

            let content = UNMutableNotificationContent()
            content.title = "Daily Inspiration"
            content.body = "“\(item.quote)” — \(item.author)"
            content.sound = .default

            var date = DateComponents()
            date.hour = 9
            date.minute = 0

            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

            let request = UNNotificationRequest(
                identifier: "daily_inspiration",
                content: content,
                trigger: trigger
            )

            center.removePendingNotificationRequests(withIdentifiers: ["daily_inspiration"])
            center.add(request)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}

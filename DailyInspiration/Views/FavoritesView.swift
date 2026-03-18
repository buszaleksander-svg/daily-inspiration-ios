import SwiftUI

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
        .onChange(of: favoriteIDsData) { _ in
            loadFavoriteIDs()
        }
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
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(favoriteIDs, id: \.self) { id in
                        if let item = quote(for: id) {
                            favoriteRow(for: item)
                        } else {
                            missingQuoteRow()
                        }

                        Divider()
                            .padding(.horizontal, 2)
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(height: 360)
            .padding(.top, 4)
        }
    }

    private func favoriteRow(for item: Quote) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("“\(item.text)”")
                .font(.system(size: 16, weight: .medium, design: .serif))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text("— \(item.author)")
                .font(.system(size: 14, design: .serif))
                .foregroundColor(.secondary)

            Text(item.category.rawValue)
                .font(.system(size: 12, weight: .semibold, design: .serif))
                .foregroundColor(.purple)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .swipeActions(edge: .trailing) {
            if let index = favoriteIDs.firstIndex(of: item.id) {
                Button(role: .destructive) {
                    deleteFavorite(at: index)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }

    private func missingQuoteRow() -> some View {
        Text("Quote not found.")
            .font(.system(size: 14, design: .serif))
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 14)
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

    private func deleteFavorite(at index: Int) {
        guard favoriteIDs.indices.contains(index) else { return }
        favoriteIDs.remove(at: index)
        saveFavoriteIDs(favoriteIDs)
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}

//
//  HistoryView.swift
//  DailyInspirationApp.swift
//
//  Created by Mats Rune Bergman on 2026-01-30.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text("History")
                .font(.largeTitle)

            historySection

            HStack(spacing: 16) {
                NavigationLink("Inspiration") {
                    InspirationView()
                }
                NavigationLink("Favorites") {
                    FavoritesView()
                }
            }
        }
        .padding()
        .navigationTitle("History")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink {
                    FavoritesView()
                } label: {
                    Image(systemName: "star")
                }

                NavigationLink {
                    InspirationView()
                } label: {
                    Image(systemName: "sun.max")
                }
            }
        }
    }

    @ViewBuilder
    private var historySection: some View {
        if inspirationalQuotes.isEmpty {
            Text("No previously seen inspirations yet.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } else {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(inspirationalQuotes.keys.sorted(), id: \.self) { id in
                    if let item = inspirationalQuotes[id] {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("“\(item.quote)”")
                                .font(.body)
                            Text("— \(item.author)")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack { HistoryView() }
}

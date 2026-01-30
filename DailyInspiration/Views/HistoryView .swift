//
//  HistoryView.swift
//  my-own-playapp
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

            Text("Previously seen inspirations could appear here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

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
}

#Preview {
    NavigationStack { HistoryView() }
}

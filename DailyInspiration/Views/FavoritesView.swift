//
//  FavoritesView.swift
//  DailyInspiration
//
//  Created by Aleksander Busz Fabritius on 2025-12-27.
//

import Foundation
import SwiftUI

struct FavoritesView: View {
    
    @AppStorage("favoriteQuoteIDs") private var favoriteIDsData: Data = Data()
    

    
    var body: some View {
        VStack {
            Text("Favorites")
                .font(.largeTitle)
                .padding()
            
            
            if favoriteIDs.isEmpty {
                Text("No Favorites yet.")
            } else {
                List {
                    ForEach(favoriteIDs, id: \.self) { id in
                        if let item = inspirationalQuotes[id] {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("“\(item.quote)”")
                                Text("— \(item.author)")
                            }
                            .padding(.vertical, 4)
                        } else {
                            Text("Quote not found.")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deleteFavorites)
                }
            }
            
            // DEBUG BUTTON – remove before final submission
            Button("DEBUG: Add random favorite") {
                addDummyFavorite()
            }
            .padding(.top, 12)

            
        }
        .navigationTitle("Favorites")
        .toolbar { EditButton ()
        }
    }


// Read favorites from storage
private var favoriteIDs: [QuoteID] {
    guard !favoriteIDsData.isEmpty else {
        return []
    }
    return (try? JSONDecoder().decode([QuoteID].self, from: favoriteIDsData)) ?? []
    }

// Save favorites to storage
    private func saveFavoriteIDs(_ ids: [QuoteID]) {
           favoriteIDsData = (try? JSONEncoder().encode(ids)) ?? Data()
       }

    private func deleteFavorites(at offsets: IndexSet) {
        var ids = favoriteIDs
        ids.remove(atOffsets: offsets)
        saveFavoriteIDs(ids)
    }
    
    // DEBUG ONLY – remove later
    private func addDummyFavorite() {
        guard let randomID = inspirationalQuotes.randomElement()?.key else {
            return
        }

        var ids = favoriteIDs
        ids.append(randomID)
        saveFavoriteIDs(ids)
    }

}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}

//
//  HistoryView.swift
//  DailyInspirationApp.swift
//
//  Created by Mats Rune Bergman on 2026-01-30.
//

/*
 This HistoryView displays an ordered list of the inspirational quotes that has been randomly presented by the InspirationView, provided that InspirationView contains the necessary code.
 
 The most recent inspirational quote is listed first. ScrollView with LazyVStack permits the list to grow.
 
 Persistence is achieved via @AppStorage in HistoryView and @State in InspirationView.
 
 To make the code more readable I have employed @ViewBuilder.
 
 For reference I have included the code for InspirationView that I have tested and verified that it works with this implementation of @AppStorage. Please see the blockquote in the end of the file.
 
 // Mats
 
 */


import SwiftUI

struct HistoryView: View {
    // Ordered history persisted by InspirationView (JSON-encoded [QuoteID])
    @AppStorage("seenQuoteHistory") private var seenHistoryData: Data = Data()

    var body: some View {
        ScrollView {
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
            .frame(maxWidth: .infinity, alignment: .top)
        }
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

    // Decode ordered IDs (most recent first).
    private var seenHistoryIDs: [QuoteID] {
        guard !seenHistoryData.isEmpty else { return [] }
        do {
            return try JSONDecoder().decode([QuoteID].self, from: seenHistoryData)
        } catch {
            return []
        }
    }

    @ViewBuilder
    private var historySection: some View {
        let ids = seenHistoryIDs
        if ids.isEmpty {
            Text("No previously seen inspirations yet.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            LazyVStack(alignment: .leading, spacing: 8) {
                ForEach(ids, id: \.self) { id in
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack { HistoryView() }
}


/*
 
 
 
 
 import SwiftUI
 import Foundation

 struct InspirationView: View {
     @State private var selectedID: QuoteID?

     // Ordered history (most recent first), persisted as JSON-encoded [QuoteID].
     @AppStorage("seenQuoteHistory") private var seenHistoryData: Data = Data()

     var body: some View {
         VStack(spacing: 24) {
             Text("Inspiration screen (placeholder)")
                 .font(.title)

             quoteSection

             // Quick links to related screens
             HStack(spacing: 16) {
                 NavigationLink("Favorites") {
                     FavoritesView()
                 }
                 NavigationLink("History") {
                     HistoryView()
                 }
             }
         }
         .padding()
         .frame(maxWidth: .infinity, maxHeight: .infinity)
         .navigationTitle("Inspiration")
         .toolbar {
             ToolbarItemGroup(placement: .topBarTrailing) {
                 NavigationLink {
                     FavoritesView()
                 } label: {
                     Image(systemName: "star")
                 }

                 NavigationLink {
                     HistoryView()
                 } label: {
                     Image(systemName: "clock")
                 }
             }
         }
         .onAppear {
             if selectedID == nil {
                 if let random = inspirationalQuotes.randomElement() {
                     selectedID = random.key
                     // Persist in ordered history (most recent first).
                     persistSeenHistory(id: random.key)
                 }
             }
         }
         .onChange(of: selectedID) { _, newValue in
             if let id = newValue {
                 // Whenever the selection changes, record it.
                 persistSeenHistory(id: id)
             }
         }
     }

     @ViewBuilder
     private var quoteSection: some View {
         if inspirationalQuotes.isEmpty {
             Text("No quotes available.")
                 .font(.subheadline)
                 .foregroundStyle(.secondary)
         } else if let id = selectedID, let quote = inspirationalQuotes[id] {
             VStack(spacing: 8) {
                 Text("“\(quote.quote)”")
                     .font(.title3)
                     .multilineTextAlignment(.center)
                 Text("— \(quote.author)")
                     .font(.subheadline)
                     .foregroundStyle(.secondary)
             }
             .padding(.horizontal)
         } else {
             // Fallback while selecting a quote on first appear
             ProgressView()
         }
     }

     // MARK: - Ordered history (most recent first)

     private func loadSeenHistory() -> [QuoteID] {
         guard !seenHistoryData.isEmpty else { return [] }
         do {
             return try JSONDecoder().decode([QuoteID].self, from: seenHistoryData)
         } catch {
             return []
         }
     }

     private func saveSeenHistory(_ ids: [QuoteID]) {
         if let data = try? JSONEncoder().encode(ids) {
             seenHistoryData = data
         } else {
             seenHistoryData = Data()
         }
     }

     // Move-to-front, unique, most-recent-first list.
     private func persistSeenHistory(id: QuoteID) {
         var history = loadSeenHistory()
         if let existingIndex = history.firstIndex(of: id) {
             history.remove(at: existingIndex)
         }
         history.insert(id, at: 0)
         saveSeenHistory(history)
     }
 }

 #Preview {
     NavigationStack { InspirationView() }
 }

 

 */

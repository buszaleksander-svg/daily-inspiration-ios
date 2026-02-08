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
    
    // State for clear history functionality
    @State private var showClearConfirmation = false
    @State private var showClearedFeedback = false

    var body: some View {
        ZStack {
            
            // MARK: - Background (consistent with other views)
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
                
                // MARK: - History Card
                VStack(spacing: 16) {
                    
                    Image(systemName: "clock")
                        .font(.system(size: 34))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.purple, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("History")
                        .font(.system(size: 22, weight: .semibold, design: .serif))
                    
                    historyContent
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, 30)
                
                // MARK: - Clear History Button (only show if history exists)
                if !seenHistoryIDs.isEmpty {
                    Button(action: {
                        showClearConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: showClearedFeedback ? "checkmark.circle.fill" : "trash")
                            Text(showClearedFeedback ? "Cleared!" : "Clear History")
                                .font(.system(size: 16, weight: .semibold, design: .serif))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .foregroundColor(showClearedFeedback ? .green : .black)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer(minLength: 10)
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
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
                    Image(systemName: "sparkles")
                }
            }
        }
        .confirmationDialog(
            "Clear History",
            isPresented: $showClearConfirmation,
            titleVisibility: .visible
        ) {
            Button("Clear All History", role: .destructive) {
                clearHistory()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently delete all your quote history. This action cannot be undone.")
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

    // MARK: - Content inside the card
    
    @ViewBuilder
    private var historyContent: some View {
        let ids = seenHistoryIDs
        if ids.isEmpty {
            VStack(spacing: 10) {
                Text("No previously seen inspirations yet.")
                    .font(.system(size: 16, design: .serif))
                    .foregroundColor(.secondary)
                
                Text("Get inspired and your quotes will appear here.")
                    .font(.system(size: 14, design: .serif))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
            .padding(.top, 6)
        } else {
            // A "clean" list look that fits inside the card
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(ids, id: \.self) { id in
                        if let item = inspirationalQuotes[id] {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\"\(item.quote)\"")
                                    .font(.system(size: 16, weight: .medium, design: .serif))
                                    .foregroundColor(.primary)
                                
                                Text("— \(item.author)")
                                    .font(.system(size: 14, design: .serif))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(height: 360) // prevents the card from growing infinitely
            .padding(.top, 4)
        }
    }
    
    // MARK: - Clear History Functionality
    
    private func clearHistory() {
        // Clear the history data
        seenHistoryData = Data()
        
        // Show feedback
        showClearedFeedback = true
        
        // Hide feedback after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showClearedFeedback = false
        }
    }
}

#Preview {
    NavigationStack { HistoryView() }
}



/*
import SwiftUI

struct HistoryView: View {
    // Ordered history persisted by InspirationView (JSON-encoded [QuoteID])
    @AppStorage("seenQuoteHistory") private var seenHistoryData: Data = Data()

    var body: some View {
        ZStack {
            
            // MARK: - Background (consistent with other views)
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
                
                // MARK: - History Card
                VStack(spacing: 16) {
                    
                    Image(systemName: "clock")
                        .font(.system(size: 34))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.purple, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("History")
                        .font(.system(size: 22, weight: .semibold, design: .serif))
                    
                    historyContent
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
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
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
                    Image(systemName: "sparkles")
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

    // MARK: - Content inside the card
    
    @ViewBuilder
    private var historyContent: some View {
        let ids = seenHistoryIDs
        if ids.isEmpty {
            VStack(spacing: 10) {
                Text("No previously seen inspirations yet.")
                    .font(.system(size: 16, design: .serif))
                    .foregroundColor(.secondary)
                
                Text("Get inspired and your quotes will appear here.")
                    .font(.system(size: 14, design: .serif))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
            .padding(.top, 6)
        } else {
            // A "clean" list look that fits inside the card
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(ids, id: \.self) { id in
                        if let item = inspirationalQuotes[id] {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\"\(item.quote)\"")
                                    .font(.system(size: 16, weight: .medium, design: .serif))
                                    .foregroundColor(.primary)
                                
                                Text("— \(item.author)")
                                    .font(.system(size: 14, design: .serif))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(height: 360) // prevents the card from growing infinitely
            .padding(.top, 4)
        }
    }
}

#Preview {
    NavigationStack { HistoryView() }
}
*/

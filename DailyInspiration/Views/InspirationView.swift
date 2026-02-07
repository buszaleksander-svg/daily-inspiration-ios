//
//  InspirationView.swift
//  DailyInspiration
//
//  Created by Carlo on 2026-02-02. Pushed to Git 2026-02-07
//

import Foundation
import SwiftUI

struct InspirationView: View {
    
    @State private var selectedID: QuoteID?
    @State private var isAnimating = false
    @State private var showSavedFeedback = false
    
    @AppStorage("favoriteQuoteIDs") private var favoriteIDsData: Data = Data()
    @AppStorage("seenQuoteHistory") private var seenHistoryData: Data = Data()
    
    var body: some View {
        ZStack {
            
            // MARK: - Background
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
            
            VStack(spacing: 40) {
                
                Spacer()
                
                // MARK: - Quote Card
                VStack(spacing: 20) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
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
                    
                    quoteSection
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 50)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, 30)
                
                Spacer()
                
                // MARK: - Buttons
                VStack(spacing: 16) {
                    Button(action: generateNewQuote) {
                        HStack {
                            Image(systemName: "wand.and.stars")
                            Text("Get Inspired")
                                .font(.system(size: 16, weight: .semibold, design: .serif))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.purple,
                                    Color.blue
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                    
                    Button(action: saveToFavorites) {
                        HStack {
                            Image(systemName: showSavedFeedback ? "heart.fill" : "heart")
                            Text(showSavedFeedback ? "Saved!" : "Save to Favorites")
                                .font(.system(size: 16, weight: .semibold, design: .serif))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .foregroundColor(showSavedFeedback ? .pink : .purple)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .disabled(selectedID == nil)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Inspiration")
        .navigationBarTitleDisplayMode(.inline)
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
                    persistSeenHistory(id: random.key)
                }
            }
        }
    }
    
    @ViewBuilder
    private var quoteSection: some View {
        if let id = selectedID, let item = inspirationalQuotes[id] {
            VStack(spacing: 12) {
                Text("\"\(item.quote)\"")
                    .font(.system(size: 22, weight: .medium, design: .serif))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text("— \(item.author)")
                    .font(.system(size: 16, design: .serif))
                    .foregroundColor(.secondary)
            }
            .opacity(isAnimating ? 1 : 0)
            .animation(.easeIn(duration: 0.6), value: isAnimating)
        } else {
            ProgressView()
        }
    }
    
    private func generateNewQuote() {
        isAnimating = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let random = inspirationalQuotes.randomElement() {
                selectedID = random.key
                persistSeenHistory(id: random.key)
                isAnimating = true
                
                if showSavedFeedback {
                    showSavedFeedback = false
                }
            }
        }
    }
    
    private func saveToFavorites() {
        guard let id = selectedID else { return }
        
        var favorites = favoriteIDs
        
        if !favorites.contains(id) {
            favorites.append(id)
            saveFavoriteIDs(favorites)
        }
        
        showSavedFeedback = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSavedFeedback = false
        }
    }
    
    private var favoriteIDs: [QuoteID] {
        guard !favoriteIDsData.isEmpty else {
            return []
        }
        return (try? JSONDecoder().decode([QuoteID].self, from: favoriteIDsData)) ?? []
    }
    
    private func saveFavoriteIDs(_ ids: [QuoteID]) {
        favoriteIDsData = (try? JSONEncoder().encode(ids)) ?? Data()
    }
    
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
    NavigationStack {
        InspirationView()
    }
}

//
//  InspirationView.swift
//  DailyInspiration
//
//  Updated to support quote categories
//

import Foundation
import SwiftUI

struct InspirationView: View {
    
    @State private var selectedQuote: Quote?
    @State private var selectedCategory: QuoteCategory? = nil
    @State private var isAnimating = false
    @State private var showSavedFeedback = false
    
    @AppStorage("favoriteQuoteIDs") private var favoriteIDsData: Data = Data()
    @AppStorage("seenQuoteHistory") private var seenHistoryData: Data = Data()
    
    private var filteredQuotes: [Quote] {
        if let selectedCategory {
            return inspirationalQuotes.filter { $0.category == selectedCategory }
        } else {
            return inspirationalQuotes
        }
    }
    
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
            
            VStack(spacing: 24) {
                
                Spacer()
                
                // MARK: - Category Picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category")
                        .font(.system(size: 14, weight: .semibold, design: .serif))
                        .foregroundColor(.secondary)
                    
                    Picker("Category", selection: $selectedCategory) {
                        Text("All").tag(nil as QuoteCategory?)
                        
                        ForEach(QuoteCategory.allCases) { category in
                            Text(category.rawValue).tag(category as QuoteCategory?)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 30)
                
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
                    .disabled(selectedQuote == nil)
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
            if selectedQuote == nil {
                generateInitialQuote()
            }
        }
        .onChange(of: selectedCategory) { _ in
            generateInitialQuote()
        }
    }
    
    @ViewBuilder
    private var quoteSection: some View {
        if let quote = selectedQuote {
            VStack(spacing: 12) {
                Text("\"\(quote.text)\"")
                    .font(.system(size: 22, weight: .medium, design: .serif))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text("— \(quote.author)")
                    .font(.system(size: 16, design: .serif))
                    .foregroundColor(.secondary)
                
                Text(quote.category.rawValue)
                    .font(.system(size: 13, weight: .semibold, design: .serif))
                    .foregroundColor(.purple)
                    .padding(.top, 4)
            }
            .opacity(isAnimating ? 1 : 0)
            .animation(.easeIn(duration: 0.6), value: isAnimating)
        } else {
            VStack(spacing: 12) {
                Text("No quotes available in this category.")
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 30)
                
                Text("Choose another category or select All.")
                    .font(.system(size: 14, design: .serif))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func generateInitialQuote() {
        guard let random = filteredQuotes.randomElement() else {
            selectedQuote = nil
            return
        }
        
        selectedQuote = random
        persistSeenHistory(id: random.id)
        isAnimating = true
    }
    
    private func generateNewQuote() {
        isAnimating = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard let random = filteredQuotes.randomElement() else {
                selectedQuote = nil
                return
            }
            
            selectedQuote = random
            persistSeenHistory(id: random.id)
            isAnimating = true
            
            if showSavedFeedback {
                showSavedFeedback = false
            }
        }
    }
    
    private func saveToFavorites() {
        guard let id = selectedQuote?.id else { return }
        
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

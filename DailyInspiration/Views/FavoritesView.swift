//
//  FavoritesView.swift
//  DailyInspiration
//
//  Created by Aleksander Busz Fabritius on 2025-12-27.
//

import Foundation
import SwiftUI

struct FavoritesView: View {
    
    @State var favoriteQuotes: [String] = []
    
    var body: some View {
        VStack {
            Text("Favorite Quote")
                .font(.largeTitle)
                .padding()
            
            List(favoriteQuotes, id: \.self) { quote in
                Text(quote)
            }
            Button("Favorite Quote") {
                // to add a new quote in the list
                favoriteQuotes.append("You are reading the favorite quote!")
            }
            .padding()
        }
    }
}


#Preview {
    FavoritesView()
}

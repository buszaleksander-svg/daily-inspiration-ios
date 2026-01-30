//
//  inspirationalQuotes.swift
//  DailyInspiration
//
//  Added a key/value dictionary with inspirational quotes.
//  UserDefaults are fine up to circa 100 kb only.
//  Numerical keys takes less memory than the full quote.
//  /Mats
//
//  Created by Mats Rune Bergman on 2026-01-30.
//


import Foundation

public typealias QuoteID = Int

public let inspirationalQuotes: [QuoteID: (quote: String, author: String)] = [
    1: (quote: "The only way to do great work is to love what you do.", author: "Steve Jobs"),
    2: (quote: "The way to get started is to quit talking and begin doing.", author: "Walt Disney"),
    3: (quote: "The future belongs to those who believe in the beauty of their dreams.", author: "Eleanor Roosevelt"),
    4: (quote: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius"),
    5: (quote: "Life is like riding a bicycle. To keep your balance, you must keep moving.", author: "Albert Einstein"),
    6: (quote: "You will face many defeats in life, but never let yourself be defeated.", author: "Maya Angelou"),
    7: (quote: "It always seems impossible until it’s done.", author: "Nelson Mandela"),
    8: (quote: "Whether you think you can or you think you can’t, you’re right.", author: "Henry Ford"),
    9: (quote: "Don’t watch the clock; do what it does. Keep going.", author: "Unknown"),
    10: (quote: "Setting goals is the first step in turning the invisible into the visible.", author: "Tony Robbins")
]


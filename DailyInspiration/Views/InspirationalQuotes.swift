//
//  InspirationalQuotes.swift
//  DailyInspiration
//
//  Updated to use a safer and more scalable quote model
//  with categories.
//

import Foundation

public typealias QuoteID = Int

public enum QuoteCategory: String, CaseIterable, Identifiable, Codable {
    case motivation = "Motivation"
    case success = "Success"
    case dreams = "Dreams"
    case perseverance = "Perseverance"
    case life = "Life"
    case courage = "Courage"
    case mindset = "Mindset"

    public var id: String { rawValue }
}

public struct Quote: Identifiable, Codable, Equatable {
    public let id: QuoteID
    public let text: String
    public let author: String
    public let category: QuoteCategory
}

public let inspirationalQuotes: [Quote] = [
    Quote(id: 1, text: "The only way to do great work is to love what you do.", author: "Steve Jobs", category: .success),
    Quote(id: 2, text: "The way to get started is to quit talking and begin doing.", author: "Walt Disney", category: .motivation),
    Quote(id: 3, text: "The future belongs to those who believe in the beauty of their dreams.", author: "Eleanor Roosevelt", category: .dreams),
    Quote(id: 4, text: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius", category: .perseverance),
    Quote(id: 5, text: "Life is like riding a bicycle. To keep your balance, you must keep moving.", author: "Albert Einstein", category: .life),
    Quote(id: 6, text: "You will face many defeats in life, but never let yourself be defeated.", author: "Maya Angelou", category: .courage),
    Quote(id: 7, text: "It always seems impossible until it’s done.", author: "Nelson Mandela", category: .perseverance),
    Quote(id: 8, text: "Whether you think you can or you think you can’t, you’re right.", author: "Henry Ford", category: .mindset),
    Quote(id: 9, text: "Don’t watch the clock; do what it does. Keep going.", author: "Unknown", category: .motivation),
    Quote(id: 10, text: "Setting goals is the first step in turning the invisible into the visible.", author: "Tony Robbins", category: .success),
    Quote(id: 11, text: "Believe you can and you're halfway there.", author: "Theodore Roosevelt", category: .motivation),
    Quote(id: 12, text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill", category: .success),
    Quote(id: 13, text: "Dream big and dare to fail.", author: "Norman Vaughan", category: .dreams),
    Quote(id: 14, text: "Act as if what you do makes a difference. It does.", author: "William James", category: .motivation),
    Quote(id: 15, text: "Keep your face always toward the sunshine—and shadows will fall behind you.", author: "Walt Whitman", category: .mindset),
    Quote(id: 16, text: "Hardships often prepare ordinary people for an extraordinary destiny.", author: "C.S. Lewis", category: .courage),
    Quote(id: 17, text: "Do one thing every day that scares you.", author: "Eleanor Roosevelt", category: .courage),
    Quote(id: 18, text: "What lies behind us and what lies before us are tiny matters compared to what lies within us.", author: "Ralph Waldo Emerson", category: .mindset),
    Quote(id: 19, text: "The secret of getting ahead is getting started.", author: "Mark Twain", category: .motivation),
    Quote(id: 20, text: "Our greatest glory is not in never falling, but in rising every time we fall.", author: "Confucius", category: .perseverance)
]

func quote(for id: QuoteID) -> Quote? {
    inspirationalQuotes.first { $0.id == id }
}

//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Andrei on 13.11.2022.
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
            return lhs.correct < rhs.correct
        }
}

protocol StatisticService {
    
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
}

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var totalAccuracy: Double {
        get {
            return Double(totalScore) / Double(gamesCount) * 10.0
        }
    }
    
    var gamesCount: Int {
        get { userDefaults.integer(forKey: Keys.gamesCount.rawValue) }
        set { userDefaults.set(newValue,  forKey: Keys.gamesCount.rawValue) }
    }
    
    var bestGame: GameRecord {
            get {
                guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                      let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                    return .init(correct: 0, total: 0, date: Date())
                }
                
                return record
            }
            
            set {
                guard let data = try? JSONEncoder().encode(newValue) else {
                    print("Невозможно сохранить результат")
                    return
                }
                
                userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            }
        }
    
    var totalScore: Int {
            get { userDefaults.integer(forKey: Keys.total.rawValue) }
            set { userDefaults.set(newValue,  forKey: Keys.total.rawValue) }
        }
    
    func store(correct count: Int, total amount: Int) {
            gamesCount += 1
            totalScore += count
            
            let currentGameRecord = GameRecord(correct: count, total: amount, date: Date())
            let lastGamesRecord = bestGame
            if lastGamesRecord < currentGameRecord {
                bestGame = currentGameRecord
            }
        }
}

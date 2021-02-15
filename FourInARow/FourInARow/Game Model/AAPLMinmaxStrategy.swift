//
//  AAPLMinmaxStrategy.swift
//  FourInARow
//

import UIKit
import GameplayKit

private let AAPLCountToWin = 4

class AAPLMove: NSObject, GKGameModelUpdate {
    
    // Required by GKGameModelUpdate for storing move ratings during GKMinmaxStrategist move selection.
    var value = 0
    // Identifies the column in which to make a move.
    var column = 0
    
    init(column: Int) {
        super.init()
        self.column = column
    }
    
    class func move(in column: Int) -> AAPLMove? {
        AAPLMove(column: column)
    }
    
}

extension AAPLPlayer: GKGameModelPlayer {
    var playerId: Int {
        self.chip.rawValue
    }
    
}

extension AAPLBoard: GKGameModel {
    
    // MARK: - Managing players
    
    var players: [GKGameModelPlayer]? {
        return AAPLPlayer.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
    // MARK: - Copying board state
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = AAPLBoard()
        copy.setGameModel(self)
        return copy
    }
    
    func setGameModel(_ gameModel: GKGameModel) {
        guard let board = gameModel as? AAPLBoard else { fatalError() }
        updateChips(from: board)
        currentPlayer = board.currentPlayer
    }
    
    // MARK: - Finding & applying moves
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        var moves = [AAPLMove]()
        for column in 0..<AAPLBoard.width {
            if canMove(in: column) {
                moves.append(AAPLMove.move(in: column)!)
            }
        }
        // Will be empty if isFull.
        return moves
    }
    
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard let move = gameModelUpdate as? AAPLMove else { fatalError() }
        add(currentPlayer.chip, in: move.column)
        currentPlayer = currentPlayer.opponent!
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? AAPLPlayer else { fatalError() }
        // Use AAPLBoard's utility method to find all N-in-a-row runs of the player's chip.
        let runCounts = self.runCounts(for: player)
        
        // The player wins if there are any runs of 4 (or more, but that shouldn't happen in a regular game).
        let longestRun = runCounts.max()
        return longestRun ?? 0 >= Int(AAPLCountToWin)
    }
    
    
    
    func isLoss(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? AAPLPlayer else { fatalError() }
        // This is a two-player game, so a win for the opponent is a loss for the player.
        return isWin(for: player.opponent!)
    }
    
    func score(for player: GKGameModelPlayer) -> Int {
        let thePlayer = player as! AAPLPlayer
        /*
        Heuristic: the chance of winning soon is related to the number and length
        of N-in-a-row runs of chips. For example, a player with two runs of two chips each
        is more likely to win soon than a player with no runs.

        Scoring should weigh the player's chance of success against that of failure,
        which in a two-player game means success for the opponent. Sum the player's number
        and size of runs, and subtract from it the same score for the opponent.

        This is not the best possible heuristic for Four-In-A-Row, but it produces
        moderately strong gameplay. Try these improvements:
        - Account for "broken runs"; e.g. a row of two chips, then a space, then a third chip.
        - Weight the run lengths; e.g. two runs of three is better than three runs of two.
        */

        // Use AAPLBoard's utility method to find all runs of the player's chip and sum their length.
        let playerRunCounts = self.runCounts(for: thePlayer)
        if playerRunCounts.max() ?? 0 >= AAPLCountToWin { return 9999 } //###
        let playerTotal = playerRunCounts.map{ $0 * $0 }.reduce(0, +) //###

        // Repeat for the opponent's chip.
        let opponentRunCounts = self.runCounts(for: thePlayer)
        if opponentRunCounts.max() ?? 0 >= AAPLCountToWin { return -9999 } //###
        let opponentTotal = opponentRunCounts.map{ $0 * $0 }.reduce(0, +) //###

        // Return the sum of player runs minus the sum of opponent runs.
        return playerTotal - opponentTotal
    }
    
}



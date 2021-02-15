//
//  AAPLBoard.swift
//  FourInARow
//

import UIKit
import GameplayKit

private let AAPLCountToWin = 4

class AAPLBoard: NSObject {
    
    static var width = 7
    static var height = 6
    
    var currentPlayer: AAPLPlayer
    
    var cells = [AAPLChip](repeating: .none, count: AAPLBoard.width * AAPLBoard.height)
    
    override var debugDescription: String {
        var output = ""
        
        var row = Int(AAPLBoard.height) - 1
        while row >= 0 {
            for column in 0 ..< AAPLBoard.width {
                let chip = self.chip(inColumn: column, row: row)
                
                let playerDescription = AAPLPlayer.player(for: chip)?.debugDescription ?? " "
                
                output += playerDescription
                
                let cellDescription = (column + 1 < AAPLBoard.width) ? "." : ""
                output += cellDescription
            }
            
            output += (row > 0) ? "\n" : ""
            row -= 1
        }
        
        return output
    }
    
    override init() {
        currentPlayer = AAPLPlayer.red
        super.init()
        
    }
    
    func updateChips(from otherBoard: AAPLBoard) {
        self.cells = otherBoard.cells
    }
    
    func chip(inColumn column: Int, row: Int) -> AAPLChip {
        return cells[row + (column * AAPLBoard.height)]
    }
    
    func set(_ chip: AAPLChip, inColumn column: Int, row: Int) {
        cells[row + column * Int(AAPLBoard.height)] = chip
    }
    
    func nextEmptySlot(in column: Int) -> Int? {
        for row in 0..<Int(AAPLBoard.height) {
            if chip(inColumn: column, row: row) == .none {
                return row
            }
        }
        
        return nil
    }
    
    func canMove(in column: Int) -> Bool {
        return nextEmptySlot(in: column) != nil
    }
    
    func add(_ chip: AAPLChip, in column: Int) {
        if let row = nextEmptySlot(in: column) {
            set(chip, inColumn: column, row: row)
        }
    }
    
    func isFull() -> Bool {
        for column in 0..<Int(AAPLBoard.width) {
            if canMove(in: column) {
                return false
            }
        }
        
        return true
    }
    
    func runCounts(for player: AAPLPlayer) -> [Int] {
        
        let chip = player.chip
        var counts: [Int] = []
        
        // Detect horizontal runs.
        for row in 0..<Int(AAPLBoard.height) {
            var runCount = 0
            for column in 0..<Int(AAPLBoard.width) {
                if self.chip(inColumn: column, row: row) == chip {
                    runCount += 1
                } else {
                    // Run isn't continuing, note it and reset counter.
                    if runCount > 0 {
                        counts.append(runCount)
                    }
                    runCount = 0
                }
            }
            if runCount > 0 {
                // Note the run if still on one at the end of the row.
                counts.append(runCount)
            }
        }
        
        // Detect vertical runs.
        for column in 0..<Int(AAPLBoard.width) {
            var runCount = 0
            for row in 0..<Int(AAPLBoard.height) {
                if self.chip(inColumn: column, row: row) == chip {
                    runCount += 1
                } else {
                    // Run isn't continuing, note it and reset counter.
                    if runCount > 0 {
                        counts.append(runCount)
                    }
                    runCount = 0
                }
            }
            if runCount > 0 {
                // Note the run if still on one at the end of the column.
                counts.append(runCount)
            }
        }
        
        // Detect diagonal (northeast) runs
        for startColumn in Int(-AAPLBoard.height)..<Int(AAPLBoard.width) {
            // Start from off the edge of the board to catch all the diagonal lines through it.
            var runCount = 0
            for offset in 0..<Int(AAPLBoard.height) {
                let column = startColumn + offset
                if column < 0 || column >= Int(AAPLBoard.width) {
                    continue // Ignore areas that aren't on the board.
                }
                if self.chip(inColumn: column, row: offset) == chip {
                    runCount += 1
                } else {
                    // Run isn't continuing, note it and reset counter.
                    if runCount > 0 {
                        counts.append(runCount)
                    }
                    runCount = 0
                }
            }
            if runCount > 0 {
                // Note the run if still on one at the end of the line.
                counts.append(runCount)
            }
        }
        
        // Detect diagonal (northwest) runs
        for startColumn in 0..<(Int(AAPLBoard.width + AAPLBoard.height)) {
            // Iterate through areas off the edge of the board to catch all the diagonal lines through it.
            var runCount = 0
            for offset in 0..<Int(AAPLBoard.height) {
                let column = startColumn - offset
                if column < 0 || column >= Int(AAPLBoard.width) {
                    continue // Ignore areas that aren't on the board.
                }
                if self.chip(inColumn: column, row: offset) == chip {
                    runCount += 1
                } else {
                    // Run isn't continuing, note it and reset counter.
                    if runCount > 0 {
                        counts.append(runCount)
                    }
                    runCount = 0
                }
            }
            if runCount > 0 {
                // Note the run if still on one at the end of the line.
                counts.append(runCount)
            }
        }
        
        return counts
        
    }
    
}

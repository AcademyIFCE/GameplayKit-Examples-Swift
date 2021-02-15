//
//  AAPLViewController.swift
//  FourInARow
//

import UIKit
import GameplayKit

let USE_AI_PLAYER = true

class AAPLViewController: UIViewController {
    
    @IBOutlet var columnButtons: [UIButton]!
    
    var strategist: GKMinmaxStrategist!
    
    var chipLayers: [[CAShapeLayer]] = []
    
    var chipPath: UIBezierPath!
    
    var board: AAPLBoard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        strategist = GKMinmaxStrategist()
        
        // 4 AI turns + 3 human turns in between = 7 turns for dominant AI (if heuristic good).
        strategist.maxLookAheadDepth = 7
        strategist.randomSource = GKARC4RandomSource()

        chipLayers = Array(repeating: [], count: AAPLBoard.width)
        
        resetBoard()
        
    }
    
    override func viewDidLayoutSubviews() {
        let button = columnButtons[0]
        let length = CGFloat(min((button.frame.size.width) - 10, (button.frame.size.height) / 6 - 10))
        let rect = CGRect(x: 0, y: 0, width: length, height: length)
        chipPath = UIBezierPath(ovalIn: rect)
        
        chipLayers.enumerated().forEach { (column, columnLayers) in
            columnLayers.enumerated().forEach { (row, chip) in
                chip.path = chipPath.cgPath
                chip.frame = chipPath.bounds
                chip.position = positionForChipLayer(atColumn: column, row: row)
            }
            
        }
    }
    
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag
        if board.canMove(in: column) {
            board.add(board.currentPlayer.chip, in: column)
            update(sender)
            updateGame()
        }
    }
    
    func positionForChipLayer(atColumn column: Int, row: Int) -> CGPoint {
        let columnButton = columnButtons[column]
        let xOffset = columnButton.frame.midX
        let yStride: CGFloat = chipPath.bounds.size.height + 10
        let yOffset = (columnButton.frame.maxY ) - yStride / 2
        return CGPoint(x: xOffset, y: yOffset - yStride * CGFloat(row))
    }
    
    func addLayer(atColumn column: Int, row: Int, color: UIColor?) {
        
        if chipLayers[column].count < row + 1 {
            // Create and position a layer for the new chip.
            let newChip = CAShapeLayer()
            newChip.path = chipPath.cgPath
            newChip.frame = chipPath.bounds
            newChip.fillColor = color?.cgColor
            newChip.position = positionForChipLayer(atColumn: column, row: row)
            
            // Animate the chip falling into place.
            view.layer.addSublayer(newChip)
            let animation = CABasicAnimation(keyPath: "position.y")
            animation.fromValue = NSNumber(value: Float(-newChip.frame.size.height))
            animation.toValue = NSNumber(value: Float(newChip.position.y))
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
            newChip.add(animation, forKey: nil)
            chipLayers[column].append(newChip)
        }
    }
    
    func resetBoard() {
        
        board = AAPLBoard()
        
        for button in columnButtons {
            update(button)
        }
        updateUI()
        
        strategist.gameModel = board
        
        for i in chipLayers.indices {
            for chip in chipLayers[i] {
                chip.removeFromSuperlayer()
            }
            chipLayers[i].removeAll(keepingCapacity: true)
        }
        
    }
    
    func update(_ button: UIButton) {
        let column = button.tag
        button.isEnabled = board.canMove(in: column)
        
        var row = AAPLBoard.height
        var chip = AAPLChip.none
        while chip == .none && row > 0 {
            row -= 1
            chip = board.chip(inColumn: column, row: row)
        }
        
        if chip != .none {
            addLayer(atColumn: column, row: row, color: AAPLPlayer.player(for: chip)!.color)
        }
    }
    
    func updateUI() {
        navigationItem.title = "\(board.currentPlayer.name!) Turn"
        navigationController?.navigationBar.backgroundColor = board.currentPlayer.color
        
        if USE_AI_PLAYER {
            if (self.board.currentPlayer.chip == .black) {
                
                // Disable buttons & show spinner while AI player "thinks".
                for button in columnButtons {
                    button.isEnabled = false
                }
                
                let spinner = UIActivityIndicatorView(style: .medium)
                
                spinner.startAnimating()
                
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
                
                // Invoke GKMinmaxStrategist on background queue -- all that lookahead might take a while.
                DispatchQueue.global(qos: .default).async(execute: { [self] in
                    let strategistTime = TimeInterval(CFAbsoluteTimeGetCurrent())
                    let column = columnForAIMove()
                    let delta = TimeInterval(CFAbsoluteTimeGetCurrent()) - strategistTime
                    
                    let aiTimeCeiling: TimeInterval = 2.0
                    
                    /*
                     Make the player wait for the AI for a minimum time so that they
                     notice the AI moving even if it's fast.
                     */
                    let delay = TimeInterval(min(aiTimeCeiling - delta, aiTimeCeiling))
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { [self] in
                        makeAIMove(inColumn: column)
                    })
                    
                })
                
            }
        }
        
    }
    
    func columnForAIMove() -> Int {
        var column: Int
        
        let aiMove = strategist.bestMove(for: board.currentPlayer) as? AAPLMove

        assert(aiMove != nil, "AI should always be able to move (detect endgame before invoking AI)")

        column = aiMove?.column ?? 0

        return column
    }
    
    func makeAIMove(inColumn column: Int) {
        // Done "thinking", hide spinner.
        navigationItem.leftBarButtonItem = nil

        board.add(board.currentPlayer.chip, in: column)
        for button in columnButtons {
            update(button)
        }

        updateGame()
    }
    
    func updateGame() {
        var gameOverTitle: String? = nil
        if board.isWin(for: board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name!) Wins!"
        } else if board.isFull() {
            gameOverTitle = "Draw!"
        }

        if let gameOverTitle = gameOverTitle {
            let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)

            let alertAction = UIAlertAction(title: "Play Again", style: .default) { _ in self.resetBoard() }

            alert.addAction(alertAction)

            present(alert, animated: true)

            return
        }

        board.currentPlayer = board.currentPlayer.opponent!

        updateUI()
    }
    
}

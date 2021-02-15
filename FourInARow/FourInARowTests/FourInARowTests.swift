//
//  FourInARowTests.swift
//  FourInARowTests
//
//  Created by Mateus Rodrigues on 27/01/21.
//

import XCTest
@testable import FourInARow

class FourInARowTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHorizontalWin1() {
        let board = AAPLBoard()
        board.add(.red, inColumn: 0)
        board.add(.black, inColumn: 0)
        board.add(.red, inColumn: 1)
        board.add(.black, inColumn: 1)
        board.add(.red, inColumn: 2)
        board.add(.black, inColumn: 2)
        board.add(.red, inColumn: 3)

        XCTAssert(board.debugDescription == " . . . . . . \n . . . . . . \n . . . . . . \n . . . . . . \nO.O.O. . . . \nX.X.X.X. . . ")

        XCTAssert(board.isWin(for: AAPLPlayer.red))
    }
    func testHorizontalWin2() {
        let board = AAPLBoard()
        board.add(.red, inColumn: 6)
        board.add(.black, inColumn: 5)
        board.add(.red, inColumn: 4)
        board.add(.black, inColumn: 3)
        board.add(.red, inColumn: 2)
        board.add(.black, inColumn: 3)
        board.add(.red, inColumn: 0)
        board.add(.black, inColumn: 4)
        board.add(.red, inColumn: 0)
        board.add(.black, inColumn: 5)
        board.add(.red, inColumn: 0)
        board.add(.black, inColumn: 6)

        XCTAssert(board.debugDescription==" . . . . . . \n . . . . . . \n . . . . . . \nX. . . . . . \nX. . .O.O.O.O\nX. .X.O.X.O.X")

        XCTAssert(board.isWin(for: AAPLPlayer.black))
    }

    func testVerticalWin1() {
        let board = AAPLBoard()
        board.add(.red, inColumn: 0)
        board.add(.black, inColumn: 5)
        board.add(.red, inColumn: 0)
        board.add(.black, inColumn: 3)
        board.add(.red, inColumn: 0)
        board.add(.black, inColumn: 3)
        board.add(.red, inColumn: 0)

        XCTAssert(board.debugDescription==" . . . . . . \n . . . . . . \nX. . . . . . \nX. . . . . . \nX. . .O. . . \nX. . .O. .O. ")

        XCTAssert(board.isWin(for: AAPLPlayer.red))
    }

    func testVerticalWin2() {
        let board = AAPLBoard()
        board.add(.red, inColumn: 6)
        board.add(.black, inColumn: 5)
        board.add(.red, inColumn: 4)
        board.add(.black, inColumn: 3)
        board.add(.red, inColumn: 2)
        board.add(.black, inColumn: 3)
        board.add(.red, inColumn: 0)
        board.add(.black, inColumn: 3)
        board.add(.red, inColumn: 0)
        board.add(.black, inColumn: 3)

        XCTAssert(board.debugDescription==" . . . . . . \n . . . . . . \n . . .O. . . \n . . .O. . . \nX. . .O. . . \nX. .X.O.X.O.X")

        XCTAssert(board.isWin(for: AAPLPlayer.black))
    }

    func diagonalWinBase() -> AAPLBoard {
        let board = AAPLBoard()
        board.add(.red, inColumn: 0)
        board.add(.black, inColumn: 1)
        board.add(.red, inColumn: 2)
        board.add(.black, inColumn: 3)
        board.add(.red, inColumn: 1)
        board.add(.black, inColumn: 2)
        board.add(.red, inColumn: 3)
        board.add(.black, inColumn: 0)
        board.add(.red, inColumn: 0)
        board.add(.black, inColumn: 1)
        board.add(.red, inColumn: 2)
        board.add(.black, inColumn: 3)

        XCTAssert(board.debugDescription==" . . . . . . \n . . . . . . \n . . . . . . \nX.O.X.O. . . \nO.X.O.X. . . \nX.O.X.O. . . ")

        return board
    }

    func testNortheastWin() {
        let board = diagonalWinBase()

        board.add(.red, inColumn: 3)

        XCTAssert(board.debugDescription==" . . . . . . \n . . . . . . \n . . .X. . . \nX.O.X.O. . . \nO.X.O.X. . . \nX.O.X.O. . . ")

        XCTAssert(board.isWin(for: AAPLPlayer.red))
    }

    func testSoutheastWin() {
        let board = diagonalWinBase()

        board.add(.red, inColumn: 4)

        board.add(.black, inColumn: 0)

        XCTAssert(board.debugDescription==" . . . . . . \n . . . . . . \nO. . . . . . \nX.O.X.O. . . \nO.X.O.X. . . \nX.O.X.O.X. . ")
        
        XCTAssert(board.isWin(for: AAPLPlayer.black))
    }

    func testFull() {
        let board = AAPLBoard()
        for column in 0..<AAPLBoard.width() {
            for i in 0..<AAPLBoard.height() {
                let chip = AAPLChip(rawValue: i % 2 + 1)!
                board.add(chip, inColumn: column)
            }
        }
        XCTAssert(board.isFull())
    }

    //###
    func testNortheastWinEastMost() {
        let board = AAPLBoard()
        board.add(.red, inColumn: 3)
        board.add(.black, inColumn: 4)
        board.add(.red, inColumn: 4)
        board.add(.black, inColumn: 5)
        board.add(.red, inColumn: 1)
        board.add(.black, inColumn: 5)
        board.add(.red, inColumn: 5)
        board.add(.black, inColumn: 6)
        board.add(.red, inColumn: 1)
        board.add(.black, inColumn: 6)
        board.add(.red, inColumn: 0)
        board.add(.black, inColumn: 6)
        board.add(.red, inColumn: 6)
        
        XCTAssert(board.debugDescription == " . . . . . . \n . . . . . . \n . . . . . .X\n . . . . .X.O\n .X. . .X.O.O\nX.X. .X.O.O.O")

        XCTAssert(board.isWin(for: AAPLPlayer.red))
    }
    
    //###
    func testSoutheastWinEastMost() {
        let board = AAPLBoard()
        board.add(.red, inColumn: 5)
        board.add(.black, inColumn: 6)
        board.add(.red, inColumn: 4)
        board.add(.black, inColumn: 5)
        board.add(.red, inColumn: 4)
        board.add(.black, inColumn: 4)
        board.add(.red, inColumn: 3)
        board.add(.black, inColumn: 2)
        board.add(.red, inColumn: 3)
        board.add(.black, inColumn: 1)
        board.add(.red, inColumn: 3)
        board.add(.black, inColumn: 3)
        
        XCTAssert(board.debugDescription == " . . . . . . \n . . . . . . \n . . .O. . . \n . . .X.O. . \n . . .X.X.O. \n .O.O.X.X.X.O")
        
        XCTAssert(board.isWin(for: AAPLPlayer.black))
    }

}

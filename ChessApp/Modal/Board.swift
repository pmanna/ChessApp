//
//  ChessBoard.swift
//  ChessApp
//
//  Created by Student 3 on 4/4/18.
//  Copyright © 2018 Student 3. All rights reserved.
//

import UIKit

let boardColumns    = ["a","b","c","d","e","f","g","h"]
let boardRows       = ["8","7","6","5","4","3","2","1"]

class Board: UIView{
    
    //Declaration
    
    /**
     2D array to hold the game's `BoardSpace`s in a grid pattern.
     Note that the coordinates start from the bottom-left, at 0,0.
     */
    var boardSpaces = [[BoardSpace]]()
    
    /**
     Connecting the current game instance to our board
     */
    var chessGame : ChessGame?
    
    /**
     The `BoardSpace` currently highlighted.
     */
    var highlightedSpace: BoardSpace!
    
    var currentPlayerTurnLabel: UILabel!
    var turnLabel: UILabel!
    
    /**
     The normal background `NSColor` of the `BoardSpace` that is currently highlighted.
     Needed to restore the `BoardSpace`'s color back to normal after its highlight is removed.
     */
    var highlightedColor: UIColor!
    
    /**
     Should the particular tile/boardspace white or black?
     */
    var whiteFill = false
    
    /**
     Indicates whether the game has finished.
     */
    var gameOver = false
    
    /**
     Our En passant callback code block. Also known as a "callback function", and functionally equivalent
     to function pointers, these are basically blocks of code wrapped up to act like a normal variable. They provide an easy
     way to interact between classes, and are much more flexible than other methods, such as delegation or notification usage.
     In this case, it's being used to handle the extra board management required when a pawn destroys another pawn using en passant.
     
     - Parameter enemyX: The x-coordinate of the enemy pawn
     - Parameter enemyY: The y-coordinate of the enemy pawn
     */
    var enPassantBlock: ((_ enemyX: Int, _ enemyY: Int)->())!

    /**
     The `ChessPiece` that moved during the last turn. Used to detect the conditions for an en passant move.
     */
    var lastPieceMoved: ChessPiece!

    /**
     Highlighting piece that is choosen. Highlight with Yellow color
     */
    func highlightPiece(_ space: BoardSpace){
        if let tile = highlightedSpace{
            tile.backgroundColor = highlightedColor
        }
        highlightedSpace = space
        highlightedColor = space.backgroundColor
        space.backgroundColor = UIColor.yellow
        
        print(space.x, space.y)
    }
    func clearHighlight(){
        if let tile = highlightedSpace{
            tile.backgroundColor = highlightedColor
            highlightedSpace = nil
            highlightedColor = nil
            
        }
    }
    
    /**
     The game instance define whose turn is it
     */
    var playerTurn: PieceColor?
    
    
    /** Constructor for the Board class. This is to handle all the View and Board Rules
     */
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        enPassantBlock = {
            (x: Int, y: Int) in
            self.boardSpaces[x][y].clearPiece()
//            let capturedPiece = self.boardSpaces[x][y].occupyingPiece
//            self.chessGame.displayCapturedPiece(piece: capturedPiece!)
        }
        
        let boardSize = frame.width
        let squareSize = boardSize / 8.0
        
         // Everything between this line and line ___ is the definition of the tapEventHandler callback.
        
        // Through an 8x8 chess board, we make display and control the event tap handler
        for column in 0..<8{
            var columnSpace = [BoardSpace]()
            whiteFill = !whiteFill
           
            for row in 0..<8{
                let boardSpace = BoardSpace(size: squareSize,
                                            xPixel: CGFloat(column) * squareSize,
                                            yPixel: CGFloat(row) * squareSize,
                                            fillWhite: whiteFill){
                    
                    // This is by definition the Event Tap Listener for our Chess Board Game
                    // When users tap to select, deselect, and move the chess piece(s)
                    space in
                                                self.handleMove(space: space)
               }
                
                addSubview(boardSpace)
                whiteFill = !whiteFill
            
                columnSpace.append(boardSpace)
            }
        
                boardSpaces.append(columnSpace)
        }
    }
    
    func handleMove(space: BoardSpace) {
        // We immediately end the function if the game is over, as we want to ignore all taps on any BoardSpace.
        if (gameOver) { return }
        
        let occupant = space.occupyingPiece
        var occupantIsAlly = false
        
        if occupant != nil{
            if occupant?.pieceColor == chessGame!.playerTurn {
                occupantIsAlly = true
            }
        }
        
        if let highlightedSpace = highlightedSpace,
            let highlightedPiece = highlightedSpace.occupyingPiece { // A piece is already highlighted
            if highlightedSpace.x == space.x && highlightedSpace.y == space.y { // The highlighted piece is clicked
                clearHighlight()
                return
            }
            if !occupantIsAlly && highlightedPiece.isValidMove(startX: highlightedSpace.x, startY: highlightedSpace.y,
                                                               destinationX: space.x, destinationY: space.y, board: boardSpaces){
                let isWhite = highlightedPiece.pieceColor == .white
                
                let startStr    = boardSpaceToString(space: highlightedSpace)
                let endStr      = boardSpaceToString(space: space)
                
                print("Move \(startStr)\(endStr)")
                
                if isWhite {
                    inputPlayerMove("\(startStr)\(endStr)".cString(using: .utf8))
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let UMaxMove    = UnsafeMutablePointer<Int8>.allocate(capacity: 40)
                        
                        getUMaxMove(UMaxMove)
                        
                        let autoMove = String(cString: UMaxMove)
                        let startStr = String(autoMove[...autoMove.index(autoMove.startIndex, offsetBy: 1)])
                        let endStr = String(autoMove[autoMove.index(autoMove.startIndex, offsetBy: 2)...])
                        
                        if let space   = self.stringToBoardSpace(str: startStr) {
                            self.handleMove(space: space)
                            DispatchQueue.main.async {
                                if let space = self.stringToBoardSpace(str: endStr) {
                                    self.handleMove(space: space)
                                }
                            }
                        }
                    }
                }
                
                space.setPiece(chessPiece: highlightedPiece)
                highlightedSpace.clearPiece()
                
                if highlightedPiece is Pawn && (isWhite && space.y == 0 || !isWhite && space.y == 7) {
                    var queenImage = chessGame!.iconSet.whiteQueen
                    if !isWhite {
                        queenImage = chessGame!.iconSet.blackQueen
                    }
                    space.setPiece(chessPiece: Queen(image: queenImage!, pawnImage: highlightedPiece.pieceImage, color: .white))
                }
                
                if occupant != nil{ // An enemy has been destroyed
                    if occupant is Queen && (occupant as! Queen).takenOverPawnImage != nil{
//                     chessGame.displayCapturedPiece(piece: Pawn(image: (occupant as! Queen).takenOverPawnImage,
//                                                                                    color: .White,
//                                                                                    enPassantEventHandler: enPassantBlock))
                    }
                    else{
//                      chessGame.displayCapturedPiece(piece: occupant!)
                        if occupant is King {
                            if chessGame!.playerTurn == .white{
                                currentPlayerTurnLabel.text = chessGame!.whitePlayer
                            } else {
                                currentPlayerTurnLabel.text = chessGame!.blackPlayer
                            }
                            turnLabel.text = "wins!"
//                          chessGame.gameWindow.title += " - (\(currentPlayerTurnLabel.stringValue) wins!)"
                            gameOver = true
                            clearHighlight()
                            return
                        }
                    }
                }
                if lastPieceMoved != nil && lastPieceMoved is Pawn {
                    (lastPieceMoved as! Pawn).justMadeDoubleStep = false
                }
                lastPieceMoved = space.occupyingPiece
                chessGame!.newPlayerMove()
            }
            else{
                if occupantIsAlly{
                    clearHighlight()
                    highlightPiece(space)
                    return
                }
            }
        } else if occupantIsAlly{
            highlightPiece(space)
            return
        }
        clearHighlight()
    }
    
    func boardSpaceToString(space: BoardSpace) -> String {
        var row = 0, column = 0
        
        columnLoop: for ii in 0..<8 {
            for jj in 0..<8 {
                if boardSpaces[ii][jj] == space {
                    row = jj
                    column = ii
                    
                    break columnLoop
                }
            }
        }
        
        return "\(boardColumns[column])\(boardRows[row])"
    }
    
    func stringToBoardSpace(str: String) -> BoardSpace?
    {
        guard let columnChar = str.first else { return nil }
        
        let rowChar = str[str.index(str.startIndex, offsetBy: 1)]
        
        guard let row = boardRows.index(of: String(rowChar)), let column = boardColumns.index(of: String(columnChar)) else { return nil }
        
        return boardSpaces[column][row]
    }
    
    func initializeBoard(){
        let pieceIcon = IconSet(iconSetName: "maya")
        
        // Setup all pieces for White Side
        for i in 0..<8{
            boardSpaces[i][1].setPiece(chessPiece: Pawn(image: pieceIcon.blackPawn, color: PieceColor.black, enPassantEventHandler: enPassantBlock))
        }
        boardSpaces[0][0].setPiece(chessPiece: Rook(image: pieceIcon.blackRook, color: PieceColor.black))
        boardSpaces[1][0].setPiece(chessPiece: Knight(image: pieceIcon.blackKnight, color: PieceColor.black))
        boardSpaces[2][0].setPiece(chessPiece: Bishop(image: pieceIcon.blackBishop, color: PieceColor.black))
        boardSpaces[3][0].setPiece(chessPiece: Queen(image: pieceIcon.blackQueen, pawnImage: nil, color: PieceColor.black))
        boardSpaces[4][0].setPiece(chessPiece: King(image: pieceIcon.blackKing, color: PieceColor.black))
        boardSpaces[5][0].setPiece(chessPiece: Bishop(image: pieceIcon.blackBishop, color: PieceColor.black))
        boardSpaces[6][0].setPiece(chessPiece: Knight(image: pieceIcon.blackKnight, color: PieceColor.black))
        boardSpaces[7][0].setPiece(chessPiece: Rook(image: pieceIcon.blackRook, color: PieceColor.black))
        
        
        // Setup all pieces for Black Side
        for i in 0..<8{
           boardSpaces[i][6].setPiece(chessPiece: Pawn(image: pieceIcon.whitePawn, color: PieceColor.white, enPassantEventHandler: enPassantBlock))
        }
        boardSpaces[0][7].setPiece(chessPiece: Rook(image: pieceIcon.whiteRook, color: PieceColor.white))
        boardSpaces[1][7].setPiece(chessPiece: Knight(image: pieceIcon.whiteKnight, color: PieceColor.white))
        boardSpaces[2][7].setPiece(chessPiece: Bishop(image: pieceIcon.whiteBishop, color: PieceColor.white))
        boardSpaces[3][7].setPiece(chessPiece: Queen(image: pieceIcon.whiteQueen, pawnImage: nil, color: PieceColor.white))
        boardSpaces[4][7].setPiece(chessPiece: King(image: pieceIcon.whiteKing, color: PieceColor.white))
        boardSpaces[5][7].setPiece(chessPiece: Bishop(image: pieceIcon.whiteBishop, color: PieceColor.white))
        boardSpaces[6][7].setPiece(chessPiece: Knight(image: pieceIcon.whiteKnight, color: PieceColor.white))
        boardSpaces[7][7].setPiece(chessPiece: Rook(image: pieceIcon.whiteRook, color: PieceColor.white))
    }
}

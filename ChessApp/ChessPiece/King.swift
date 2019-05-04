//
//  King.swift
//  Chess
//
//  Created by Jack Cousineau on 10/23/15.
//

import UIKit

class King: ChessPiece {
    
    var moved = false
    
    override func isValidMove(startX: Int, startY: Int, destinationX: Int, destinationY: Int, board: [[BoardSpace]]) -> (Bool) {
        
        var validMove = false
        
        if(!moved && startY == destinationY && abs(startX - destinationX) == 2){
            if(startX < destinationX){ // Castling right
                validMove = validCastlingMove(startRookX: 7, endRookX: 5,
                                              startEmptyX: 5, endEmptyX: 5, y: startY,
                                              movementLeft: false, board: board)
            }
            else{ // Castling left
                validMove = validCastlingMove(startRookX: 0, endRookX: 3,
                                              startEmptyX: 1, endEmptyX: 3, y: startY, movementLeft: true, board: board)
            }
        }
        
        if(!validMove){
            validMove = (abs(startX - destinationX) < 2 && abs(startY - destinationY) < 2)
        }
        
        if(validMove){
            moved = true
        }
        
        return validMove
    }
    
    func validCastlingMove(startRookX: Int, endRookX: Int, startEmptyX: Int, endEmptyX: Int, y: Int, movementLeft: Bool, board: [[BoardSpace]]) -> Bool{
        if let castlingRook = board[startRookX][y].occupyingPiece{
            if(parseHorizontal(startPos: startEmptyX, endPos: endEmptyX, destinationY: y, movementLeft: movementLeft, board: board) && castlingRook is (Rook) && !(castlingRook as! Rook).moved && castlingRook.pieceColor == pieceColor){
                board[startRookX][y].clearPiece()
                board[endRookX][y].setPiece(chessPiece: castlingRook)
                (castlingRook as! Rook).moved = true
                return true
            }
        }
        return false
    }

}

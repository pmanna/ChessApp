//
//  Rook.swift
//  Chess
//
//  Created by Jack Cousineau on 10/23/15.
//

import UIKit

class Rook: ChessPiece{
    
    var moved = false
    
    override func isValidMove(startX: Int, startY: Int, destinationX: Int, destinationY: Int, board: [[BoardSpace]]) -> (Bool){
        
        let validMove = parseRookMovement(startX: startX, startY: startY,
                                          destinationX: destinationX, destinationY: destinationY,
                                          board: board)
        if(validMove){
            moved = true
        }
        return validMove
    }

}

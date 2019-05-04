//
//  Bishop.swift
//  Chess
//
//  Created by Jack Cousineau on 10/23/15.
//

import UIKit

class Bishop: ChessPiece {
    
    override func isValidMove(startX: Int, startY: Int, destinationX: Int, destinationY: Int, board: [[BoardSpace]]) -> (Bool) {
        
        return parseBishopMovement(startX: startX, startY: startY,
                                   destinationX: destinationX, destinationY: destinationY,
                                   board: board)
    }

}

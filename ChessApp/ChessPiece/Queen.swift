//
//  Queen.swift
//  Chess
//
//  Created by Jack Cousineau on 10/23/15.
//

import UIKit

class Queen: ChessPiece {
    
    var takenOverPawnImage: UIImage!
    
    init(image: UIImage, pawnImage: UIImage!, color: PieceColor){
        super.init(image: image, color: color)
        takenOverPawnImage = pawnImage
    }
    
    override func isValidMove(startX: Int, startY: Int, destinationX: Int, destinationY: Int, board: [[BoardSpace]]) -> (Bool) {
        
        if(parseBishopMovement(startX: startX, startY: startY, destinationX: destinationX, destinationY: destinationY, board: board)){
            return true
        }
        return parseRookMovement(startX: startX, startY: startY, destinationX: destinationX, destinationY: destinationY, board: board)
    }

}

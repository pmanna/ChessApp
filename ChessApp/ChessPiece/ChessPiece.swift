//
//  ChessPiece.swift
//  ChessApp
//
//  Created by Student 3 on 6/4/18.
//  Copyright © 2018 Student 3. All rights reserved.
//

import UIKit

enum PieceColor{
    case black
    case white
}

class ChessPiece{
    
    var pieceImage : UIImage!
    var pieceColor : PieceColor!
    
    init(image: UIImage, color: PieceColor){
        pieceImage = image
        pieceColor = color
    }
    
    func isValidMove(startX: Int, startY: Int, destinationX: Int, destinationY: Int, board: [[BoardSpace]]) -> (Bool){
        return false
    }
    
    func spaceIsEmpty(x: Int, y: Int, board: [[BoardSpace]]) -> Bool{
        return board[x][y].occupyingPiece == nil
    }
    
    func parseBishopMovement(startX: Int, startY: Int, destinationX: Int, destinationY: Int, board: [[BoardSpace]]) -> Bool{
        let xChange = abs(startX - destinationX)
        let yChange = abs(startY - destinationY)
        
        if(xChange == yChange){
            if(startX > destinationX){
                if(startY > destinationY){ // Southwest
                    for i in 1...xChange{
                        if(board[startX - i][startY - i].occupyingPiece != nil && (i != xChange)){
                            return false;
                        }
                    }
                }
                else{ // Northwest
                    for i in 1...xChange{
                        if(board[startX - i][startY + i].occupyingPiece != nil && (i != xChange)){
                            return false;
                        }
                    }
                }
            }
            else{
                if(startY > destinationY){ // Southeast
                    for i in 1...xChange{
                        if(board[startX + i][startY - i].occupyingPiece != nil && (i != xChange)){
                            return false;
                        }
                    }
                }
                else{ // Northeast
                    for i in 1...xChange{
                        if(board[startX + i][startY + i].occupyingPiece != nil && (i != xChange)){
                            return false;
                        }
                    }
                }
            }
            return true
        }
        return false
    }
    
    func parseRookMovement(startX: Int, startY: Int, destinationX: Int, destinationY: Int, board: [[BoardSpace]]) -> (Bool){
        if(startX == destinationX || startY == destinationY){ // Straight line
            
            if(startX != destinationX){
                if(startX < destinationX){ // Moving to the right
                    return (parseHorizontal(startPos: startX+1, endPos: destinationX, destinationY: destinationY, movementLeft: false, board: board))
                }
                else{ // Moving to the left
                    return (parseHorizontal(startPos: destinationX, endPos: startX-1, destinationY: destinationY, movementLeft: true, board: board))
                }
            }
            else{
                if(startY < destinationY){ // Moving up
                    return (parseVertical(startPos: startY+1, endPos: destinationY, destinationX: destinationX, movementDown: false, board: board))
                }
                else{ // Moving down
                    return (parseVertical(startPos: destinationY, endPos: startY-1, destinationX: destinationX, movementDown: true, board: board))
                }
            }
        }
        return false
    }
    
    func parseHorizontal(startPos: Int, endPos: Int, destinationY: Int, movementLeft: Bool, board: [[BoardSpace]]) -> Bool{
        for i in startPos...endPos{
            if let obstructingPiece = board[i][destinationY].occupyingPiece{
                if(((!movementLeft && i == endPos) || (movementLeft && i == startPos)) && obstructingPiece.pieceColor != pieceColor){
                    continue
                }
                return false
            }
        }
        return true
    }
    
    func parseVertical(startPos: Int, endPos: Int, destinationX: Int, movementDown: Bool, board: [[BoardSpace]]) -> Bool{
        for i in startPos...endPos{
            if let obstructingPiece = board[destinationX][i].occupyingPiece{
                if(((!movementDown && i == endPos) || (movementDown && i == startPos)) && obstructingPiece.pieceColor != pieceColor){
                    continue
                }
                return false
            }
        }
        return true
    }
}

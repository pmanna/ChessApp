//
//  Pawn.swift
//  ChessApp
//
//  Created by Student 3 on 11/4/18.
//  Copyright © 2018 Student 3. All rights reserved.
//

import UIKit

class Pawn: ChessPiece{
    
    var firstMove = true
    var justMadeDoubleStep = false
    
    var enPassantCallback: ((_ enemyX: Int, _ enemyY: Int)->())
    
    init(image: UIImage, color: PieceColor, enPassantEventHandler: @escaping ((_ enemyX: Int, _ enemyY: Int)->())){
        enPassantCallback = enPassantEventHandler
        super.init(image: image, color: color)
    }
    
    func canApplyEnPassant(targetX: Int, targetY: Int, board: [[BoardSpace]]) -> Bool{
        if let targetPawn = board[targetX][targetY].occupyingPiece{
            if(targetPawn is Pawn && (targetPawn as! Pawn).justMadeDoubleStep && targetPawn.pieceColor != pieceColor){
                enPassantCallback(targetX, targetY)
                return true
            }
        }
        return false
    }
    
    override func isValidMove(startX: Int, startY: Int, destinationX: Int, destinationY: Int, board: [[BoardSpace]]) -> (Bool) {
        
        var maxYVariance = 1, maxXVariance = 0
        
        if let _ = board[destinationX][destinationY].occupyingPiece{ // Piece at destination
            if(startX == destinationX){
                maxXVariance -= 1
            }
            else{
                maxXVariance += 1
            }
        }
        
        let isBlack = pieceColor == .black
        if isBlack && startY == 4{
            if(canApplyEnPassant(targetX: destinationX, targetY: destinationY - 1, board: board)){
                return true
            }
        }
        else if !isBlack && startY == 3{
            if(canApplyEnPassant(targetX: destinationX, targetY: destinationY + 1, board: board)){
                return true
            }
        }
        
        let xVariance = abs(destinationX - startX), yVariance = abs(destinationY - startY)
        
        if(firstMove){
            maxYVariance += 1
        }
        
        
        if xVariance <= maxXVariance && yVariance <= maxYVariance && ((!(xVariance == 1 && yVariance == 2) && ((isBlack && startY < destinationY) || (!isBlack && startY > destinationY))) || (maxYVariance == 2 && ((isBlack && board[destinationX][startY + 1].occupyingPiece != nil) || (!isBlack && board[destinationX][startY - 1].occupyingPiece != nil)))){
            
            if(yVariance == 2){
                justMadeDoubleStep = true
            }
            firstMove = false
            return true
        }
        
        return false
    }
}

//
//  BoardSpace.swift
//  ChessApp
//
//  Created by Student 3 on 5/4/18.
//  Copyright © 2018 Student 3. All rights reserved.
//

import UIKit

class BoardSpace: UIView {
    
    var occupyingPiece: ChessPiece!
    var occupyingPieceImage: UIImageView!
    
    var x : Int
    var y : Int
    var size : CGFloat
    var tapEventBlock : ((BoardSpace)->())?
    
    init(size: CGFloat, xPixel:CGFloat, yPixel:CGFloat, fillWhite: Bool, tapEventHandler: ((BoardSpace)->())? ){
        
        self.x = Int(xPixel/size)
        self.y = Int(yPixel/size)
        self.size = size
        
        super.init(frame: CGRect(x: xPixel, y: yPixel, width: CGFloat(size - 1.0), height: CGFloat(size - 1.0)))
        backgroundColor = fillWhite ? UIColor.white : UIColor.gray
        
        tapEventBlock = tapEventHandler
        
        self.addTapGestureRecognizer {
            self.tapEventBlock!(self)
        }
    }
    
    // Setting the tiles with chess piece : Piece Image, Occupying piece(ChessPiece)
    func setPiece(chessPiece: ChessPiece){
        occupyingPiece = chessPiece
        if (occupyingPieceImage == nil){
            occupyingPieceImage = UIImageView(frame: CGRect(x: CGFloat(4), y: CGFloat(4), width: CGFloat(size - 8), height: CGFloat(size - 8)))
            self.addSubview(occupyingPieceImage)
        }
        occupyingPieceImage.image = chessPiece.pieceImage
    }
    
    func clearPiece(){
        occupyingPieceImage.removeFromSuperview()
        occupyingPieceImage = nil
        occupyingPiece = nil
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

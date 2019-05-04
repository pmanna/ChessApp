//
//  GameViewController.swift
//  ChessApp
//
//  Created by Student 3 on 6/4/18.
//  Copyright © 2018 Student 3. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    //board UIView from Main.storyboard
    @IBOutlet var board: Board!
    @IBOutlet var playerLabel: UILabel!
    @IBOutlet var turnLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let game = ChessGame(whitePlayerName: "Player 1", blackPlayerName: "Computer", iconSetName: "Maya")
        board.chessGame = game
        game.chessBoard = board
        playerLabel.text                = "Player 1"
        board.currentPlayerTurnLabel    = playerLabel
        board.turnLabel                 = turnLabel
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    

}

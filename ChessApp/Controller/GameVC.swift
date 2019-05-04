//
//  GameViewController.swift
//  ChessApp
//
//  Created by Student 3 on 6/4/18.
//  Copyright © 2018 Student 3. All rights reserved.
//

import UIKit

let MovePieceNotification   = Notification.Name("MovePieceNotification")

class GameViewController: UIViewController {

    //board UIView from Main.storyboard
    @IBOutlet var board: Board!
    @IBOutlet var playerLabel: UILabel!
    @IBOutlet var turnLabel: UILabel!
    @IBOutlet var indicatorView: UIView!
    
    var simpleBluetoothIO: SimpleBluetoothIO!
    var isConnected = false
    var isMoving    = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        simpleBluetoothIO = SimpleBluetoothIO(serviceUUID: "4FAFC201-1FB5-459E-8FCC-C5C9C331914B",
                                              peripheralName: "MicroTurk",
                                              delegate: self)

        let game = ChessGame(whitePlayerName: "Player 1", blackPlayerName: "Computer", iconSetName: "Maya")
        
        game.chessBoard                 = board
        playerLabel.text                = "Player 1"
        
        board.chessGame                 = game
        board.currentPlayerTurnLabel    = playerLabel
        board.turnLabel                 = turnLabel
        
        NotificationCenter.default.addObserver(forName: MovePieceNotification,
                                               object: nil,
                                               queue: .main) { (notification) in
                                                guard !self.isMoving && self.isConnected else {return}
                                                guard let cmdStr = notification.object as? String else {return}
                                                
                                                if let cmdData = cmdStr.data(using: .utf8) {
                                                    self.simpleBluetoothIO.writeValue(value: cmdData)
                                                    self.isMoving = true
                                                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GameViewController: SimpleBluetoothIODelegate {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, isReady: Bool) {
        isConnected                     = true
        indicatorView.backgroundColor   = .green
        
        simpleBluetoothIO.writeValue(value: "R\r\n".data(using: .utf8)!)
    }
    
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: Data) {
        if let bleMessage = String(data: value, encoding: .utf8) {
            if bleMessage.hasPrefix("OK") && board.chessGame?.playerTurn == .black {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.board.letComputerMove()
                }
            }
            isMoving = false
        }
    }
    
}

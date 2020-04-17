//
//  ViewController.swift
//  XO Game
//
//  Created by User on 3/2/20.
//  Copyright © 2020 User. All rights reserved.
//

import UIKit
import SwiftEntryKit

enum Player {
    case one // X 1
    case two  // O 2
}

enum gameStatus{
    case XWin
    case OWin
    case playersDraw
}

class ViewController: UIViewController {
    
    //MARK:- Outlets & Properties
    @IBOutlet private var gameBoardButtons: [UIButton]!
    
    let playeroneFontColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
    let playerTwoFontColor = #colorLiteral(red: 1, green: 0.2156862745, blue: 0.3725490196, alpha: 1)
    
    var popupMessageAttributes : EKAttributes?
    
    var currentPlayer: Player = .one
    var gameBoardState = [0, 0, 0,
                          0, 0, 0,
                          0, 0, 0]
    let winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                               [0, 3, 6], [1, 4, 7], [2, 5, 8],
                               [0, 4, 8], [2, 4, 6]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        popupMessageAttributes = setupPopMessageAttributes()
    }
    
    //MARK:- Actions
    @IBAction private func plays(_ sender: UIButton) {
        currentPlayerPlay(sender)
        updateGameBoardState(sender)
        checkGameState()
    }
    
    
    @IBAction private func resetButtonClick(_ sender: UIButton) {
        reset()
    }
}
//MARK:- Methods.
extension ViewController{
    private func checkGameState(){
        if !checkForWinner() && isDraw(){
            showPopupMessage(gametStatus_: .playersDraw)
        }
    }
    
    private func checkForWinner() ->Bool {
        for combination in winningCombinations {
            if gameBoardState[combination[0]] != 0 && gameBoardState[combination[0]] == gameBoardState[combination[1]] && gameBoardState[combination[1]] == gameBoardState[combination[2]] {
                
                if gameBoardState[combination[0]] == 1 {
                    showPopupMessage(gametStatus_: .XWin)
                    return true
                } else {
                    showPopupMessage(gametStatus_: .OWin)
                    return true
                }
                
            }
        }
        return false
    }
    
    private func isDraw()->Bool{
        return  !gameBoardState.contains(0)
    }
    
    private func updateGameBoardState(_ sender: UIButton) {
        let currnetPlayerButtonIndex = sender.tag
        gameBoardState[currnetPlayerButtonIndex] = sender.title(for: .normal) == "X" ? 1 : 2
    }
    
    private func currentPlayerPlay(_ sender: UIButton) {
        switch currentPlayer {
        case .one:
            sender.setTitleColor(playeroneFontColor, for: .normal)
            sender.setTitle("X", for: .normal)
            currentPlayer = .two
        case .two:
            sender.setTitleColor(playerTwoFontColor, for: .normal)
            sender.setTitle("O", for: .normal)
            currentPlayer = .one
        }
        
        sender.isEnabled = false
    }
    
    private func reset() {
        for button in gameBoardButtons {
            button.setTitle(" ", for: .normal)
            button.isEnabled = true
        }
        
        gameBoardState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        currentPlayer = .one
    }
}

//MARK:- Alert Customization
extension ViewController{
    
    private func showPopupMessage(gametStatus_ : gameStatus) {
        var titleText = ""
        var descriptionText = ""
        switch gametStatus_ {
        case .XWin:
            titleText = "Congrats Player 1"
            descriptionText = "player 1 Win 🎉🎉"
        case .OWin:
            titleText = "Congrats Player 2"
            descriptionText = "player 2 Win 🎉🎉"
        case .playersDraw:
            titleText = "You Draw"
            descriptionText = "try to win next time."
        }
        
        let title = EKProperty.LabelContent(
            text: titleText,
            style: .init(
                font: UIFont(name: "Verdana-Bold", size: 25)!,
                color: EKColor(light: UIColor.systemYellow, dark: UIColor.systemYellow),
                alignment: .center,
                displayMode: .inferred
            )
        )
        let description = EKProperty.LabelContent(
            text: descriptionText,
            style: .init(
                font: UIFont(name: "Verdana-Bold", size: 20)!,
                color: EKColor(light: UIColor.systemYellow, dark: UIColor.systemYellow),
                alignment: .center,
                displayMode: .inferred
            )
        )
        let button = EKProperty.ButtonContent(
            label: .init(
                text: "Reset Game!",
                style: .init(
                    font: UIFont(name: "Verdana-Bold", size: 17)!,
                    color: EKColor(light: UIColor.black, dark: UIColor.black),
                    displayMode: .inferred
                )
            ),
            backgroundColor: EKColor(light: UIColor.systemOrange, dark: UIColor.systemOrange),
            highlightedBackgroundColor: EKColor(light: UIColor.red.withAlphaComponent(0.6), dark: UIColor.red.withAlphaComponent(0.6)),
            displayMode: .inferred){
                SwiftEntryKit.dismiss()
                self.reset()
                
        }
        
        let message = EKPopUpMessage(
            title: title,
            description: description,
            button: button) {
                SwiftEntryKit.dismiss()
                self.reset()
        }
        
        let contentView = EKPopUpMessageView(with: message)
        if let attributes = popupMessageAttributes{
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    private func setupPopMessageAttributes() -> EKAttributes{
        var attributes = EKAttributes()
        attributes.position = .center
        attributes.entryInteraction = .absorbTouches
        attributes.displayDuration = .infinity
        attributes.positionConstraints.size.width = EKAttributes.PositionConstraints.Edge.ratio(value: 0.85)
        attributes.roundCorners = .all(radius: 15)
        
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        // Set its background to image
        attributes.entryBackground = .image(image: UIImage(named: "black")!)
        
        // Animate in and out using default translation
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        return attributes
    }
}




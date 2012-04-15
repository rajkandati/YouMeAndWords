//
//  GameViewController.h
//  YouMeAndWords_v1
//
//  Created by Raj Kandati on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlphabetView.h"
#import "Player.h"
#import "GameOverViewController.h"


/**
 * The controller represents the screen for an individual game. It sets up the screen 
 * with alphabets for the game. using AlphabetView. The controller acts as a delegate 
 * for AlphabetView responding to user clicks on alphabets and also as a delegate to 
 * GameOverViewController responding to new game requests.
 *
 **/

@interface GameViewController : UIViewController <AlphabetViewDelegate, GameOverViewControllerDelegate>

//Represents the player specific to the device.
@property(nonatomic, strong) Player *player;

@end

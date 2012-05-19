//
//  HomeViewController.h
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "Player.h"
#import "BookmarksViewController.h"
#import "GameViewController.h"

@interface HomeViewController : UIViewController <AboutViewControllerDelegate, BookmarksViewControllerDelegate>

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

//
//  SettingsViewController.h
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AboutViewController;

@protocol AboutViewControllerDelegate

- (void)aboutViewController:(AboutViewController*)controller didTapBackButton:(id)sender;

@end

@interface AboutViewController : UIViewController

@property(nonatomic, weak) id<AboutViewControllerDelegate> delegate;

- (IBAction)backButtonTapped;

@end

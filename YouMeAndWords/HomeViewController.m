//
//  HomeViewController.m
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "GameViewController.h"
#import "Game.h"
#import "AboutViewController.h"
#import "BookmarksViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) IBOutlet UILabel *gamesLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberOfWordsLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberOfSixPlusWordsLabel;
@property(nonatomic, strong) Player *player;

@end

@implementation HomeViewController 


@synthesize managedObjectContext = _managedObjectContext;
@synthesize gamesLabel = _gamesLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize numberOfWordsLabel = _numberOfWordsLabel;
@synthesize numberOfSixPlusWordsLabel = _numberOfSixPlusWordsLabel;
@synthesize player = _player;

- (Player *)player
{
    if (!_player) {
        _player = [Player playerInManagedObjectContext:self.managedObjectContext];
    }
    return _player;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PlayGame"]) {
        //Don't do anything for now...
        GameViewController *gvc = (GameViewController*)segue.destinationViewController;
        gvc.managedObjectContext = self.managedObjectContext;
        gvc.player = self.player;
    } else if ([segue.identifier isEqualToString:@"HelpAndSettings"]) {
        AboutViewController *svc = (AboutViewController*)segue.destinationViewController;
        svc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Bookmarks"]) {
        BookmarksViewController *bvc = (BookmarksViewController*)segue.destinationViewController;
        bvc.player = self.player;
        bvc.managedObjectContext = self.managedObjectContext;
        bvc.delegate = self;
    }
}


#pragma Delegate methods

- (void)aboutViewController:(AboutViewController*)controller didTapBackButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)bookmarksViewController:(BookmarksViewController*)controller didTapbackButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scoreLabel.text = [NSString stringWithFormat:@"%i", self.player.totalScore.intValue];
    self.gamesLabel.text = [NSString stringWithFormat:@"%i", self.player.lastGamePlayed.intValue];
    self.numberOfWordsLabel.text = [NSString stringWithFormat:@"%i", self.player.totalNumberOfWordsCreated.intValue];
    self.numberOfSixPlusWordsLabel.text = [NSString stringWithFormat:@"%i", self.player.numberOfSixPlusLetterWordsCreated.intValue];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.gamesLabel = nil;
    self.scoreLabel = nil;
    self.numberOfWordsLabel = nil;
    self.numberOfSixPlusWordsLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

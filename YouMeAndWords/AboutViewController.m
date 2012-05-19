//
//  SettingsViewController.m
//  YouMeAndWords
//
//  Created by Raj Kandati on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

- (IBAction)rateButtonTapped;

@end

@implementation AboutViewController

@synthesize delegate;

- (IBAction)rateButtonTapped
{
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str]; 
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
    
    // Here is the app id from itunesconnect
    str = [NSString stringWithFormat:@"", str]; 
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)backButtonTapped
{
    [self.delegate aboutViewController:self didTapBackButton:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

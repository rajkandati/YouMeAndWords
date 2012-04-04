//
//  AlphabetView.m
//  YouMeAndWords
//
//  Created by Raj Kandati on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlphabetView.h"
#import "YouMeAndWordsConstants.h"

@implementation AlphabetView
{
    UIButton *alphabetButton;
}

@synthesize alphabet = _alphabet;
@synthesize score = _score;
@synthesize delegate;

- (UIButton *)alphabetButton
{
    if (!alphabetButton) {
        alphabetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ALPHABET_WIDTH, ALPHABET_HEIGHT)];
    }
    return alphabetButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self alphabetButton].titleLabel.font = [UIFont systemFontOfSize:45];
        [[self alphabetButton].titleLabel setTextAlignment:UITextAlignmentCenter];
        [[self alphabetButton] addTarget:self action:@selector(alphabetPressed:) 
                        forControlEvents:UIControlEventTouchUpInside];
        [self setBackgroundColor:[UIColor grayColor]];
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCORE_X_ORIGIN, SCORE_Y_ORIGIN, SCORE_WIDTH, SCORE_HEIGHT)];
        scoreLabel.text = @"1";
        scoreLabel.textAlignment = UITextAlignmentCenter;
        scoreLabel.textColor = [UIColor whiteColor];
        [scoreLabel setBackgroundColor:[UIColor grayColor]];
        [[self alphabetButton] addSubview:scoreLabel];
        [self addSubview:alphabetButton];
    }
    return self;
}

- (void)resetAlphViewButtons
{
    UIButton *button = [self alphabetButton];
    [button setBackgroundColor:[UIColor grayColor]];
    button.enabled = YES;
        
    [[button.subviews lastObject] setBackgroundColor:[UIColor grayColor]];

}

- (void)setAlphabet:(NSString *)alphabet
{
    [[self alphabetButton] setTitle:alphabet forState:UIControlStateNormal];
}

- (void)alphabetPressed:(UIButton *)button
{
    [button setBackgroundColor:[UIColor orangeColor]];
    [[[button subviews] lastObject] setBackgroundColor:[UIColor orangeColor]];
    
    button.enabled = NO;
    [self.delegate alphabetView:self gotClickedWithbutton:button andAlphabet:button.titleLabel.text];
}

@end

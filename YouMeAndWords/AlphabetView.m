//
//  AlphabetView.m
//  YouMeAndWords
//
//  Created by Raj Kandati on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlphabetView.h"
#import "YouMeAndWordsConstants.h"

@interface AlphabetView()
@property(nonatomic,strong) UIButton *alphabetButton;
@property(nonatomic,strong) UILabel *scoreLabel;
@end

@implementation AlphabetView
{
    
    int sizeOfView;
}

@synthesize alphabet = _alphabet;
@synthesize score = _score;
@synthesize delegate = _delegate;
@synthesize alphabetButton = _alphabetButton;
@synthesize scoreLabel = _scoreLabel;

- (UIButton *)alphabetButton
{
    if (!_alphabetButton) {
        _alphabetButton = [[UIButton alloc] init];
        
    }
    return _alphabetButton;
}

- (UILabel*)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
    }
    return _scoreLabel;
}

- (UIImage *)getUIImageforSize:(int)size
{
    /*NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *pathForImageFile;
    if (size == 1) {
        pathForImageFile = [resourcePath stringByAppendingPathComponent:@"btn-alphabet(up)@2x.png"];
    } else {
        pathForImageFile = [resourcePath stringByAppendingPathComponent:@"btn-alphabet-small@2x.png"];
    }
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:pathForImageFile];
    UIImage *image = [[UIImage alloc] initWithData:imageData];*/
    UIImage *image;
    if (size == 1) {
        image = [UIImage imageNamed:@"btn-alphabet(up)"];
    } else {
        image = [UIImage imageNamed:@"btn-alphabet-small"];
    }
    return image;
}

- (UIImage *)getUIImageforSelectedButton
{
   /* NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *pathForImageFile;
    pathForImageFile = [resourcePath stringByAppendingPathComponent:@"btn-alphabet(down)@2x.png"];
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:pathForImageFile];
    UIImage *image = [[UIImage alloc] initWithData:imageData];*/
    UIImage *image = [UIImage imageNamed:@"btn-alphabet(down)"];
    return image;
}


- (id)initWithFrame:(CGRect)frame forScreenSize:(int)size
{
    self = [super initWithFrame:frame];
    if (self) {
        sizeOfView = size;
        [self.alphabetButton.titleLabel setTextAlignment:UITextAlignmentCenter];
        [self.alphabetButton addTarget:self action:@selector(alphabetPressed:) 
                        forControlEvents:UIControlEventTouchUpInside];        

        if (size == 1) {
            [self.scoreLabel setFrame:CGRectMake(SCORE_X_ORIGIN, SCORE_Y_ORIGIN, SCORE_WIDTH, SCORE_HEIGHT)];
            [self.alphabetButton setFrame:CGRectMake(0, 0, ALPHABET_WIDTH, ALPHABET_HEIGHT)];
            [self.alphabetButton setBackgroundImage:[self getUIImageforSize:1] forState:UIControlStateNormal];
            [self.alphabetButton setBackgroundImage:[self getUIImageforSelectedButton] forState:UIControlStateDisabled];
            self.scoreLabel.font = [UIFont systemFontOfSize:15];
            self.alphabetButton.titleLabel.font = [UIFont systemFontOfSize:45];
        } else {
            [self.scoreLabel setFrame:CGRectMake(SCORE_X_ORIGIN_SMALL, SCORE_Y_ORIGIN_SMALL, SCORE_WIDTH_SMALL, SCORE_HEIGHT_SMALL)];
            [self.alphabetButton setFrame:CGRectMake(0, 0, ALPHABET_WIDTH_SMALL, ALPHABET_HEIGHT_SMALL)];
            [self.alphabetButton setBackgroundImage:[self getUIImageforSize:0] forState:UIControlStateNormal];
            self.scoreLabel.font = [UIFont systemFontOfSize:10];
            self.alphabetButton.titleLabel.font = [UIFont systemFontOfSize:20];
            [self.alphabetButton setUserInteractionEnabled:FALSE];
        }
        self.scoreLabel.textAlignment = UITextAlignmentCenter;
        self.scoreLabel.textColor = [UIColor whiteColor];
        
        [self.scoreLabel setBackgroundColor:[UIColor clearColor]];
        [[self alphabetButton] addSubview:self.scoreLabel];
        [self addSubview:self.alphabetButton];
    }
    return self;
}

- (void)resetAlphViewButtons
{
    UIButton *button = [self alphabetButton];
   // [button setBackgroundColor:[UIColor grayColor]];
    button.enabled = YES;        
    //[[button.subviews lastObject] setBackgroundColor:[UIColor grayColor]];
}

- (void)setAlphabet:(NSString *)alphabet
{
    [self.alphabetButton setTitle:alphabet forState:UIControlStateNormal];
}

- (void)setScore:(NSString *)score
{
    [self.scoreLabel setText:score];
}

- (void)alphabetPressed:(UIButton *)button
{
    //[button setBackgroundColor:[UIColor orangeColor]];
    //[[[button subviews] lastObject] setBackgroundColor:[UIColor orangeColor]];
    
    button.enabled = NO;
    [self.delegate alphabetView:self gotClickedWithbutton:button andAlphabet:button.titleLabel.text];
}

@end

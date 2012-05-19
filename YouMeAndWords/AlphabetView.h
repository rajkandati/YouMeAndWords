//
//  AlphabetView.h
//  YouMeAndWords
//
//  Created by Raj Kandati on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlphabetView;

@protocol AlphabetViewDelegate <NSObject>
- (void)alphabetView:(AlphabetView *)view gotClickedWithbutton:(UIButton *)button andAlphabet:(NSString *)alphabet;

@end

@interface AlphabetView : UIView

@property(nonatomic, copy)NSString *alphabet;
@property(nonatomic, copy) NSString *score;
@property(nonatomic, weak) id <AlphabetViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame forScreenSize:(int)size;
- (void)resetAlphViewButtons;

@end

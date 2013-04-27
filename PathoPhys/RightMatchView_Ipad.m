//
//  RightMatchView_Ipad.m
//  CraftApp
//
//  Created by PUN-MAC-012 on 06/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "RightMatchView_Ipad.h"
#import <QuartzCore/QuartzCore.h>

@implementation RightMatchView_Ipad
@synthesize dotBt;
@synthesize customBt;
@synthesize ansImage;
@synthesize feedbackBt;
@synthesize strFeedback;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor = COLOR_CLEAR;
	
        
        dotBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [dotBt setExclusiveTouch:YES];
		[dotBt setBackgroundColor:COLOR_CLEAR];
        
        CALayer *l3 = [dotBt layer];
		[l3 setCornerRadius:15];
		//[l3 setBorderWidth:1];
		[l3 setBorderColor:[COLOR_CLEAR CGColor] ];
		[self addSubview:dotBt];
        
		customBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [customBt setUserInteractionEnabled:YES];
        [customBt setExclusiveTouch:YES];
		[customBt setBackgroundColor:COLOR_BottomGrayButton];
		customBt.titleLabel.font=FONT_14;
		[customBt setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
		customBt.titleLabel.textAlignment = UITextAlignmentLeft;
        
		CALayer *l2 = [customBt layer];
		[l2 setCornerRadius:9];
		[self addSubview:customBt];
        
        
        ansImage = [[UIImageView alloc]init];
		[self addSubview:ansImage];
        
        feedbackBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [feedbackBt setExclusiveTouch:YES];
		[feedbackBt setBackgroundColor:COLOR_CLEAR];
		[self addSubview:feedbackBt];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

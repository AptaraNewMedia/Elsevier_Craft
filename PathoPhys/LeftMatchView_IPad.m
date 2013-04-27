//
//  LeftMatchView_IPad.m
//  CraftApp
//
//  Created by PUN-MAC-012 on 05/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "LeftMatchView_IPad.h"
#import <QuartzCore/QuartzCore.h>

@implementation LeftMatchView_IPad
@synthesize dotBt;
@synthesize customBt;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor = COLOR_CLEAR;
        
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
		
		dotBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [dotBt setExclusiveTouch:YES];
		[dotBt setBackgroundColor:COLOR_CLEAR];        
       
        CALayer *l3 = [dotBt layer];
		[l3 setCornerRadius:15];
		//[l3 setBorderWidth:1];
		[l3 setBorderColor:[COLOR_CLEAR CGColor] ];
		[self addSubview:dotBt];

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

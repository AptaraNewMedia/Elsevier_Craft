//
//  FlipViewButton.m
//  PathoPhys
//
//  Created by PUN-MAC-012 on 25/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "FlipViewButton.h"

@implementation FlipViewButton
@synthesize textLabel;
@synthesize descLabel;
@synthesize selectedButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        textLabel=[[UILabel alloc] init];
		textLabel.textColor=COLOR_WHITE;
		textLabel.backgroundColor=COLOR_CLEAR;
		textLabel.font=FONT_25;
		textLabel.textAlignment=UITextAlignmentCenter;
		textLabel.numberOfLines=20;    	
		[self addSubview:textLabel];
        
        descLabel=[[UILabel alloc] init];
		descLabel.textColor=COLOR_LIGHTGRAY;
		descLabel.backgroundColor=COLOR_CLEAR;
		descLabel.font=FONT_10;
		descLabel.textAlignment=UITextAlignmentCenter;
		descLabel.numberOfLines=2;
        descLabel.text = @"";
		[self addSubview:descLabel];
        
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

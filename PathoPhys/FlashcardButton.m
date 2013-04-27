//
//  FlashcardButton.m
//  PathoPhys
//
//  Created by PUN-MAC-012 on 09/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "FlashcardButton.h"

@implementation FlashcardButton
@synthesize txtLabel;
@synthesize selectedButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        txtLabel = [[UILabel alloc] init];
		txtLabel.textColor=COLOR_DARKGRAY;
		txtLabel.backgroundColor=COLOR_CLEAR;
		txtLabel.font= FONT_17;
		txtLabel.textAlignment=UITextAlignmentCenter;
		txtLabel.numberOfLines = 50;
		txtLabel.lineBreakMode=UILineBreakModeWordWrap;
        
		[self addSubview:txtLabel];
        
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

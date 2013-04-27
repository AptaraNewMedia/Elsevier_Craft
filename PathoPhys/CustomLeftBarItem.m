//
//  CustomLeftBarItem.m
//  PathoPhys
//
//  Created by PUN-MAC-012 on 16/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "CustomLeftBarItem.h"

@implementation CustomLeftBarItem
@synthesize btnBack;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Initialization code
        UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
        btnHome.backgroundColor = COLOR_CLEAR;
        btnHome.frame = CGRectMake(10.0, 7.0, 39, 30);
        [btnHome setImage:[UIImage imageNamed:@"img_home_btn.png"] forState:UIControlStateNormal];
        [btnHome addTarget:self action:@selector(onHome:) forControlEvents:UIControlEventTouchUpInside];
        btnHome.exclusiveTouch = YES;
        [self addSubview:btnHome];
        
        btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.backgroundColor = COLOR_CLEAR;
        btnBack.frame = CGRectMake(60.0, 7.0, 53, 30);
        [btnBack setBackgroundImage:[UIImage imageNamed:@"img_back_btn.png"] forState:UIControlStateNormal];
        //[btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
        btnBack.exclusiveTouch = YES;
        [self addSubview:btnBack];

    }
    return self;
}

-(IBAction)onHome:(id)sender
{
    [md Fn_SubTabBar];
    [md Fn_AddMenu];
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

//
//  CustomRightBarItem.m
//  PathoPhys
//
//  Created by PUN-MAC-012 on 11/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "CustomRightBarItem.h"
#import "ScoreCardViewController.h"

@interface CustomRightBarItem()
{
    UIButton *Bn_AboutTheAuthor;
    UIButton *Bn_AboutTheApp;
    UIButton *Bn_AboutElsevierAustrelia;
    
    UIPopoverController *infoPopup;
    UIPopoverController *notePopup;
}

@end

@implementation CustomRightBarItem
@synthesize Bn_Addnote;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIButton *btnScore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnScore.backgroundColor = COLOR_CLEAR;
        btnScore.frame = CGRectMake(0.0, 7.0, 30, 30);
        [btnScore setImage:[UIImage imageNamed:@"img_topicon_score.png"] forState:UIControlStateNormal];
        [btnScore addTarget:self action:@selector(onScore:) forControlEvents:UIControlEventTouchUpInside];
        btnScore.exclusiveTouch = YES;
        [self addSubview:btnScore];
        
        UIButton *btnNote = [UIButton buttonWithType:UIButtonTypeCustom];
        btnNote.backgroundColor = COLOR_CLEAR;
        btnNote.frame = CGRectMake(40.0, 7.0, 30, 30);
        [btnNote setImage:[UIImage imageNamed:@"img_topicon_note.png"] forState:UIControlStateNormal];
        [btnNote addTarget:self action:@selector(onNote:) forControlEvents:UIControlEventTouchUpInside];
        btnNote.exclusiveTouch = YES;
        [self addSubview:btnNote];
        
        
        UIButton *btnInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        btnInfo.backgroundColor = COLOR_CLEAR;
        btnInfo.frame = CGRectMake(80.0, 7.0, 30, 30);
        [btnInfo setImage:[UIImage imageNamed:@"img_topicon_info.png"] forState:UIControlStateNormal];
        [btnInfo addTarget:self action:@selector(onInfo:) forControlEvents:UIControlEventTouchUpInside];
        btnInfo.exclusiveTouch = YES;
        [self addSubview:btnInfo];
        
        NSLog(@"Icons added");
          
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


-(IBAction)onScore:(id)sender
{
    [md Fn_removeNoteViewPopup];
    [md Fn_removeInfoViewPopup];
    [md Fn_AddScoreCard];
}

-(IBAction)onNote:(id)sender
{
    [md Fn_removeInfoViewPopup];
    [md Fn_ShowNoteViewPopup];
}

-(IBAction)onInfo:(id)sender
{
    [md Fn_removeNoteViewPopup];
    [md Fn_ShowInfoViewPopup];
}
/*
-(IBAction)Bn_AboutTheAuthor_Tapped:(id)sender
{
    [infoPopup dismissPopoverAnimated:YES];
    [md Fn_AddAbout:0];
}

-(IBAction)Bn_AboutTheApp_Tapped:(id)sender
{
    [infoPopup dismissPopoverAnimated:YES];
    [md Fn_AddAbout:1];
}

-(IBAction)Bn_AboutElsevierAustrelia_Tapped:(id)sender
{
    [infoPopup dismissPopoverAnimated:YES];
    [md Fn_AddAbout:2];
}

-(IBAction)Bn_AddNote_Tapped:(id)sender
{
    [notePopup dismissPopoverAnimated:YES];
    [md Fn_ShowNote:[sender tag]];
}

-(IBAction)Bn_ViewNote_Tapped:(id)sender
{
    [notePopup dismissPopoverAnimated:YES];
    [md Fn_AddNotesList];
}
*/
@end

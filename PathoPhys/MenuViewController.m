//
//  MenuViewController.m
//  PathoPhys
//
//  Created by Rohit Yermalkar on 05/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "MenuViewController.h"
#import "CustomRightBarItem.h"
#import <QuartzCore/QuartzCore.h>

@interface MenuViewController()
{
    IBOutlet UIImageView *imgBG;
    IBOutlet UIImageView *imgShadow;
    IBOutlet UIImageView *imgMenuBgFlashcard;
    IBOutlet UIImageView *imgMenuBgTestyourself;
    IBOutlet UIImageView *imgMenuBgCasestudy;
    IBOutlet UILabel *lblFlashcard;
    IBOutlet UILabel *lblTestyorself;
    IBOutlet UILabel *lblCasestudy;
    IBOutlet UIImageView *imgTopbar;
    IBOutlet UIButton *btnFlashcard;
    IBOutlet UIButton *btnTestyorself;
    IBOutlet UIButton *btnCasestudy;
    IBOutlet UISegmentedControl *segmentAbout;
    IBOutlet UILabel *lbl_Title;
        
    IBOutlet UIImageView *img_segment;
    IBOutlet UIButton *Bn_AbtAuthor;
    IBOutlet UIButton *Bn_AbtApp;
    IBOutlet UIButton *Bn_AbtElsevier;
    
    CustomRightBarItem *customRightBar;
    NSInteger currentOrientaion;
}

@end

@implementation MenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fnAddNavigationItems];
    
    //self.trackedViewName = @"Menu Screen";
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        lblFlashcard.font = FONT_12;
        lblTestyorself.font = FONT_12;
        lblCasestudy.font = FONT_12;
        lbl_Title.font = BOLD_FONT_20;
    }
    else {
        lblFlashcard.font = FONT_18;
        lblTestyorself.font = FONT_18;
        lblCasestudy.font = FONT_18;
        lbl_Title.font = BOLD_FONT_20;
    }
    
    lblFlashcard.textColor = COLOR_FlashcardHeadingText;
    lblTestyorself.textColor = COLOR_FlashcardHeadingText;
    lblCasestudy.textColor = COLOR_FlashcardHeadingText;
    lbl_Title.textColor = COLOR_WHITE;
    
    
    
    /*
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:COLOR_BottomBlueButton forKey:UITextAttributeTextColor];
    [segmentAbout setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    
     
     for (UIView *v in [[[segment subviews] objectAtIndex:0] subviews]) {
     if ([v isKindOfClass:[UILabel class]]) {
     UILabel *lable=(UILabel *)[v retain];
     lable.textColor=[UIColor blackColor];
     }
     }
     
     */
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
}

- (void) fnAddNavigationItems
{
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        customRightBar = [[CustomRightBarItem alloc] initWithFrame:CGRectMake(220, 0, 100, 44)];
        
        customRightBar.btnScore.frame = CGRectMake(0.0, 7.0, 30, 30);
        customRightBar.btnNote.frame = CGRectMake(35.0, 7.0, 30, 30);
        customRightBar.btnInfo.frame = CGRectMake(70.0, 7.0, 30, 30);
        
    }
    else {
    
    customRightBar = [[CustomRightBarItem alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
    }
    [self.view addSubview:customRightBar];
        
    NOTES_MODE = 0;
    
}

- (IBAction)Bn_FC_Tapped:(id)sender{
    [md Fn_SubMenu];
    categoryNumber = 1;    
    [md Fn_addTabBar];
    [md.tabBarController setSelectedIndex:0];
}
- (IBAction)Bn_TY_Tapped:(id)sender{
    [md Fn_SubMenu];
    categoryNumber = 2;
    [md Fn_addTabBar];
    [md.tabBarController setSelectedIndex:1];
}
- (IBAction)Bn_CS_Tapped:(id)sender{
    [md Fn_SubMenu];
    categoryNumber = 3;
    [md Fn_addTabBar];
    [md.tabBarController setSelectedIndex:2];
}


-(IBAction)onSegment:(id)sender
{
    [md Fn_AddAbout:[sender tag]];    
}


#pragma Orientation
//------------------------------
- (BOOL) shouldAutorotate{
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    currentOrientaion = interfaceOrientation;
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations
{
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        return NO;
    }
    
    NSUInteger mask= UIInterfaceOrientationMaskPortrait;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    currentOrientaion = interfaceOrientation;
    DEVICE_ORIENTATION = interfaceOrientation;
    [md Fn_CallPopupOrientaion];
    if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        [self Fn_rotateLandscape];
        
        mask  |= UIInterfaceOrientationMaskLandscapeLeft;
        
    }
    else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
       	[self Fn_rotateLandscape];
        mask |= UIInterfaceOrientationMaskLandscapeRight;
        
	}
	else if(interfaceOrientation==UIInterfaceOrientationPortrait){
     	[self Fn_rotatePortrait];
        mask  |=UIInterfaceOrientationMaskPortraitUpsideDown;
        
	}
	else {
        [self Fn_rotatePortrait];
        mask  |=UIInterfaceOrientationMaskPortrait;
        
	}
    return UIInterfaceOrientationMaskAll;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        return NO;
    }
    
    currentOrientaion = interfaceOrientation;
    DEVICE_ORIENTATION = interfaceOrientation;    
    [md Fn_CallPopupOrientaion];    
    if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        [self Fn_rotateLandscape];
        return YES;
    }
    else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
		[self Fn_rotateLandscape];
        return YES;
	}
	else if(interfaceOrientation==UIInterfaceOrientationPortrait){
		[self Fn_rotatePortrait];
        return YES;
	}
	else {
        [self Fn_rotatePortrait];
        return YES;
	}
    
	return YES;
}
//------------------------------

-(void)Fn_rotatePortrait
{
    //
    [imgMenuBgFlashcard setFrame:CGRectMake(10, 250, 258, 399)];
    [imgMenuBgTestyourself setFrame:CGRectMake(255, 250, 258, 399)];
    [imgMenuBgCasestudy setFrame:CGRectMake(500, 250, 258, 399)];
    
    [lbl_Title setFrame:CGRectMake(280, 1, 208, 43)];
    
    [lblFlashcard setFrame:CGRectMake(30, 286, 227, 30)];
    [lblTestyorself setFrame:CGRectMake(270, 286, 227, 30)];
    [lblCasestudy setFrame:CGRectMake(520, 286, 227, 30)];
    
    [btnFlashcard setFrame:CGRectMake(30, 265, 227, 303)];
    [btnTestyorself setFrame:CGRectMake(270, 265, 227, 303)];
    [btnCasestudy setFrame:CGRectMake(520, 265, 227, 303)];
    
    [segmentAbout setFrame:CGRectMake(15, 668, 742, 59)];
    
    [imgBG setFrame:CGRectMake(0, 0, 768, 1024)];
    [imgBG setImage:[UIImage imageNamed:@"img_bg_p.png"]];
    
    [imgShadow setFrame:CGRectMake(0, 343, 768, 422)];
    [imgShadow setImage:[UIImage imageNamed:@"img_bg_shadow_p.png"]];
    
    [customRightBar setFrame:CGRectMake(630, 0, 130, 44)] ;
    
    [img_segment setFrame:CGRectMake(10,650,754,74)];
    [Bn_AbtAuthor setFrame:CGRectMake(10,650,247,74)];
    [Bn_AbtApp setFrame:CGRectMake(257,650,245,74)];
    [Bn_AbtElsevier setFrame:CGRectMake(511,650,247,74)];
}

-(void)Fn_rotateLandscape
{
    [imgMenuBgFlashcard setFrame:CGRectMake(130, 180, 258, 399)];
    [imgMenuBgTestyourself setFrame:CGRectMake(381, 180, 258, 399)];
    [imgMenuBgCasestudy setFrame:CGRectMake(632, 180, 258, 399)];

    [lbl_Title setFrame:CGRectMake(406, 1, 208, 43)];
    
    [lblFlashcard setFrame:CGRectMake(146, 216, 227, 30)];
    [lblTestyorself setFrame:CGRectMake(398, 216, 227, 30)];
    [lblCasestudy setFrame:CGRectMake(650, 216, 227, 30)];
    
    [btnFlashcard setFrame:CGRectMake(146, 195, 227, 303)];
    [btnTestyorself setFrame:CGRectMake(398, 195, 227, 303)];
    [btnCasestudy setFrame:CGRectMake(650, 195, 227, 303)];
    
    [segmentAbout setFrame:CGRectMake(141, 596, 742, 59)];

    [imgBG setFrame:CGRectMake(0, 0, 1024, 768)];
    [imgBG setImage:[UIImage imageNamed:@"img_bg.png"]];
    
    [imgShadow setFrame:CGRectMake(0, 300, 1024, 437)];
    [imgShadow setImage:[UIImage imageNamed:@"img_bg_shadow.png"]];

    [customRightBar setFrame:CGRectMake(890, 0, 130, 44)] ;
    
    [img_segment setFrame:CGRectMake(135,573,754,74)];
    [Bn_AbtAuthor setFrame:CGRectMake(139,573,247,74)];
    [ Bn_AbtApp setFrame:CGRectMake(388,573,245,74)];
    [Bn_AbtElsevier setFrame:CGRectMake(635,573,247,74)];
    
}

//

@end

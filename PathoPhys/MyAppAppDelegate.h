//
//  MyAppAppDelegate.h
//  PathoPhys
//
//  Created by Rohit Yermalkar on 05/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  MenuViewController;
@class  Notes;


@interface MyAppAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UINavigationController *navController1, *navController2, *navController3;

@property (strong, nonatomic) MenuViewController *menuViewController;

@property (strong, nonatomic) NSString *strCurrentDate;

- (void) Fn_AddMenu;
- (void) Fn_SubMenu;
- (void) Fn_addTabBar;
- (void) Fn_SubTabBar;

-(void) Fn_AddAbout:(int)index;
-(void) Fn_SubAbout;

-(void) Fn_AddNote:(Notes *)notes;
-(void) Fn_ShowNote:(int)mode;
-(void) Fn_HideAddNoteButton;
-(void) Fn_SubAddNote;

-(void) Fn_AddNotesList;
-(void) Fn_SubNotesList;

-(void) Fn_AddScoreCard;
-(void) Fn_SubScoreCard;

-(void) Fn_AddCaseStudyText;
-(void) Fn_SubCaseStudyText;

-(void) Fn_ShowNoteViewPopup;
-(void) Fn_removeNoteViewPopup;

-(void) Fn_ShowInfoViewPopup;
-(void) Fn_removeInfoViewPopup;

- (int) charToScore:(char) character;

-(void) Fn_CallPopupOrientaion;

@end

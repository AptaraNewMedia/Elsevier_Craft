//
//  MyAppAppDelegate.m
//  PathoPhys
//
//  Created by Rohit Yermalkar on 05/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "MyAppAppDelegate.h"
#import "SQLiteManager.h"
#import "DatabaseOperation.h"


#import "TestyourselfChapterListViewController.h"
#import "FlashcardChapterListViewController.h"
#import "CasestudyChapterListViewController.h"

#import "MenuViewController.h"

#import "AboutUsViewController.h"
#import "ScoreCardViewController.h"
#import "AddNoteViewController.h"
#import "NotesListViewController.h"
#import "NotesPopViewController.h"
#import "InfoPopViewController.h"
#import "Notes.h"
#import "CasestudyTextPopup.h"

#import "GAI.h"

UIView *feedbackView;
UIImageView *img_feedback;
UITextView *txt_feedback;

@interface MyAppAppDelegate ()
{
    
    AboutUsViewController *aboutUsView;
    ScoreCardViewController *scoreCardView;
    AddNoteViewController *addNotesView;
    NotesListViewController *notesListView;
    NotesPopViewController *NotePopupView;
    InfoPopViewController *InfoPopupView;
    CasestudyTextPopup *casestudyTextView;
}

@end

@implementation MyAppAppDelegate

@synthesize tabBarController;
@synthesize navController;
@synthesize navController1;
@synthesize navController2;
@synthesize navController3;
@synthesize menuViewController;
@synthesize strCurrentDate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //Database Operation
    SQLiteManager *dbManager = [[SQLiteManager alloc] init];
    [dbManager createDatabaseInApplicationDirectory];
    db = [[DatabaseOperation alloc] init];
    
    [db fnGetTestyourselfChapterList];
    [db fnGetCaseStudyChapterList];
    
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-3774595-26"];
    
    //Current Date
    //--------------------------------------------------
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSDate *currentDate = [NSDate date];
    strCurrentDate = [dateFormat stringFromDate:currentDate];
    //--------------------------------------------------
    
    
    DEVICE_TYPE = [UIDevice currentDevice].model;
    DEVICE_VERSION = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    
    md = (MyAppAppDelegate *)[[UIApplication sharedApplication] delegate];

    [self Fn_AddMenu];
   
    
    [self.window makeKeyAndVisible];
    return YES;
}

// Menu
- (void) Fn_AddMenu{
    MenuViewController *menuView;
    if([UIScreen mainScreen].bounds.size.height == 568.0){
        menuView = [[MenuViewController alloc] initWithNibName:@"MenuViewController_iPhone5" bundle:nil];
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        menuView = [[MenuViewController alloc] initWithNibName:@"MenuViewController_iPhone" bundle:nil];
    }
    else {
        menuView = [[MenuViewController alloc] initWithNibName:@"MenuViewController_iPad" bundle:nil];
    }
    
	[self setMenuViewController:menuView];
	[self.window addSubview:[menuViewController view]];
    self.window.rootViewController = menuViewController;
}
- (void) Fn_SubMenu{
    [menuViewController.view removeFromSuperview];
	menuViewController = nil;
}

// Tab bar
- (void) Fn_addTabBar{
    UIViewController *viewController1, *viewController2, *viewController3;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //viewController1 = [[MyAppFirstViewController alloc] initWithNibName:@"MyAppFirstViewController_iPhone" bundle:nil];
        //viewController2 = [[MyAppSecondViewController alloc] initWithNibName:@"MyAppSecondViewController_iPhone" bundle:nil];
        //viewController3 = [[MyAppThirdViewController alloc] initWithNibName:@"MyAppThirdViewController_iPhone" bundle:nil];
    } else {
        viewController1 = [[FlashcardChapterListViewController alloc] initWithNibName:@"FlashcardChapterListViewController_iPad" bundle:nil];        
        navController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
        
        viewController2 = [[TestyourselfChapterListViewController alloc] initWithNibName:@"TestyourselfChapterListViewController_iPad" bundle:nil];
        navController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
        
        viewController3 = [[CasestudyChapterListViewController alloc] initWithNibName:@"CasestudyChapterListViewController_iPad" bundle:nil];
        navController3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
        
    }
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[navController1, navController2, navController3];
    self.window.rootViewController = self.tabBarController;

}
- (void) Fn_SubTabBar{
    [self.tabBarController.view removeFromSuperview];
	self.tabBarController = nil;

}

// About
-(void) Fn_AddAbout:(int)index{
    aboutUsView = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController_iPad" bundle:nil];
    [self.window.rootViewController.view addSubview:aboutUsView.view];
    [aboutUsView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [aboutUsView Fn_LoadAboutData:index];
    
}
-(void) Fn_SubAbout{
    [aboutUsView.view removeFromSuperview];
}

// Add note
-(void) Fn_AddNote:(Notes *)notes{    
    [self Fn_SubAddNote];
    addNotesView = [[AddNoteViewController alloc] initWithNibName:@"AddNoteViewController_iPad" bundle:nil];
    [addNotesView Fn_LoadNoteData:notes];
    
}
-(void) Fn_ShowNote:(int)mode{
    [self.window.rootViewController.view addSubview:addNotesView.view];
    [addNotesView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
}
-(void) Fn_SubAddNote{
    [addNotesView.view removeFromSuperview];
}

// Note List
-(void) Fn_AddNotesList{
    [self Fn_SubNotesList];
    notesListView = [[NotesListViewController alloc] initWithNibName:@"NotesListViewController_iPad" bundle:nil];
    
//    UINavigationController *nav = (UINavigationController*)tabBarController.selectedViewController;
//    [nav pushViewController:notesListView animated:YES];

    [self.window.rootViewController.view addSubview:notesListView.view];
    [notesListView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
}
-(void) Fn_SubNotesList{
    [notesListView.view removeFromSuperview];
}

// Score Card
-(void) Fn_AddScoreCard{
    scoreCardView =[[ScoreCardViewController alloc] initWithNibName:@"ScoreCardViewController_iPad" bundle:nil];
    [self.window.rootViewController.view addSubview:scoreCardView.view];   
    [scoreCardView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
}
-(void) Fn_SubScoreCard{
    [scoreCardView.view removeFromSuperview];
}

// Note Popup
-(void) Fn_ShowNoteViewPopup{
    [self Fn_removeNoteViewPopup];
    NotePopupView =[[NotesPopViewController alloc] initWithNibName:@"NotesPopViewController" bundle:nil];
    [self.window.rootViewController.view addSubview:NotePopupView.view];
    [NotePopupView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    if (NOTES_MODE == 1)
        [NotePopupView.Bn_Addnote setTitle:@"Add Note" forState:UIControlStateNormal];
    else if (NOTES_MODE == 2)
        [NotePopupView.Bn_Addnote setTitle:@"Edit Note" forState:UIControlStateNormal];    
    else
        NotePopupView.Bn_Addnote.hidden = YES;
    
    
}
-(void) Fn_removeNoteViewPopup{
    [NotePopupView.view removeFromSuperview];
}

// Info Popup
-(void) Fn_ShowInfoViewPopup{
    [self Fn_removeInfoViewPopup];
    InfoPopupView=[[InfoPopViewController alloc] initWithNibName:@"InfoPopViewController" bundle:nil];
    [self.window.rootViewController.view addSubview:InfoPopupView.view];
    [InfoPopupView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
}
-(void) Fn_removeInfoViewPopup{
    [InfoPopupView.view removeFromSuperview];
}

//img_feedback_right_box
- (int) charToScore:(char) character {
    switch (character) {
        case 'a':
            return 1;
        case 'b':
            return 2;
        case 'c':
            return 3;
        case 'd':
            return 4;
        case 'e':
            return 5;
        case 'f':
            return 6;
        case 'g':
            return 7;
        case 'h':
            return 8;
        case 'i':
            return 9;
        case 'j':
            return 10;
        case 'k':
            return 11;
        case 'l':
            return 12;
        case 'm':
            return 13;
        case 'n':
            return 14;
        case '0':
            return 15;
        case 'p':
            return 16;
        case 'q':
            return 17;
            
        default:
            return 0;
    }
}

// Casestudy Text
-(void) Fn_AddCaseStudyText {
 //   CasestudyTextPopup
    casestudyTextView =[[CasestudyTextPopup alloc] initWithNibName:@"CasestudyTextPopup_iPad" bundle:nil];
    [self.window.rootViewController.view addSubview:casestudyTextView.view];
    [casestudyTextView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
}

-(void) Fn_SubCaseStudyText {
    [casestudyTextView.view removeFromSuperview];
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    categoryNumber =  tabBarController.selectedIndex + 1;
    [self Fn_removeNoteViewPopup];
    [self Fn_removeInfoViewPopup];
}

-(void) Fn_CallPopupOrientaion {
    [InfoPopupView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [NotePopupView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [aboutUsView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [addNotesView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [notesListView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [scoreCardView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [casestudyTextView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
}

@end

@implementation UITabBarController (Custom)

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // You do not need this method if you are not supporting earlier iOS Versions
    DEVICE_ORIENTATION = interfaceOrientation;
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(NSUInteger)supportedInterfaceOrientations
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    DEVICE_ORIENTATION = interfaceOrientation;    
    return [self.selectedViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end


@implementation UINavigationController (Custom)

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // You do not need this method if you are not supporting earlier iOS Versions
    DEVICE_ORIENTATION = interfaceOrientation;
    [md Fn_CallPopupOrientaion];
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(NSUInteger)supportedInterfaceOrientations
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    DEVICE_ORIENTATION = interfaceOrientation;
    [md Fn_CallPopupOrientaion];
    return [self.topViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    return YES;
}
@end

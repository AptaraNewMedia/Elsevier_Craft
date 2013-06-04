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
#import "ResultViewController.h"
#import "NotesListNewViewController.h"

#import "TestYourSelfViewController.h"
#import "CaseStudyViewController.h"

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
    ResultViewController *resultView;
    NotesListNewViewController *notesListNewViewController;
    
    int shouldSelectTabbarIndex;
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
    
    
    //NSLog(@"Type: %@",DEVICE_TYPE);
    
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
    if([UIScreen mainScreen].bounds.size.height == 568.0){
        viewController1 = [[FlashcardChapterListViewController alloc] initWithNibName:@"FlashcardChapterListViewController_iPhone5" bundle:nil];
        navController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
        
        viewController2 = [[TestyourselfChapterListViewController alloc] initWithNibName:@"TestyourselfChapterListViewController_iPhone5" bundle:nil];
        navController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
        
        viewController3 = [[CasestudyChapterListViewController alloc] initWithNibName:@"CasestudyChapterListViewController_iPhone5" bundle:nil];
        navController3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
    }
    
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[FlashcardChapterListViewController alloc] initWithNibName:@"FlashcardChapterListViewController_iPhone" bundle:nil];
        navController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
        
        viewController2 = [[TestyourselfChapterListViewController alloc] initWithNibName:@"TestyourselfChapterListViewController_iPhone" bundle:nil];
        navController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
        
        viewController3 = [[CasestudyChapterListViewController alloc] initWithNibName:@"CasestudyChapterListViewController_iPhone" bundle:nil];
        navController3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        aboutUsView = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController_iPhone" bundle:nil];
    }
    else{
        aboutUsView = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController_iPad" bundle:nil];
        [aboutUsView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    }
    [self.window.rootViewController.view addSubview:aboutUsView.view];
    
    [aboutUsView Fn_LoadAboutData:index];
    
}
-(void) Fn_SubAbout{
    [aboutUsView.view removeFromSuperview];
}

// Add note
-(void) Fn_AddNote:(Notes *)notes{
    [self Fn_SubAddNote];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        addNotesView = [[AddNoteViewController alloc] initWithNibName:@"AddNoteViewController_iPhone" bundle:nil];
    }
    else
    {
        addNotesView = [[AddNoteViewController alloc] initWithNibName:@"AddNoteViewController_iPad" bundle:nil];
    }
    
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
    
    if([UIScreen mainScreen].bounds.size.height == 568.0){
        notesListView = [[NotesListViewController alloc] initWithNibName:@"NotesListViewController_iPhone5" bundle:nil];
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        notesListView = [[NotesListViewController alloc] initWithNibName:@"NotesListViewController_iPhone" bundle:nil];
    }
    else
    {
        notesListView = [[NotesListViewController alloc] initWithNibName:@"NotesListViewController_iPad" bundle:nil];
    }
    notesListView.FromMenu = 0;
    
    if (categoryNumber == 1) {
        [navController1 pushViewController:notesListView animated:YES];
    }
    else if (categoryNumber == 2) {
        [navController2 pushViewController:notesListView animated:YES];
    }
    else if (categoryNumber == 3) {
        [navController3 pushViewController:notesListView animated:YES];
    }
    else {
        [self Fn_AddNotesListOnMenu];
    }
 
    //[self.window.rootViewController.view addSubview:notesListView.view];
    [notesListView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
}
-(void) Fn_SubNotesList{
    [notesListView.view removeFromSuperview];
}

// Score Card
-(void) Fn_AddScoreCard{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        scoreCardView =[[ScoreCardViewController alloc] initWithNibName:@"ScoreCardViewController_iPhone" bundle:nil];
    }
    else{
        scoreCardView =[[ScoreCardViewController alloc] initWithNibName:@"ScoreCardViewController_iPad" bundle:nil];
        [scoreCardView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    }
    
    [self.window.rootViewController.view addSubview:scoreCardView.view];
}
-(void) Fn_SubScoreCard{
    [scoreCardView.view removeFromSuperview];
}

// Note Popup
-(void) Fn_ShowNoteViewPopup{
    [self Fn_removeNoteViewPopup];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        NotePopupView =[[NotesPopViewController alloc] initWithNibName:@"NotesPopViewController_iPhone" bundle:nil];
        [self.window.rootViewController.view addSubview:NotePopupView.view];
    }
    else
    {
        NotePopupView =[[NotesPopViewController alloc] initWithNibName:@"NotesPopViewController" bundle:nil];
        [self.window.rootViewController.view addSubview:NotePopupView.view];
        [NotePopupView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    }
    
    //    [self.window.rootViewController.view addSubview:NotePopupView.view];
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
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        InfoPopupView=[[InfoPopViewController alloc] initWithNibName:@"InfoPopViewController_iPhone" bundle:nil];
    }
    else
    {
        InfoPopupView=[[InfoPopViewController alloc] initWithNibName:@"InfoPopViewController" bundle:nil];
        [InfoPopupView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    }
    
    [self.window.rootViewController.view addSubview:InfoPopupView.view];
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


// Result
-(void) Fn_AddResult:(NSString *)chaptername AndThematicNAme:(NSString *)thematicName AndScore:(NSString *)score  {
    
    [resultView.view removeFromSuperview];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        resultView =[[ResultViewController alloc] initWithNibName:@"ResultViewController_iPhone" bundle:nil];
    }
    else
    {
        resultView =[[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
    }
    
    [self.window.rootViewController.view addSubview:resultView.view];
    [resultView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    
    resultView.lblChapterName.text = chaptername;
    resultView.lblThematicArea.text = thematicName;
    resultView.lblScore.text = score;
    
}
-(void) Fn_SubResult {
    [resultView.view removeFromSuperview];
}

// Add NoteList On Menu
-(void) Fn_AddNotesListOnMenu{
    [self Fn_SubNotesListOnMenu];
    if([UIScreen mainScreen].bounds.size.height == 568.0){
        notesListView = [[NotesListViewController alloc] initWithNibName:@"NotesListViewController_iPhone5" bundle:nil];
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        notesListView = [[NotesListViewController alloc] initWithNibName:@"NotesListViewController_iPhone" bundle:nil];
    }
    else
    {
        notesListView = [[NotesListViewController alloc] initWithNibName:@"NotesListViewController_iPad" bundle:nil];
    }
    notesListView.FromMenu = 1;
    [notesListView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    navController = [[UINavigationController alloc] initWithRootViewController:notesListView];
    self.window.rootViewController = navController;
}
-(void) Fn_SubNotesListOnMenu{
    [navController.view removeFromSuperview];
    navController = nil;
}

// TabBar
- (void)tabBarController:(UITabBarController *)tabBarController1 didSelectViewController:(UIViewController *)viewController
{
    
        categoryNumber =  tabBarController1.selectedIndex + 1;
        [self Fn_SubTabBar];
        [self Fn_addTabBar];
        self.tabBarController.selectedIndex = categoryNumber - 1;
        [self Fn_removeNoteViewPopup];
        [self Fn_removeInfoViewPopup];
}

- (BOOL)tabBarController:(UITabBarController *)tbController shouldSelectViewController:(UIViewController *)viewController
{
    shouldSelectTabbarIndex = tbController.selectedIndex;
    if(isTestInProgress == 1){
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Pathophysquiz"];
        [alert setDelegate:self];
        [alert setTag:BOOKMARKING_ALERT_TAG];
        [alert addButtonWithTitle:@"YES"];
        [alert addButtonWithTitle:@"NO"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessage:[NSString stringWithFormat:MSG_BOOKMARK_TEST]];
        [alert show];
    }
    else if(isTestInProgress == 2){
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Pathophysquiz"];
        [alert setDelegate:self];
        [alert setTag:BOOKMARKING_ALERT_TAG];
        [alert addButtonWithTitle:@"YES"];
        [alert addButtonWithTitle:@"NO"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessage:[NSString stringWithFormat:MSG_BOOKMARK_CASESTUDY]];
        [alert show];
    }
    else {
        return YES;
    }
    
    return NO;
    
}
// Alertview
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == BOOKMARKING_ALERT_TAG){
        if(buttonIndex == 0){  // YES
            NSLog(@"YES");
            
            if (tabBarController.selectedIndex+1 == 2) {
                TestYourSelfViewController *obj = (TestYourSelfViewController *)self.navController2.visibleViewController;
                [obj Fn_SaveBookmarkingData];
                
            }
            else if (tabBarController.selectedIndex+1 == 3) {
                CaseStudyViewController *obj = (CaseStudyViewController *)self.navController3.visibleViewController;
                [obj Fn_SaveBookmarkingData];
                
            }
            
            categoryNumber =  shouldSelectTabbarIndex + 1;
            [self Fn_SubTabBar];
            [self Fn_addTabBar];
            self.tabBarController.selectedIndex = categoryNumber - 1;
            [self Fn_removeNoteViewPopup];
            [self Fn_removeInfoViewPopup];
        }
        else         if(buttonIndex == 1){  // YES
            NSLog(@"YES");
            
            if (tabBarController.selectedIndex+1 == 2) {
                TestYourSelfViewController *obj = (TestYourSelfViewController *)self.navController2.visibleViewController;
                [obj Fn_DeleteBookmarkingData];
                
            }
            else if (tabBarController.selectedIndex+1 == 3) {
                CaseStudyViewController *obj = (CaseStudyViewController *)self.navController3.visibleViewController;
                [obj Fn_DeleteBookmarkingData];
                
            }
            
            categoryNumber =  shouldSelectTabbarIndex + 1;
            [self Fn_SubTabBar];
            [self Fn_addTabBar];
            self.tabBarController.selectedIndex = categoryNumber - 1;
            [self Fn_removeNoteViewPopup];
            [self Fn_removeInfoViewPopup];
        }
    }
}

// Popup
-(void) Fn_CallPopupOrientaion {
    [InfoPopupView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [NotePopupView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [aboutUsView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [addNotesView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [notesListView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [scoreCardView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [casestudyTextView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
    [resultView shouldAutorotateToInterfaceOrientation:DEVICE_ORIENTATION];
}

//images
-(void) Fn_ZoomImgWithView:(UIView *)view
{
    [self.window.rootViewController.view addSubview:view];
}

@end

@implementation UITabBarController (Custom)

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return NO;
    }
    
    // You do not need this method if you are not supporting earlier iOS Versions
    DEVICE_ORIENTATION = interfaceOrientation;
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return NO;
    }

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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return NO;
    }
    // You do not need this method if you are not supporting earlier iOS Versions
    DEVICE_ORIENTATION = interfaceOrientation;
    [md Fn_CallPopupOrientaion];
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return NO;
    }

    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    DEVICE_ORIENTATION = interfaceOrientation;
    //NSLog(@"Navigation Orientation   %d", DEVICE_ORIENTATION);
    [md Fn_CallPopupOrientaion];
    return [self.topViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    return YES;
}
@end

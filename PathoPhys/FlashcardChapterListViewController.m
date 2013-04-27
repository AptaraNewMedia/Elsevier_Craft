//
//  ChapterListViewController.m
//  CraftApp
//
//  Created by Rohit Yermalkar on 20/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "FlashcardChapterListViewController.h"
#import "ChapterlistCell_iPad.h"
#import "Chapters.h"
#import "ThematicArea.h"
#import "FlashCardsViewController.h"
#import "CustomRightBarItem.h"
#import "CustomLeftBarItem.h"


@interface FlashcardChapterListViewController ()
{
    IBOutlet UIImageView *imgBG;
    IBOutlet UIImageView *imgShadow;
    IBOutlet UIImageView *imgChapterBG;
    IBOutlet UITableView *myTableView;
    IBOutlet UILabel *lbl_title;
    IBOutlet UIButton *btnViewAll;    
    
    NSMutableArray *arr_chapterList;

    FlashCardsViewController *flashCardsViewController;
    CustomRightBarItem *customRightBar;
    CustomLeftBarItem *customLeftBar;
    NSInteger currentOrientaion;
}
@end

@implementation FlashcardChapterListViewController
@synthesize openSectionIndex;

// VIEW DEFAULT Methods
//=======================================================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"FlashCard", @"FlashCard");
        self.tabBarItem.image = [UIImage imageNamed:@"img_tab_flashcard"];
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
   
    lbl_title.font = FONT_25;
    lbl_title.textColor = COLOR_WHITE;
    
    [self fnAddNavigationItems];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    float currentVersion = 6.0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion)
    {
        [self supportedInterfaceOrientations];
    }
    else{
        [self shouldAutorotateToInterfaceOrientation:currentOrientaion];
    }
    
    
    
}
- (void) fnAddNavigationItems{
    
    if (DEVICE_VERSION >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_topbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [self.navigationController.navigationBar setTintColor:COLOR_BLUE];
    
    customLeftBar = [[CustomLeftBarItem alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UIBarButtonItem *btnBar1 = [[UIBarButtonItem alloc] initWithCustomView:customLeftBar];
    self.navigationItem.leftBarButtonItem = btnBar1;
    [customLeftBar.btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    customLeftBar.btnBack.hidden = YES;
    
    customRightBar = [[CustomRightBarItem alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
    UIBarButtonItem *btnBar = [[UIBarButtonItem alloc] initWithCustomView:customRightBar];
    self.navigationItem.rightBarButtonItem = btnBar;
 
    NOTES_MODE = 0;
}
- (IBAction)onHome:(id)sender{
    [md Fn_SubTabBar];
    [md Fn_AddMenu];
}
//=======================================================================================


// TableView Delegate Methods
//=======================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arr_chaptersTestAndFlashcard count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    //--------------------------------------------------
    static NSString *MyIdentifier = @"tblCellView";
    ChapterlistCell_iPad *cell = (ChapterlistCell_iPad *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"ChapterlistCell_iPad" owner:self options:nil];
        cell = [cellArray lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.lblChapterName.font = FONT_17;
    cell.lblChapterName.textColor = COLOR_BLACK;
    
    
    
    Chapters *objChap = (Chapters *) [arr_chaptersTestAndFlashcard objectAtIndex:indexPath.row];
    cell.lblChapterName.text = [NSString stringWithFormat:@"%d. %@",indexPath.row + 1,objChap.strChapterTitle];    
    
    if (currentOrientaion==UIInterfaceOrientationLandscapeRight||currentOrientaion==UIInterfaceOrientationLandscapeLeft) {
       cell.imgTableCellBG.image=[UIImage imageNamed:@"chapter_tbl_row_center.png"];
        [cell.imgDisclosure setFrame:CGRectMake(720, 14, 27, 27)];
        
    }
    else {
       cell.imgTableCellBG.image=[UIImage imageNamed:@"chapter_tbl_row_center_p.png"];
        [cell.imgDisclosure setFrame:CGRectMake(570, 14, 27, 27)];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //md.str_Title = [arr_chapterList objectAtIndex:indexPath.row];
    //[md Fn_SubChapterList];

    Chapters *objChap = (Chapters *)[arr_chaptersTestAndFlashcard objectAtIndex:indexPath.row];
    intCurrentFlashcard_ChapterId = objChap.intChapterId;
    str_BarTitle = [NSString stringWithFormat:@"Flash Cards - %@", objChap.strChapterTitle];
    
    ChapterlistCell_iPad *cell1 = (ChapterlistCell_iPad *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (currentOrientaion==UIInterfaceOrientationLandscapeRight||currentOrientaion==UIInterfaceOrientationLandscapeLeft)
         cell1.imgTableCellBG.image=[UIImage imageNamed:@"Selected_chapter_tbl_row_center.png"];
    else
         cell1.imgTableCellBG.image=[UIImage imageNamed:@"Selected_chapter_tbl_row_center_p.png"];
    
    
    flashCardsViewController = [[FlashCardsViewController alloc] initWithNibName:@"FlashCardsViewController_iPad" bundle:nil];
    
    [self.navigationController pushViewController:flashCardsViewController animated:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChapterlistCell_iPad *cell1 = (ChapterlistCell_iPad *)[tableView cellForRowAtIndexPath:indexPath];
    if (currentOrientaion==UIInterfaceOrientationLandscapeRight||currentOrientaion==UIInterfaceOrientationLandscapeLeft)
        cell1.imgTableCellBG.image=[UIImage imageNamed:@"chapter_tbl_row_center.png"];
    else
        cell1.imgTableCellBG.image=[UIImage imageNamed:@"chapter_tbl_row_center_p.png"];
}
//=======================================================================================


// IBAction Methods
//=======================================================================================
- (IBAction)Bn_Back_Tapped:(id)sender{
   // [md Fn_SubChapterList];
    [md Fn_AddMenu];
    
}
- (IBAction)Bn_All_Tapped:(id)sender{
    viewAllFlashCards = 1;
    flashCardsViewController = [[FlashCardsViewController alloc] initWithNibName:@"FlashCardsViewController_iPad" bundle:nil];
    [self.navigationController pushViewController:flashCardsViewController animated:YES];

}
//=======================================================================================


#pragma Orientation
//------------------------------
- (BOOL) shouldAutorotate{
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    currentOrientaion = interfaceOrientation;
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations
{
    NSUInteger mask= UIInterfaceOrientationMaskPortrait;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    currentOrientaion = interfaceOrientation;
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
    currentOrientaion = interfaceOrientation;
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
    [imgBG setFrame:CGRectMake(0, 0, 768, 1004)];
    [imgBG setImage:[UIImage imageNamed:@"img_chapter_bg_p.png"]];
    [lbl_title setFrame:CGRectMake(90, 94, 231, 31)];
    [btnViewAll setFrame:CGRectMake(578, 94, 106, 34)];
    [myTableView setFrame:CGRectMake(54, 150, 645, 650)];
    //myTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, myTableView.bounds.size.width-648);
    [myTableView reloadData];
  
}
-(void)Fn_rotateLandscape
{
    [imgBG setFrame:CGRectMake(0, 0, 1024, 699)];
    [imgBG setImage:[UIImage imageNamed:@"img_chapter_bg.png"]];
    [btnViewAll setFrame:CGRectMake(778, 80, 106, 34)];
    [lbl_title setFrame:CGRectMake(140, 80, 231, 31)];
    [myTableView setFrame:CGRectMake(104,125,786,435)];    
    //myTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, myTableView.bounds.size.width-810);
    [myTableView reloadData];
}

//

@end
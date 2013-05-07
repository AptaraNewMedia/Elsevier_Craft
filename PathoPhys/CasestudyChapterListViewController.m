//
//  ChapterListViewController.m
//  CraftApp
//
//  Created by Rohit Yermalkar on 20/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "CasestudyChapterListViewController.h"
#import "CaseStudyViewController.h"
#import "Chapters.h"
#import "ThematicArea.h"
#import "CustomRightBarItem.h"
#import "CustomLeftBarItem.h"
#import "ChapterlistSubCell_iPad.h"
#import "CustomChapterHeaderView.h"

@interface CasestudyChapterListViewController ()
{
    IBOutlet UIImageView *imgBG;
    IBOutlet UIImageView *imgShadow;
    IBOutlet UIImageView *imgChapterBG;
    IBOutlet UITableView *myTableView;
    IBOutlet UILabel *lbl_title;
    IBOutlet UIButton *btnViewAll;

    NSMutableArray *arr_chapterList;
    NSMutableArray *arrHeaderSection;
    
    CustomChapterHeaderView *customView;
    
    UIImage *imgArrowRight;
    UIImage *imgArrowDown;
    NSInteger openSectionIndex;
    NSInteger previousSectionIndex;

    CaseStudyViewController *caseStudyViewController;
    
    CustomRightBarItem *customRightBar;
    CustomLeftBarItem *customLeftBar;
    NSInteger currentOrientaion;
}

@end

@implementation CasestudyChapterListViewController
@synthesize openSectionIndex;

// VIEW DEFAULT Methods
//=======================================================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"CaseStudies", @"CaseStudies");
        self.tabBarItem.image = [UIImage imageNamed:@"img_tab_casestudies"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        lbl_title.font = FONT_17;
    }
    else {
        lbl_title.font = FONT_25;
    }
    
    [self fnAddNavigationItems];
    
    imgArrowRight = [UIImage imageNamed:@"arrow_right.png"];
    imgArrowDown = [UIImage imageNamed:@"arrow_down.png"];
    
    openSectionIndex = -1;
    previousSectionIndex = -1;
    
    arrHeaderSection = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arr_chaptersCaseStudy count]; i++) {
        Chapters *objChp = (Chapters *)[arr_chaptersCaseStudy objectAtIndex:i];
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            customView = [[CustomChapterHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, 275, 32)];
            
            UIImage *img = [UIImage imageNamed:@"Tab_white_patch1.png"];
            customView.imgViewBg.frame = CGRectMake(0, 0, img.size.width, img.size.height);
            [customView.imgViewBg setImage:img];
            [customView.headerBtn setFrame:CGRectMake(15, 0, 231, 32)];
            [customView.headerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
            [customView.imgArrow setFrame:CGRectMake(243, 3, 27, 27)];
            [customView.headerBtn.titleLabel setFont:FONT_12];
            
            
        }
        else {
            customView = [[CustomChapterHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, 816, 55)];
        }
        [customView.headerBtn setTitle:[NSString stringWithFormat:@"%d. %@", i+1, objChp.strChapterTitle] forState:UIControlStateNormal];
        customView.headerBtn.tag=i;
        [customView.headerBtn addTarget:self action:@selector(sectionTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [arrHeaderSection addObject:customView];
    }
    
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_topbar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:COLOR_BLUE];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        customLeftBar = [[CustomLeftBarItem alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        customLeftBar.btnHome.frame = CGRectMake(0, 7, 35, 30) ;
        customLeftBar.btnBack.frame = CGRectMake(31, 7, 45, 30) ;
        [customLeftBar.btnHome setImage:[UIImage imageNamed:@"home_btn.png"] forState:UIControlStateNormal];
        [customLeftBar.btnBack setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    }
    else {
        customLeftBar = [[CustomLeftBarItem alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    }
    UIBarButtonItem *btnBar1 = [[UIBarButtonItem alloc] initWithCustomView:customLeftBar];
    self.navigationItem.leftBarButtonItem = btnBar1;
    [customLeftBar.btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    customLeftBar.btnBack.hidden = YES;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        customRightBar = [[CustomRightBarItem alloc] initWithFrame:CGRectMake(230, 0, 90, 44)];
        
        customRightBar.btnScore.frame = CGRectMake(0.0, 7.0, 30, 30);
        customRightBar.btnNote.frame = CGRectMake(31.0, 7.0, 30, 30);
        customRightBar.btnInfo.frame = CGRectMake(61.0, 7.0, 30, 30);
        
    }
    else {
        customRightBar = [[CustomRightBarItem alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
    }
    
    UIBarButtonItem *btnBar = [[UIBarButtonItem alloc] initWithCustomView:customRightBar];
    self.navigationItem.rightBarButtonItem = btnBar;
    NOTES_MODE = 0;   
}

-(IBAction)onHome:(id)sender{
    [md Fn_SubTabBar];
    [md Fn_AddMenu];
}

//=======================================================================================


// TableView Delegate Methods
//=======================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return [arr_chaptersCaseStudy count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == self.openSectionIndex) {
        Chapters *objChp = (Chapters *)[arr_chaptersCaseStudy objectAtIndex:self.openSectionIndex];
        if ([objChp thematicData] == 0)
            return 0;
        else
            return [objChp.thematicData count];
    }
    else
        return 0;

    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"tblCellView";
    ChapterlistSubCell_iPad *cell = (ChapterlistSubCell_iPad *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil) {
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"ChapterlistSubCell_iPhone" owner:self options:nil];
            cell = [cellArray lastObject];
            cell.lblThematicName.font = FONT_10;
        }
        else {        
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"ChapterlistSubCell_iPad" owner:self options:nil];
            cell = [cellArray lastObject];
            cell.lblThematicName.font = FONT_15;            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.lblThematicName.textColor = COLOR_BLACK;
    
    Chapters *objChap = (Chapters *) [arr_chaptersCaseStudy objectAtIndex:indexPath.section];
    if([objChap.thematicData count] > 0) {
        ThematicArea *objThematic = (ThematicArea *)[objChap.thematicData objectAtIndex:indexPath.row];
        cell.lblThematicName.text = objThematic.strThematicTitle;
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        }
        else {
            if (currentOrientaion==UIInterfaceOrientationLandscapeRight||currentOrientaion==UIInterfaceOrientationLandscapeLeft)
            {
                if(indexPath.row==0)
                {
                    
                    cell.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_white_patch1"];
                }
                else if(indexPath.row==[objChap.thematicData count]-1)
                {
                    cell.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_white_patch3"];
                }
                else
                {
                    cell.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_white_patch2"];
                }
            }
            else
            {
                if(indexPath.row==0)
                {
                    
                    cell.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_white_patch1_p"];
                }
                else if(indexPath.row==[objChap.thematicData count]-1)
                {
                    cell.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_white_patch3_p"];
                }
                else
                {
                    cell.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_white_patch2_p"];
                }
                
            }
        }
        
    }   
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        return 25.0;
    }else {
        return 37.0;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Chapters *objChap = (Chapters *)[arr_chaptersCaseStudy objectAtIndex:indexPath.section];
    intCurrentCaseStudy_ChapterId = objChap.intChapterId;
    intCurrentCaseStudy_ThematicId = -1;
    str_BarTitle = [NSString stringWithFormat:@"%@", objChap.strChapterTitle];
    strCurrentChapterName = [NSString stringWithFormat:@"%@", objChap.strChapterTitle];
    ThematicArea *objThematic;
    if(objChap.intIsThematicArea!=0) {
        objThematic = (ThematicArea *)[objChap.thematicData objectAtIndex:indexPath.row];
        intCurrentCaseStudy_ThematicId = objThematic.intThematicSequence;
        str_BarTitle = [NSString stringWithFormat:@"%@ - %@", objChap.strChapterTitle, objThematic.strThematicTitle];
        strCurrentThematicName = [NSString stringWithFormat:@"%@",  objThematic.strThematicTitle];
        
        
        ChapterlistSubCell_iPad *cell1 = (ChapterlistSubCell_iPad *)[tableView cellForRowAtIndexPath:indexPath];
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {

        }
        else {
        
            if (currentOrientaion==UIInterfaceOrientationLandscapeRight||currentOrientaion==UIInterfaceOrientationLandscapeLeft)
            {
                if(indexPath.row==0){
                    
                    cell1.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_Blue_patch1"];
                }
                else if(indexPath.row==[objChap.thematicData count]-1)
                {
                    cell1.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_Blue_patch3"];
                }
                else
                {
                    cell1.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_Blue_patch2"];
                }
            }
            else
            {
                if(indexPath.row==0){
                    
                    cell1.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_Blue_patch1_p"];
                }
                else if(indexPath.row==[objChap.thematicData count]-1)
                {
                    cell1.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_Blue_patch3_p"];
                }
                else
                {
                    cell1.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_Blue_patch2_p"];
                }
            }
            
        }
    }
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        caseStudyViewController = [[CaseStudyViewController alloc] initWithNibName:@"CaseStudyViewController_iPhone" bundle:nil];
        
    }
    else {
        caseStudyViewController = [[CaseStudyViewController alloc] initWithNibName:@"CaseStudyViewController_iPad" bundle:nil];
    }
   
    [self.navigationController pushViewController:caseStudyViewController animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%d", indexPath.row);
    
    Chapters *objChap = (Chapters *)[arr_chaptersCaseStudy objectAtIndex:indexPath.section];
    ThematicArea *objThematic;
    if(objChap.intIsThematicArea!=0) {
        objThematic = (ThematicArea *)[objChap.thematicData objectAtIndex:indexPath.row];
        
        ChapterlistSubCell_iPad *cell1 = (ChapterlistSubCell_iPad *)[tableView cellForRowAtIndexPath:indexPath];
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {

        }
        else {
        
            if (currentOrientaion==UIInterfaceOrientationLandscapeRight||currentOrientaion==UIInterfaceOrientationLandscapeLeft)
            {
                if(indexPath.row==0)
                {
                    
                    cell1.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_white_patch1"];
                }
                else if(indexPath.row==[objChap.thematicData count]-1)
                {
                    cell1.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_white_patch3"];
                }
                else
                {
                    cell1.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_white_patch2"];
                }
            }
            else
            {
                if(indexPath.row==0)
                {
                    
                    cell1.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_white_patch1_p"];
                }
                else if(indexPath.row==[objChap.thematicData count]-1)
                {
                    cell1.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_white_patch3_p"];
                }
                else
                {
                    cell1.imgTableCellBG.image=[UIImage imageNamed:@"SubTab_white_patch2_p"];
                }
                
            }
        }
    }
    
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    customView = [arrHeaderSection objectAtIndex:section];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
    }
    else {
    
        if (currentOrientaion==UIInterfaceOrientationLandscapeRight||currentOrientaion==UIInterfaceOrientationLandscapeLeft) {
            [customView.imgArrow setFrame:CGRectMake(720, 14, 27, 27)];
        }
        else {
            [customView.imgArrow setFrame:CGRectMake(570, 14, 27, 27)];
        }
    }
    return customView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        return 32;
    }
    else {
        return 55;
    }
    return 55;
    
}
- (void)sectionTouched:(UIButton*)sender{
    Chapters *objChap = (Chapters *)[arr_chaptersCaseStudy objectAtIndex:[sender tag]];
    if([objChap.thematicData count] == 0) {
        intCurrentTestYourSelf_ChapterId = objChap.intChapterId;
        intCurrentTestYourSelf_ThematicId = -1;
        str_BarTitle = [NSString stringWithFormat:@"%@", objChap.strChapterTitle];
        // [md Fn_AddTestYourSelf];
        strCurrentChapterName = [NSString stringWithFormat:@"%@", objChap.strChapterTitle];
        strCurrentThematicName = [NSString stringWithFormat:@""];
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            caseStudyViewController = [[CaseStudyViewController alloc] initWithNibName:@"CaseStudyViewController_iPhone" bundle:nil];
            
        }
        else {
            caseStudyViewController = [[CaseStudyViewController alloc] initWithNibName:@"CaseStudyViewController_iPad" bundle:nil];
        }
        
        [self.navigationController pushViewController:caseStudyViewController animated:YES];
        
    }
    else {
        
        openSectionIndex = [sender tag];
        customView = [arrHeaderSection objectAtIndex:[sender tag]];
        [customView.imgArrow setImage:imgArrowDown];
        
        if (previousSectionIndex != -1) {
            customView = [arrHeaderSection objectAtIndex:previousSectionIndex];
            [customView.imgArrow setImage:imgArrowRight];
        }
        
        previousSectionIndex = [sender tag];
        [myTableView reloadData];
    }

}
//=======================================================================================


// IBAction Methods
//=======================================================================================
- (IBAction)Bn_Back_Tapped:(id)sender{
   // [md Fn_SubChapterList];
    [md Fn_AddMenu];
    
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
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        return NO;
    }
    
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
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        return NO;
    }
    
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
    [myTableView setFrame:CGRectMake(104,125,816,435)];
    
    [myTableView reloadData];

}
//


//








@end

//
//  TestYourSelfViewController.m
//  CraftApp
//
//  Created by PUN-MAC-012 on 25/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "CaseStudyViewController.h"
#import "ChapterQuestionSet.h"

//
#import "MatchPairsViewController_cs.h"
#import "SingleSelectionViewController_cs.h"
#import "DragDropViewController_cs.h"
#import "CustomRightBarItem.h"
#import "CustomLeftBarItem.h"

//
#import "QuizTrack.h"
#import "Chapters.h"
#import "ThematicArea.h"
//#import "ResultViewController.h"

//
#import "Notes.h"

@interface CaseStudyViewController (){
    ChapterQuestionSet *objQue;
    
    UIView *viewMain;
    MatchPairsViewController_cs *matchPairsView;
    SingleSelectionViewController_cs *singleSelectionView;
    DragDropViewController_cs *dragDropView;
    
    QuizTrack *objQuizTrack;
    //ResultViewController *resultView;
    CustomRightBarItem *customRightBar;
    CustomLeftBarItem *customLeftBar;
    
    Notes *objNotes;
    NSInteger currentOrientaion;
    
    NSInteger TryAgainFlag;
    
    int int_MoveNextPre;
}
@end

@implementation CaseStudyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = str_BarTitle;
    [self fnAddNavigationItems];
    
    //
    arrCaseStudies = [db fnGetCaseStudyQuestions:intCurrentCaseStudy_ChapterId AndThematicId:intCurrentCaseStudy_ThematicId];
    
    //
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        viewMain = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 360)];
    }
    else {
        viewMain = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1005, 600)];
    }
    viewMain.backgroundColor = COLOR_CLEAR;
    [self.view addSubview:viewMain];
    
    //
    bnShowScore.hidden = YES;
    
    
    // Tracking data
    objQuizTrack = [[QuizTrack alloc] init];
    objQuizTrack.arrQuestionIds = [[NSMutableArray alloc] init];
    objQuizTrack.arrSelectedAnswer = [[NSMutableArray alloc] init];
    objQuizTrack.arrVisited = [[NSMutableArray alloc] init];
    
    objQuizTrack.intCategoryId = categoryNumber;
    objQuizTrack.intChapterId = intCurrentCaseStudy_ChapterId;
    objQuizTrack.intThematicId = intCurrentCaseStudy_ThematicId;
    objQuizTrack.strQuizTitle = str_BarTitle;
    
    intTotalQuestions = [arrCaseStudies count];
    for (int i =0; i<intTotalQuestions; i++) {
        objQue = (ChapterQuestionSet *)[arrCaseStudies objectAtIndex:i];
        [objQuizTrack.arrQuestionIds addObject:objQue.strQuestionId];
        [objQuizTrack.arrSelectedAnswer addObject:[NSNumber numberWithInt:0]];
        [objQuizTrack.arrVisited addObject:[NSNumber numberWithInt:0]];
    }
    intCurrentQuestionIndex = 0;
    TryAgainFlag = 0;
    int_MoveNextPre = 0;
    //
    if (intTotalQuestions > 0) {
        [self Fn_LoadQuestionData];
    }
    
    bnPrev.enabled = NO;
    if(intTotalQuestions == 1){
        bnNext.enabled = NO;
    }
}

-(void) fnAddNavigationItems
{
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) Fn_LoadQuestionData
{
    objQue = (ChapterQuestionSet *)[arrCaseStudies objectAtIndex:intCurrentQuestionIndex];
    lblQuestionNo.text = [NSString stringWithFormat:@"%d/%d", objQue.intSequence, intTotalQuestions];
    
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
        {
            if([UIScreen mainScreen].bounds.size.height == 568.0){
                dragDropView = [[DragDropViewController_cs alloc] initWithNibName:@"DragDropViewController_cs_iPhone5" bundle:nil];
            }
            else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                dragDropView = [[DragDropViewController_cs alloc] initWithNibName:@"DragDropViewController_cs_iPhone" bundle:nil];                
            }
            else {
                dragDropView = [[DragDropViewController_cs alloc] initWithNibName:@"DragDropViewController_cs_iPad" bundle:nil];
            }
            [dragDropView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:dragDropView.view];
            dragDropView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            dragDropView.parentObject = self;
            
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] != 0) {
                [dragDropView fn_ShowSelected:[objQuizTrack.arrSelectedAnswer objectAtIndex:intCurrentQuestionIndex]];
            }

        }
            break;
        case QUESTION_TYPE_MATCHTERMS: {
            
            
            if([UIScreen mainScreen].bounds.size.height == 568.0){
                matchPairsView = [[MatchPairsViewController_cs alloc] initWithNibName:@"MatchPairsViewController_cs_iPhone5" bundle:nil];
            }
            else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                matchPairsView = [[MatchPairsViewController_cs alloc] initWithNibName:@"MatchPairsViewController_cs_iPhone" bundle:nil];
            }
            else {
                matchPairsView = [[MatchPairsViewController_cs alloc] initWithNibName:@"MatchPairsViewController_cs_iPad" bundle:nil];
            }
            [matchPairsView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:matchPairsView.view];
            matchPairsView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            matchPairsView.parentObject = self;
            
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] != 0) {
                [matchPairsView fn_ShowSelected:[objQuizTrack.arrSelectedAnswer objectAtIndex:intCurrentQuestionIndex]];
            }
        }
            break;
        case QUESTION_TYPE_MCSS: {
            
            if([UIScreen mainScreen].bounds.size.height == 568.0){
                 singleSelectionView = [[SingleSelectionViewController_cs alloc] initWithNibName:@"SingleSelectionViewController_cs_iPhone5" bundle:nil];
            }
            else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                singleSelectionView = [[SingleSelectionViewController_cs alloc] initWithNibName:@"SingleSelectionViewController_cs_iPhone" bundle:nil];
            }
            else {
                singleSelectionView = [[SingleSelectionViewController_cs alloc] initWithNibName:@"SingleSelectionViewController_cs_iPad" bundle:nil];
            }
            [singleSelectionView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:singleSelectionView.view];
            singleSelectionView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            singleSelectionView.parentObject = self;
            
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] != 0) {
                [singleSelectionView fn_ShowSelected:[objQuizTrack.arrSelectedAnswer objectAtIndex:intCurrentQuestionIndex]];
            }
        }
            break;
    }
    
    [self Fn_CheckNote];
}

-(void) Fn_CheckNote {
    
    int question_no = intCurrentQuestionIndex + 1;
    
    objNotes = [db fnGetNote:categoryNumber AndChapterID:intCurrentCaseStudy_ChapterId AndThematicId:intCurrentCaseStudy_ThematicId AndQuestionNo:question_no];
    
    if (objNotes == Nil) {
        NOTES_MODE = 1;
        
        objNotes = [[Notes alloc] init];
        objNotes.intMode = 1;
        objNotes.strNoteTitle = [NSString stringWithFormat:@"CS-%d, %@, Q%d", intCurrentCaseStudy_ChapterId, strCurrentThematicName, question_no];
        //[customRightBar.Bn_Addnote setTitle:@"Add Note" forState:UIControlStateNormal];
    }
    else {
        NOTES_MODE = 2;

        
        objNotes.intMode = 2;
        //[customRightBar.Bn_Addnote setTitle:@"Edit Note" forState:UIControlStateNormal];
    }
    objNotes.intCategoryId = categoryNumber;
    objNotes.intChapterId = intCurrentCaseStudy_ChapterId;
    objNotes.intThematicId = intCurrentCaseStudy_ThematicId;
    objNotes.intQuestionNo = question_no;
    [md Fn_AddNote:objNotes];
}

-(void) fn_RemoveQuestionView
{
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
            [dragDropView.view removeFromSuperview];
            break;
        case QUESTION_TYPE_MATCHTERMS:
            [matchPairsView.view removeFromSuperview];
            break;
        case QUESTION_TYPE_MCSS:
            [singleSelectionView.view removeFromSuperview];
            break;
    }
}


-(IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)onNext:(id)sender
{
    if (intCurrentQuestionIndex == intTotalQuestions-1) {
        return;
    }
    bnSubmit.enabled = YES;
    TryAgainFlag = 0;
    [self fn_RemoveQuestionView];
    intCurrentQuestionIndex++;
    [self Fn_LoadQuestionData];
    bnPrev.enabled = YES;
    if (intCurrentQuestionIndex == intTotalQuestions-1) {
        bnNext.enabled = NO;
    }
}

-(IBAction)onPrev:(id)sender
{
    if (intCurrentQuestionIndex == 0) {
        return;
    }
    bnSubmit.enabled = YES;
    TryAgainFlag = 0;
    [self fn_RemoveQuestionView];
    intCurrentQuestionIndex--;
    [self Fn_LoadQuestionData];
    bnNext.enabled = YES;
    if (intCurrentQuestionIndex == 0) {
        bnPrev.enabled = NO;
    }
    
}

-(IBAction)onSubmit:(id)sender
{
    NSString *strSel = nil;    
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
            {
                strSel = [dragDropView fn_CheckAnswersBeforeSubmit];
                if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0) {
                    if (strSel.length > 0)
                        [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                    [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:dragDropView.intVisited]];
                }
                [dragDropView fn_OnSubmitTapped];
            }
            break;
        case QUESTION_TYPE_MATCHTERMS:
            {
                strSel = [matchPairsView fn_CheckAnswersBeforeSubmit];
                if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0) {
                    if (strSel.length > 0)
                        [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                    [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:matchPairsView.intVisited]];
                }
                [matchPairsView fn_OnSubmitTapped];
            }
            break;
        case QUESTION_TYPE_MCSS:
            {
                strSel = [singleSelectionView fn_CheckAnswersBeforeSubmit];
                if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0) {
                    if (strSel.length > 0)
                        [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                    [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:singleSelectionView.intVisited]];
                }
                [singleSelectionView fn_OnSubmitTapped];
            }
            break;
    }
    
    if (intCurrentQuestionIndex == intTotalQuestions-1) {
        bnShowScore.hidden = NO;
    }
    
}

-(IBAction)onShowScore:(id)sender
{
    
    int total_score = 0;
    for (int i =0; i<[objQuizTrack.arrVisited count]; i++) {
        int ans = [[objQuizTrack.arrVisited objectAtIndex:i] intValue];
        if (ans == 1) {
            total_score++;
        }
    }
    
    NSString *score = [NSString stringWithFormat:@"%d out of %d questions answered correctly.", total_score, intTotalQuestions];
   
    [md Fn_AddResult:strCurrentChapterName AndThematicNAme:strCurrentThematicName AndScore:score];
    
    objQuizTrack.intCorrectQuestion = total_score;
    objQuizTrack.intMissedQuestion = (intTotalQuestions - total_score);
    float percentage = (total_score*100) / intTotalQuestions;
    objQuizTrack.floatPercentage =  percentage;
    objQuizTrack.intLastVisitedQuestion = 0;
    objQuizTrack.strCreatedDate = md.strCurrentDate;
    
    [db fnSetQuizTrack:objQuizTrack];
}

-(void)onTryAgain
{
    TryAgainFlag = 1;
    int_MoveNextPre = 0;
    [self fn_RemoveQuestionView];
    [md Fn_SubAddNote];
    [self Fn_LoadQuestionData];
}

-(void) Fn_DisableSubmit {
    bnSubmit.enabled = NO;
}
-(void)Fn_CallOrientaion
{
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
            //[multipleSelectionView.view removeFromSuperview];
            [dragDropView shouldAutorotateToInterfaceOrientation:currentOrientaion];
            break;
        case QUESTION_TYPE_MATCHTERMS:
            [matchPairsView shouldAutorotateToInterfaceOrientation:currentOrientaion];
            break;
        case QUESTION_TYPE_MCSS:
            [singleSelectionView shouldAutorotateToInterfaceOrientation:currentOrientaion];
            break;
    }
    
    //[resultView shouldAutorotateToInterfaceOrientation:currentOrientaion];

    
}


-(void)Fn_CallOrientaion_ios6
{
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
            //[multipleSelectionView.view removeFromSuperview];
            [dragDropView supportedInterfaceOrientations];
            break;
        case QUESTION_TYPE_MATCHTERMS:
            [matchPairsView supportedInterfaceOrientations];
            break;
        case QUESTION_TYPE_MCSS:
            [singleSelectionView supportedInterfaceOrientations];
            break;
        case QUESTION_TYPE_DRAGDROP:
            [dragDropView supportedInterfaceOrientations];
            break;
    }
    
    //[resultView shouldAutorotateToInterfaceOrientation:currentOrientaion];

    
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
    [self Fn_CallOrientaion_ios6];
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
    [self Fn_CallOrientaion];
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
    
    [imgBG setImage:[UIImage imageNamed:@"img_bg_p.png"]];
    [imgBG setFrame:CGRectMake(0, 0, 768, 1005)];
    
    [imgShadow setImage:[UIImage imageNamed:@"text-box_shadow.png"]];
    [imgShadow setFrame:CGRectMake(0, 630, 767, 292)];
    
    [viewMain setFrame:CGRectMake(0, 50, 767, 803)];
    
    [bnNext setFrame:CGRectMake(184, 850, 63, 57)];
    [bnPrev setFrame:CGRectMake(30, 850, 63, 57)];
    [bnSubmit setFrame:CGRectMake(620, 860, 139, 43)];
    [bnShowScore setFrame:CGRectMake(430, 860, 139, 43)];
    
    [lblQuestionNo setFrame:CGRectMake(116, 870, 68, 26)];
}
-(void)Fn_rotateLandscape
{
    [imgBG setImage:[UIImage imageNamed:@"img_bg.png"]];
    [imgBG setFrame:CGRectMake(0, 0, 1024, 699)];
    [imgShadow setImage:[UIImage imageNamed:@"img_bg_shadow.png"]];
    [imgShadow setFrame:CGRectMake(0, 256, 1024, 437)];
    
    [viewMain setFrame:CGRectMake(10, 10, 1005, 600)];
    
    [bnNext setFrame:CGRectMake(184, 608, 63, 57)];
    [bnPrev setFrame:CGRectMake(30, 608, 63, 57)];
    [bnSubmit setFrame:CGRectMake(873, 613, 139, 43)];
    [bnShowScore setFrame:CGRectMake(674, 613, 139, 43)];
    [lblQuestionNo setFrame:CGRectMake(116, 620, 68, 26)];
}

@end

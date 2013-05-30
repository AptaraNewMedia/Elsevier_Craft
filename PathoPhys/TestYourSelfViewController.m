//
//  TestYourSelfViewController.m
//  CraftApp
//
//  Created by PUN-MAC-012 on 25/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "TestYourSelfViewController.h"
#import "ChapterQuestionSet.h"

#import <QuartzCore/QuartzCore.h>

//
#import "MatchPairsViewController.h"
#import "SingleSelectionViewController.h"
#import "MultipleSelectionViewController.h"
#import "FillInTheBlanksViewController.h"
#import "TrueFalseViewController.h"
#import "RadioGroupViewController.h"
#import "DragDropViewController.h"
#import "DragDropRadioViewController.h"
#import "CustomRightBarItem.h"
#import "CustomLeftBarItem.h"
#import "SingleSelectionImageViewController.h"

//
#import "QuizTrack.h"
#import "Chapters.h"
#import "ThematicArea.h"

//
#import "Notes.h"


@interface TestYourSelfViewController (){
    ChapterQuestionSet *objQue;
    
    UIView *viewMain;
    MatchPairsViewController *matchPairsView;
    SingleSelectionViewController *singleSelectionView;
    MultipleSelectionViewController *multipleSelectionView;
    FillInTheBlanksViewController *fillInTheBlanksView;
    TrueFalseViewController *trueFalseView;
    DragDropViewController *dragDropView;
    RadioGroupViewController *radioGroupView;
    DragDropRadioViewController *dragDropRadioView;
    SingleSelectionImageViewController *singleSelectionImageView;
    
    
    QuizTrack *objQuizTrack;
    CustomRightBarItem *customRightBar;
    CustomLeftBarItem *customLeftBar;
    
    Notes *objNotes;
    NSInteger currentOrientaion;
    
    NSInteger TryAgainFlag;
    int int_MoveNextPre;    
    BOOL backFromNotes;
}

-(IBAction)onNext:(id)sender;
-(IBAction)onPrev:(id)sender;
-(IBAction)onSubmit:(id)sender;

@end

@implementation TestYourSelfViewController

#pragma mark - Defaults
//-----------------------------------------
-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = str_BarTitle;
    [self fnAddNavigationItems];
    
    //Global Variables    
    isTestInProgress = 1;
    
    //
    arrTestYourSelf = [db fnGetTestyourSelfQuestions:intCurrentTestYourSelf_ChapterId AndThematicId:intCurrentTestYourSelf_ThematicId];
    
    //
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        viewMain = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 360)];
    }
    else {
        viewMain = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1005, 600)];
    }
    viewMain.backgroundColor = COLOR_CLEAR;
    [self.view addSubview:viewMain];
    //viewMain.hidden = YES;
    
    //
    bnShowScore.hidden = YES;
    
    
    objQuizTrack = [db fnGetQuizTRack:categoryNumber AndChapterID:intCurrentTestYourSelf_ChapterId AndThematicId:intCurrentTestYourSelf_ThematicId];
    if (objQuizTrack == nil) {
        // Tracking data
        objQuizTrack = [[QuizTrack alloc] init];
        objQuizTrack.arrQuestionIds = [[NSMutableArray alloc] init];
        objQuizTrack.arrSelectedAnswer = [[NSMutableArray alloc] init];
        objQuizTrack.arrVisited = [[NSMutableArray alloc] init];
        
        objQuizTrack.intCategoryId = categoryNumber;
        objQuizTrack.intChapterId = intCurrentTestYourSelf_ChapterId;
        objQuizTrack.intThematicId = intCurrentTestYourSelf_ThematicId;
        objQuizTrack.strQuizTitle = str_BarTitle;
        
        intTotalQuestions = [arrTestYourSelf count];
        for (int i =0; i<intTotalQuestions; i++) {
            objQue = (ChapterQuestionSet *)[arrTestYourSelf objectAtIndex:i];
            [objQuizTrack.arrQuestionIds addObject:objQue.strQuestionId];
            [objQuizTrack.arrSelectedAnswer addObject:[NSNumber numberWithInt:0]];
            [objQuizTrack.arrVisited addObject:[NSNumber numberWithInt:0]];
        }
        intCurrentQuestionIndex = 0;
        TryAgainFlag = 0;
        int_MoveNextPre = 0;
    }
    else {
        intCurrentQuestionIndex = objQuizTrack.intLastVisitedQuestion;
        intTotalQuestions = [arrTestYourSelf count];
        TryAgainFlag = 0;
        int_MoveNextPre = 0;
    }
    //
    [self Fn_LoadQuestionData];
    if (intCurrentQuestionIndex == 0) {
        bnPrev.enabled = NO;
    }
    if(intTotalQuestions == 1){
        bnNext.enabled = NO;
    }
    
    [self fnDisableBottomBarButtons];
    bnSubmit.hidden = NO;
    bnSubmit.enabled = YES;
    
    backFromNotes = NO;
    
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [md Fn_removeInfoViewPopup];
    [md Fn_removeNoteViewPopup];
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-----------------------------------------


#pragma mark - Common Functions
//-----------------------------------------
-(void)fnAddNavigationItems
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
//-----------------------------------------


#pragma mark - Normal Functions
//-----------------------------------------
-(void)Fn_LoadQuestionData
{
    objQue = (ChapterQuestionSet *)[arrTestYourSelf objectAtIndex:intCurrentQuestionIndex];
    lblQuestionNo.text = [NSString stringWithFormat:@"%d/%d", objQue.intSequence, intTotalQuestions];
    
    UIView *animateView;
    
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
        {
            NSLog(@"Drag Drop");
            if([UIScreen mainScreen].bounds.size.height == 568.0){
                dragDropView = [[DragDropViewController alloc] initWithNibName:@"DragDropViewController_iPhone5" bundle:nil];
            }
            else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                dragDropView = [[DragDropViewController alloc] initWithNibName:@"DragDropViewController_iPhone" bundle:nil];
            }
            else {
                dragDropView = [[DragDropViewController alloc] initWithNibName:@"DragDropViewController_iPad" bundle:nil];
            }
            [dragDropView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:dragDropView.view];
            dragDropView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            dragDropView.parentObject = self;
            animateView = dragDropView.view;
            
            if (TryAgainFlag != 1) {
                if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] != 0) {
                    [dragDropView fn_ShowSelected:[objQuizTrack.arrSelectedAnswer objectAtIndex:intCurrentQuestionIndex]];
                }
            }
            
        }
            break;
        case QUESTION_TYPE_FILLINBLANKS:
        {
            NSLog(@"FIB");
            if([UIScreen mainScreen].bounds.size.height == 568.0){
                fillInTheBlanksView = [[FillInTheBlanksViewController alloc] initWithNibName:@"FillInTheBlanksViewController_iPhone5" bundle:nil];
            }
            else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                fillInTheBlanksView = [[FillInTheBlanksViewController alloc] initWithNibName:@"FillInTheBlanksViewController_iPhone" bundle:nil];
            }
            else {
                fillInTheBlanksView = [[FillInTheBlanksViewController alloc] initWithNibName:@"FillInTheBlanksViewController_iPad" bundle:nil];
            }
            [fillInTheBlanksView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:fillInTheBlanksView.view];
            fillInTheBlanksView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            fillInTheBlanksView.parentObject = self;
            animateView = fillInTheBlanksView.view;
            
            if (TryAgainFlag != 1) {
                if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] != 0) {
                    [fillInTheBlanksView fn_ShowSelected:[objQuizTrack.arrSelectedAnswer objectAtIndex:intCurrentQuestionIndex]];
                }
            }
            
        }
            break;
        case QUESTION_TYPE_RADIOBUTTONS:
        {
            NSLog(@"Radio Group");
            if([UIScreen mainScreen].bounds.size.height == 568.0){
                radioGroupView = [[RadioGroupViewController alloc] initWithNibName:@"RadioGroupViewController_iPhone5" bundle:nil];
            }
            else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                radioGroupView = [[RadioGroupViewController alloc] initWithNibName:@"RadioGroupViewController_iPhone" bundle:nil];
            }
            else {
                radioGroupView = [[RadioGroupViewController alloc] initWithNibName:@"RadioGroupViewController_iPad" bundle:nil];
            }
            
            [radioGroupView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:radioGroupView.view];
            radioGroupView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            radioGroupView.parentObject = self;
            animateView = radioGroupView.view;
            
            if (TryAgainFlag != 1) {
                if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] != 0) {
                    [radioGroupView fn_ShowSelected:[objQuizTrack.arrSelectedAnswer objectAtIndex:intCurrentQuestionIndex]];
                }
            }
        }
            break;
        case QUESTION_TYPE_TRUEFLASE:
        {
            NSLog(@"True/False");
            if([UIScreen mainScreen].bounds.size.height == 568.0){
                trueFalseView = [[TrueFalseViewController alloc] initWithNibName:@"TrueFalseViewController_iPhone5" bundle:nil];
            }
            else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                trueFalseView = [[TrueFalseViewController alloc] initWithNibName:@"TrueFalseViewController_iPhone" bundle:nil];
            }
            else {
                trueFalseView = [[TrueFalseViewController alloc] initWithNibName:@"TrueFalseViewController_iPad" bundle:nil];
            }
            [trueFalseView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:trueFalseView.view];
            trueFalseView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            trueFalseView.parentObject = self;
            animateView = trueFalseView.view;
            if (TryAgainFlag != 1) {
                if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] != 0) {
                    [trueFalseView fn_ShowSelected:[objQuizTrack.arrSelectedAnswer objectAtIndex:intCurrentQuestionIndex]];
                }
            }
        }
            break;
        case QUESTION_TYPE_MATCHTERMS:
        {
            
            if([UIScreen mainScreen].bounds.size.height == 568.0){
                NSLog(@"Match Pairs iPhone5");
                matchPairsView = [[MatchPairsViewController alloc] initWithNibName:@"MatchPairsViewController_iPhone5" bundle:nil];
            }
            else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                matchPairsView = [[MatchPairsViewController alloc] initWithNibName:@"MatchPairsViewController_iPhone" bundle:nil];
            }
            else {
                matchPairsView = [[MatchPairsViewController alloc] initWithNibName:@"MatchPairsViewController_iPad" bundle:nil];
            }
            
            [matchPairsView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:matchPairsView.view];
            matchPairsView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            matchPairsView.parentObject = self;
            animateView = matchPairsView.view;
            if (TryAgainFlag != 1) {
                if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] != 0) {
                    [matchPairsView fn_ShowSelected:[objQuizTrack.arrSelectedAnswer objectAtIndex:intCurrentQuestionIndex]];
                }
            }
        }
            break;
        case QUESTION_TYPE_MCSS:
        {
            NSLog(@"Single Selection");
            if([UIScreen mainScreen].bounds.size.height == 568.0){
                singleSelectionView = [[SingleSelectionViewController alloc] initWithNibName:@"SingleSelectionViewController_iphone5" bundle:nil];
            }
            else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                singleSelectionView = [[SingleSelectionViewController alloc] initWithNibName:@"SingleSelectionViewController_iphone" bundle:nil];
            }
            else {
                singleSelectionView = [[SingleSelectionViewController alloc] initWithNibName:@"SingleSelectionViewController_iPad" bundle:nil];
            }
            [singleSelectionView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:singleSelectionView.view];
            singleSelectionView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            singleSelectionView.parentObject = self;
            animateView = singleSelectionView.view;
            
            if (TryAgainFlag != 1) {
                if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] != 0) {
                    [singleSelectionView fn_ShowSelected:[objQuizTrack.arrSelectedAnswer objectAtIndex:intCurrentQuestionIndex]];
                }
            }
        }
            break;
        case QUESTION_TYPE_DRAGDROP:
        {
            NSLog(@"Drag Drop");
            if([UIScreen mainScreen].bounds.size.height == 568.0){
                dragDropView = [[DragDropViewController alloc] initWithNibName:@"DragDropViewController_iPhone5" bundle:nil];
            }
            else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                dragDropView = [[DragDropViewController alloc] initWithNibName:@"DragDropViewController_iphone" bundle:nil];
            }
            else {
                dragDropView = [[DragDropViewController alloc] initWithNibName:@"DragDropViewController_iPad" bundle:nil];
            }
            [dragDropView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:dragDropView.view];
            dragDropView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            dragDropView.parentObject = self;
            animateView = dragDropView.view;
            
            if (TryAgainFlag != 1) {
                if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] != 0) {
                    [dragDropView fn_ShowSelected:[objQuizTrack.arrSelectedAnswer objectAtIndex:intCurrentQuestionIndex]];
                }
            }
        }
            break;
        case QUESTION_TYPE_DRAGDROPRADIOBUTTONS:
        {
            NSLog(@"Drag Drop Radio");
            if([UIScreen mainScreen].bounds.size.height == 568.0){
                dragDropRadioView = [[DragDropRadioViewController alloc] initWithNibName:@"DragDropRadioViewController_iPhone5" bundle:nil];
            }
            else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                dragDropRadioView = [[DragDropRadioViewController alloc] initWithNibName:@"DragDropRadioViewController_iPhone" bundle:nil];
            }
            else {
                dragDropRadioView = [[DragDropRadioViewController alloc] initWithNibName:@"DragDropRadioViewController_iPad" bundle:nil];
            }
            
            [dragDropRadioView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:dragDropRadioView.view];
            dragDropRadioView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            dragDropRadioView.parentObject = self;
            animateView = dragDropRadioView.view;
            
            if (TryAgainFlag != 1) {
                if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] != 0) {
                    [dragDropRadioView fn_ShowSelected:[objQuizTrack.arrSelectedAnswer objectAtIndex:intCurrentQuestionIndex]];
                }
            }
            
        }
            break;
    }
    
    if (int_MoveNextPre == 1) {
        // Animate Right to left
    }
    else if(int_MoveNextPre == 2) {
        // Animate left to right
    }    
    [self Fn_CheckNote];
}
-(void)Fn_CheckNote
{
    
    int question_no = intCurrentQuestionIndex + 1;
    
    objNotes = [db fnGetNote:categoryNumber AndChapterID:intCurrentTestYourSelf_ChapterId AndThematicId:intCurrentTestYourSelf_ThematicId AndQuestionNo:question_no AndQuizTrackId:objQuizTrack.intQuizTrackId];
    
    if (objNotes == Nil) {
        
        NOTES_MODE = 1;
        
        objNotes = [[Notes alloc] init];
        objNotes.intMode = 1;
        objNotes.strNoteTitle = [NSString stringWithFormat:@"TY-%d, %@, Q%d", intCurrentTestYourSelf_ChapterId, strCurrentThematicName, question_no];
    }
    else {
        NOTES_MODE = 2;
        objNotes.intMode = 2;
    }
    // add history
    
    objNotes.intCategoryId = categoryNumber;
    objNotes.intChapterId = intCurrentTestYourSelf_ChapterId;
    objNotes.intThematicId = intCurrentTestYourSelf_ThematicId;
    objNotes.intQuestionNo = question_no;
    objNotes.intQuizTrackId   = objQuizTrack.intQuizTrackId;
    objQue = (ChapterQuestionSet *)[arrTestYourSelf objectAtIndex:intCurrentQuestionIndex];
    objNotes.strQuestionId = objQue.strQuestionId;
    
    [md Fn_AddNote:objNotes];
}
-(void)fn_RemoveQuestionView
{
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
            //[multipleSelectionView.view removeFromSuperview];
            [dragDropView.view removeFromSuperview];
            break;
        case QUESTION_TYPE_FILLINBLANKS:
            [fillInTheBlanksView.view removeFromSuperview];
            break;
        case QUESTION_TYPE_RADIOBUTTONS:
            [radioGroupView.view removeFromSuperview];
            break;
        case QUESTION_TYPE_TRUEFLASE:
            [trueFalseView.view removeFromSuperview];
            break;
        case QUESTION_TYPE_MATCHTERMS:
            [matchPairsView.view removeFromSuperview];
            break;
        case QUESTION_TYPE_MCSS:
            [singleSelectionView.view removeFromSuperview];
            break;
        case QUESTION_TYPE_DRAGDROP:
            [dragDropView.view removeFromSuperview];
            break;
        case QUESTION_TYPE_DRAGDROPRADIOBUTTONS:
            [dragDropRadioView.view removeFromSuperview];
            break;
    }
}
-(void)fnDisableBottomBarButtons
{
    bnShowAnswer.hidden = YES;
    bnTryAgian.hidden = YES;
    bnShowScore.hidden = YES;
    bnSubmit.hidden = YES;
}
-(void)disableAllButtons:(int)questionNO
{
    
    bnNext.enabled = NO;
    bnPrev.enabled = NO;
    bnSubmit.enabled = NO;
    
    backFromNotes = YES;
    
    [self fn_RemoveQuestionView];
    intCurrentQuestionIndex = questionNO - 1;
    [self Fn_LoadQuestionData];
    
    [self Fn_CheckNote];
        
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
            break;
        case QUESTION_TYPE_MATCHTERMS:
            break;
        case QUESTION_TYPE_MCSS:
            singleSelectionView.tblOptions.allowsSelection = NO;
            break;
    }
    
    customRightBar.btnInfo.hidden = YES;
    customRightBar.btnNote.hidden = YES;
    customRightBar.btnScore.hidden = YES;
    
    customLeftBar.btnHome.hidden = YES;
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        customLeftBar.btnBack.frame = CGRectMake(0, 7, 45, 30) ;
    }
    else {
        
    }
    
    [self performSelector:@selector(onSelctor) withObject:self afterDelay:0.7];
    
}
-(void)onSelctor
{
    [md Fn_ShowNote:2];
}
-(void)Fn_CallOrientaion
{
    //
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
            //[multipleSelectionView.view removeFromSuperview];
            [dragDropView shouldAutorotateToInterfaceOrientation:currentOrientaion];
            break;
        case QUESTION_TYPE_FILLINBLANKS:
            [fillInTheBlanksView shouldAutorotateToInterfaceOrientation:currentOrientaion];
            break;
        case QUESTION_TYPE_RADIOBUTTONS:
            [radioGroupView shouldAutorotateToInterfaceOrientation:currentOrientaion];
            break;
        case QUESTION_TYPE_TRUEFLASE:
            [trueFalseView shouldAutorotateToInterfaceOrientation:currentOrientaion];
            break;
        case QUESTION_TYPE_MATCHTERMS:
            [matchPairsView shouldAutorotateToInterfaceOrientation:currentOrientaion];
            break;
        case QUESTION_TYPE_MCSS:
            [singleSelectionView shouldAutorotateToInterfaceOrientation:currentOrientaion];
            break;
        case QUESTION_TYPE_DRAGDROP:
            [dragDropView shouldAutorotateToInterfaceOrientation:currentOrientaion];
            break;
        case QUESTION_TYPE_DRAGDROPRADIOBUTTONS:
            [dragDropRadioView shouldAutorotateToInterfaceOrientation:currentOrientaion];
            break;
    }
    //
}
//-----------------------------------------


#pragma mark - Public Functions
//-----------------------------------------
-(void)onTryAgain
{
    TryAgainFlag = 1;
    int_MoveNextPre = 0;
    [self Fn_DisableSubmit];
    bnSubmit.hidden = NO;
    bnSubmit.enabled = YES;
    [self fn_RemoveQuestionView];
    [md Fn_SubAddNote];
    [self Fn_LoadQuestionData];
}
-(void)Fn_DisableSubmit
{
    bnSubmit.hidden = YES;
    bnSubmit.enabled = NO;
    bnShowAnswer.hidden = YES;
    bnTryAgian.hidden = YES;
}
-(void)Fn_ShowAnswer
{
    bnShowAnswer.hidden = NO;
    bnTryAgian.hidden = NO;
}
-(void)Fn_SaveBookmarkingData
{
    // Save
    
    NSString *strSel = nil;
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
        {
            strSel = [dragDropView fn_CheckAnswersBeforeSubmit];
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:dragDropView.intVisited]];
            }
        }
            break;
        case QUESTION_TYPE_FILLINBLANKS:
        {
            strSel = [fillInTheBlanksView fn_CheckAnswersBeforeSubmit];
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:fillInTheBlanksView.intVisited]];
            }
        }
            break;
        case QUESTION_TYPE_RADIOBUTTONS:
        {
            strSel = [radioGroupView fn_CheckAnswersBeforeSubmit];
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:radioGroupView.intVisited]];
            }
        }
            break;
        case QUESTION_TYPE_TRUEFLASE:
        {
            strSel = [trueFalseView fn_CheckAnswersBeforeSubmit];
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:trueFalseView.intVisited]];
            }
        }
            break;
        case QUESTION_TYPE_MATCHTERMS:
        {
            strSel = [matchPairsView fn_CheckAnswersBeforeSubmit];
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:matchPairsView.intVisited]];
            }
        }
            break;
        case QUESTION_TYPE_MCSS:
        {
            strSel = [singleSelectionView fn_CheckAnswersBeforeSubmit];
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:singleSelectionView.intVisited]];
            }
        }
            break;
        case QUESTION_TYPE_DRAGDROPRADIOBUTTONS:
        {
            strSel = [dragDropRadioView fn_CheckAnswersBeforeSubmit];
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:dragDropRadioView.intVisited]];
            }
        }
            break;
    }

    
    
    
    // Calculation
    
    int total_score = 0;
    for (int i =0; i<[objQuizTrack.arrVisited count]; i++) {
        int ans = [[objQuizTrack.arrVisited objectAtIndex:i] intValue];
        if (ans == 1) {
            total_score++;
        }
    }
    
    int_currentScore =(total_score / intTotalQuestions) * 100;
    
    objQuizTrack.intCorrectQuestion = total_score;
    objQuizTrack.intMissedQuestion = (intTotalQuestions - total_score);
    float percentage = (total_score*100) / intTotalQuestions;
    objQuizTrack.floatPercentage =  percentage;
    objQuizTrack.intLastVisitedQuestion = intCurrentQuestionIndex;
    objQuizTrack.strCreatedDate = md.strCurrentDate;
    objQuizTrack.intComplete = 0;
    [db fnSetQuizTrack:objQuizTrack];
}
//-----------------------------------------


#pragma mark - Button Actions
//-----------------------------------------
-(IBAction)onBack:(id)sender
{
    if (backFromNotes) {
        [self.navigationController popViewControllerAnimated:YES];        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Pathophysquiz"];
        [alert setDelegate:self];
        [alert setTag:BOOKMARKING_ALERT_TAG];
        [alert addButtonWithTitle:@"YES"];
        [alert addButtonWithTitle:@"NO"];
        [alert setMessage:[NSString stringWithFormat:MSG_BOOKMARK_TEST]];
        [alert show];
    }
}
-(IBAction)onNext:(id)sender
{
    if (intCurrentQuestionIndex == intTotalQuestions-1) {
        return;
    }
    [self fnDisableBottomBarButtons];
    bnSubmit.hidden = NO;
    bnSubmit.enabled = YES;
    TryAgainFlag = 0;
    int_MoveNextPre = 2;
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
    [self fnDisableBottomBarButtons];
    bnSubmit.hidden = NO;    
    bnSubmit.enabled = YES;
    TryAgainFlag = 0;
    int_MoveNextPre = 1;
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
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:dragDropView.intVisited]];
            }
            [dragDropView fn_OnSubmitTapped];
        }
            break;
        case QUESTION_TYPE_FILLINBLANKS:
        {
            strSel = [fillInTheBlanksView fn_CheckAnswersBeforeSubmit];
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:fillInTheBlanksView.intVisited]];
            }
            [fillInTheBlanksView fn_OnSubmitTapped];
        }
            break;
        case QUESTION_TYPE_RADIOBUTTONS:
        {
            strSel = [radioGroupView fn_CheckAnswersBeforeSubmit];
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:radioGroupView.intVisited]];
            }
            [radioGroupView fn_OnSubmitTapped];
        }
            break;
        case QUESTION_TYPE_TRUEFLASE:
        {
            strSel = [trueFalseView fn_CheckAnswersBeforeSubmit];
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:trueFalseView.intVisited]];
            }
            [trueFalseView fn_OnSubmitTapped];
        }
            break;
        case QUESTION_TYPE_MATCHTERMS:
        {
            strSel = [matchPairsView fn_CheckAnswersBeforeSubmit];
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
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
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:singleSelectionView.intVisited]];
            }
            [singleSelectionView fn_OnSubmitTapped];
        }
            break;
        case QUESTION_TYPE_DRAGDROP:
            
            break;
            
        case QUESTION_TYPE_DRAGDROPRADIOBUTTONS:
        {
            strSel = [dragDropRadioView fn_CheckAnswersBeforeSubmit];
            if ([[objQuizTrack.arrVisited objectAtIndex:intCurrentQuestionIndex] intValue] == 0 && TryAgainFlag == 0) {
                if (strSel.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:strSel];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:dragDropRadioView.intVisited]];
            }
            [dragDropRadioView fn_OnSubmitTapped];
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
    
    int_currentScore =(total_score / intTotalQuestions) * 100;     
    
    objQuizTrack.intCorrectQuestion = total_score;
    objQuizTrack.intMissedQuestion = (intTotalQuestions - total_score);
    float percentage = (total_score*100) / intTotalQuestions;
    objQuizTrack.floatPercentage =  percentage;
    objQuizTrack.intLastVisitedQuestion = 0;
    objQuizTrack.strCreatedDate = md.strCurrentDate;
    objQuizTrack.intComplete = 1;
    [db fnDeleteQuizTrack:objQuizTrack.intQuizTrackId];
    [db fnSetQuizTrack:objQuizTrack];
    
}
-(IBAction)onShowAnswer:(id)sender
{
    //
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
            [dragDropView handleShowAnswers];
            break;
        case QUESTION_TYPE_FILLINBLANKS:
            [fillInTheBlanksView handleShowAnswers];
            break;
        case QUESTION_TYPE_RADIOBUTTONS:
            [radioGroupView handleShowAnswers];
            break;
        case QUESTION_TYPE_TRUEFLASE:
            [trueFalseView handleShowAnswers];
            break;
        case QUESTION_TYPE_MATCHTERMS:
            [matchPairsView handleShowAnswers];
            break;
        case QUESTION_TYPE_MCSS:
            [singleSelectionView handleShowAnswers];
            break;
        case QUESTION_TYPE_DRAGDROP:
            [dragDropView handleShowAnswers];
            break;
        case QUESTION_TYPE_DRAGDROPRADIOBUTTONS:
            [dragDropRadioView handleShowAnswers];
            break;
    }
    //

}
-(IBAction)onTryAgainTapped:(id)sender
{
    [self onTryAgain];
}
//-----------------------------------------

#pragma mark - AlertView
//---------------------------------------------------------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == BOOKMARKING_ALERT_TAG) {
        if (buttonIndex == 0)
        {
            [self Fn_SaveBookmarkingData];
        }
        else if(buttonIndex == 1) {
            [db fnDeleteQuizTrack:objQuizTrack.intQuizTrackId];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//---------------------------------------------------------


#pragma mark - Rotations
//-----------------------------------------
-(BOOL)shouldAutorotate
{
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
    [self Fn_CallOrientaion];
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
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    
    [bnTryAgian setFrame:CGRectMake(620, 860, 139, 43)];
    [bnShowAnswer setFrame:CGRectMake(430, 860, 139, 43)];
    
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
    
    [bnTryAgian setFrame:CGRectMake(873, 613, 139, 43)];
    [bnShowAnswer setFrame:CGRectMake(674, 613, 139, 43)];
}
//------------------------------

@end

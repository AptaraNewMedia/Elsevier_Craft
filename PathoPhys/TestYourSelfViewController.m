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
//#import "ResultViewController.h"

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
    //ResultViewController *resultView;
    CustomRightBarItem *customRightBar;
    CustomLeftBarItem *customLeftBar;
    
    Notes *objNotes;
    NSInteger currentOrientaion;
    
    NSInteger TryAgainFlag;
    int int_MoveNextPre;    
    
}
@end

@implementation TestYourSelfViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = str_BarTitle;
    [self fnAddNavigationItems];
    
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
    
    //
    [self Fn_LoadQuestionData];
    
    bnPrev.enabled = NO;
    if(intTotalQuestions == 1){
        bnNext.enabled = NO;
    }
    
    
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
}


- (void) disableAllButtons:(int)questionNO{

    bnNext.enabled = NO;
    bnPrev.enabled = NO;
    bnSubmit.enabled = NO;
    
    [self fn_RemoveQuestionView];
    intCurrentQuestionIndex = questionNO - 1;
    [self Fn_LoadQuestionData];
    
    [self Fn_CheckNote];
    
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

-(void) onSelctor {
    [md Fn_ShowNote:2];
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
            NSLog(@"Match Pairs");
            if([UIScreen mainScreen].bounds.size.height == 568.0){
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
        //[self Fn_AnimateViewFromLeftToRightToView:animateView];
    }
    else if(int_MoveNextPre == 2) {
        //[self Fn_AnimateViewFromRightToLeftToView:animateView];
    }
    
    [self Fn_CheckNote];    
}

-(void) Fn_CheckNote {

    int question_no = intCurrentQuestionIndex + 1;
    
    objNotes = [db fnGetNote:categoryNumber AndChapterID:intCurrentTestYourSelf_ChapterId AndThematicId:intCurrentTestYourSelf_ThematicId AndQuestionNo:question_no];
    
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
    [md Fn_AddNote:objNotes];
}

-(void) fn_RemoveQuestionView {
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
    
    //bnShowScore.enabled = NO;
    
    
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
    
    //[resultView shouldAutorotateToInterfaceOrientation:currentOrientaion];
    
}


-(void)Fn_CallOrientaion_ios6
{
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
            //[multipleSelectionView.view removeFromSuperview];
            [dragDropView supportedInterfaceOrientations];
            break;
        case QUESTION_TYPE_FILLINBLANKS:
            [fillInTheBlanksView supportedInterfaceOrientations];
            break;
        case QUESTION_TYPE_RADIOBUTTONS:
            [radioGroupView supportedInterfaceOrientations];
            break;
        case QUESTION_TYPE_TRUEFLASE:
            [trueFalseView supportedInterfaceOrientations];
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
        case QUESTION_TYPE_DRAGDROPRADIOBUTTONS:
            [dragDropRadioView shouldAutorotateToInterfaceOrientation:currentOrientaion];
            break;
            
    }
    
    //[resultView shouldAutorotateToInterfaceOrientation:currentOrientaion];
}


// Animation

-(void) Fn_AnimateViewFromLeftToRightToView:(UIView*)view{

    // set up an animation for the transition between the views
//    CATransition *animation = [CATransition animation];
//    [animation setDuration:0.45];
//    [animation setType:kCATransitionPush];
//    [animation setSubtype:kCATransitionFromLeft];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [[view layer] addAnimation:animation forKey:@"myAnimation"];
    
}
- (void) Fn_AnimateViewFromRightToLeftToView:(UIView*)view{
    
    // set up an animation for the transition between the views
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.45];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[view layer] addAnimation:animation forKey:@"myAnimation"];
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
    //[resultView supportedInterfaceOrientations];
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

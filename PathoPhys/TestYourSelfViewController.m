//
//  TestYourSelfViewController.m
//  CraftApp
//
//  Created by PUN-MAC-012 on 25/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "TestYourSelfViewController.h"
#import "ChapterQuestionSet.h"

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
#import "ResultViewController.h"

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
    ResultViewController *resultView;
    CustomRightBarItem *customRightBar;
    CustomLeftBarItem *customLeftBar;
    
    Notes *objNotes;
    NSInteger currentOrientaion;
    
    NSInteger TryAgainFlag;
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
    viewMain = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1005, 600)];
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
    
    // Result
    resultView =[[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
    [self.view addSubview:resultView.view];
    resultView.view.hidden = YES;
    
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

-(void) fnAddNavigationItems
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_topbar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:COLOR_BLUE];
    
    customLeftBar = [[CustomLeftBarItem alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UIBarButtonItem *btnBar1 = [[UIBarButtonItem alloc] initWithCustomView:customLeftBar];
    self.navigationItem.leftBarButtonItem = btnBar1;
    [customLeftBar.btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    
    customRightBar = [[CustomRightBarItem alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
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
    
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
        {
            //            multipleSelectionView = [[MultipleSelectionViewController alloc] initWithNibName:@"MultipleSelectionViewController_iPad" bundle:nil];
            //            [multipleSelectionView fn_LoadDbData:objQue.strQuestionId];
            //            [viewMain addSubview:multipleSelectionView.view];
            //            multipleSelectionView.lblQuestionNo.text = [NSString stringWithFormat:@"%d/%d", objQue.intSequence, intTotalQuestions];
            dragDropView = [[DragDropViewController alloc] initWithNibName:@"DragDropViewController_iPad" bundle:nil];
            [dragDropView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:dragDropView.view];
            dragDropView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            dragDropView.parentObject = self;
        }
            break;
        case QUESTION_TYPE_FILLINBLANKS: {
            
            fillInTheBlanksView = [[FillInTheBlanksViewController alloc] initWithNibName:@"FillInTheBlanksViewController_iPad" bundle:nil];
            [fillInTheBlanksView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:fillInTheBlanksView.view];
            fillInTheBlanksView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            fillInTheBlanksView.parentObject = self;
            
        }
            break;
        case QUESTION_TYPE_RADIOBUTTONS: {
            
            radioGroupView = [[RadioGroupViewController alloc] initWithNibName:@"RadioGroupViewController_iPad" bundle:nil];
            [radioGroupView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:radioGroupView.view];
            radioGroupView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            radioGroupView.parentObject = self;
        }
            break;
        case QUESTION_TYPE_TRUEFLASE: {
            
            trueFalseView = [[TrueFalseViewController alloc] initWithNibName:@"TrueFalseViewController_iPad" bundle:nil];
            [trueFalseView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:trueFalseView.view];
            trueFalseView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            trueFalseView.parentObject = self;
        }
            break;
        case QUESTION_TYPE_MATCHTERMS: {
            
            matchPairsView = [[MatchPairsViewController alloc] initWithNibName:@"MatchPairsViewController_iPad" bundle:nil];
            [matchPairsView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:matchPairsView.view];
            matchPairsView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            matchPairsView.parentObject = self;
        }
            break;
        case QUESTION_TYPE_MCSS: {
            
            singleSelectionView = [[SingleSelectionViewController alloc] initWithNibName:@"SingleSelectionViewController_iPad" bundle:nil];
            [singleSelectionView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:singleSelectionView.view];
            singleSelectionView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            singleSelectionView.parentObject = self;
            
        }
            break;
        case QUESTION_TYPE_DRAGDROP:
        {
            dragDropView = [[DragDropViewController alloc] initWithNibName:@"DragDropViewController_iPad" bundle:nil];
            [dragDropView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:dragDropView.view];
            dragDropView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            dragDropView.parentObject = self;
        }
            break;
        case QUESTION_TYPE_DRAGDROPRADIOBUTTONS:
        {
            dragDropRadioView = [[DragDropRadioViewController alloc] initWithNibName:@"DragDropRadioViewController_iPad" bundle:nil];
            [dragDropRadioView fn_LoadDbData:objQue.strQuestionId];
            [viewMain addSubview:dragDropRadioView.view];
            dragDropRadioView.lblQuestionNo.text = [NSString stringWithFormat:@"Q. %d", objQue.intSequence];
            dragDropView.parentObject = self;
        }
            break;
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
    switch (objQue.intType) {
        case QUESTION_TYPE_MCMS:
            [dragDropView fn_CheckAnswersBeforeSubmit];
            if (TryAgainFlag != 1) {
                if (dragDropView.strVisitedAnswer.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:dragDropView.strVisitedAnswer];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:dragDropView.intVisited]];
            }
            [dragDropView fn_OnSubmitTapped];
            break;
        case QUESTION_TYPE_FILLINBLANKS:
            [fillInTheBlanksView fn_CheckAnswersBeforeSubmit];
            if (TryAgainFlag != 1) {
                if (fillInTheBlanksView.strVisitedAnswer.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:fillInTheBlanksView.strVisitedAnswer];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:fillInTheBlanksView.intVisited]];
            }
            [fillInTheBlanksView fn_OnSubmitTapped];
            break;
        case QUESTION_TYPE_RADIOBUTTONS:
            [radioGroupView fn_CheckAnswersBeforeSubmit];
            if (TryAgainFlag != 1) {
                if (radioGroupView.strVisitedAnswer.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:radioGroupView.strVisitedAnswer];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:radioGroupView.intVisited]];
            }
            [radioGroupView fn_OnSubmitTapped];
            break;
        case QUESTION_TYPE_TRUEFLASE:
            [trueFalseView fn_CheckAnswersBeforeSubmit];
            if (TryAgainFlag != 1) {
                if (trueFalseView.strVisitedAnswer.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:trueFalseView.strVisitedAnswer];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:trueFalseView.intVisited]];
            }
            [trueFalseView fn_OnSubmitTapped];
            break;
        case QUESTION_TYPE_MATCHTERMS:
            [matchPairsView fn_CheckAnswersBeforeSubmit];
            if (TryAgainFlag != 1) {
                if (matchPairsView.strVisitedAnswer.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:matchPairsView.strVisitedAnswer];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:matchPairsView.intVisited]];
            }
            [matchPairsView fn_OnSubmitTapped];
            break;
        case QUESTION_TYPE_MCSS:
            [singleSelectionView fn_CheckAnswersBeforeSubmit];
            if (TryAgainFlag != 1) {
                if (singleSelectionView.strVisitedAnswer.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:singleSelectionView.strVisitedAnswer];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:singleSelectionView.intVisited]];
            }
            [singleSelectionView fn_OnSubmitTapped];
            break;
        case QUESTION_TYPE_DRAGDROP:
            
            break;
            
        case QUESTION_TYPE_DRAGDROPRADIOBUTTONS:
            [dragDropRadioView fn_CheckAnswersBeforeSubmit];
            if (TryAgainFlag != 1) {
                if (dragDropRadioView.strVisitedAnswer.length > 0)
                    [objQuizTrack.arrSelectedAnswer replaceObjectAtIndex:intCurrentQuestionIndex withObject:dragDropRadioView.strVisitedAnswer];
                [objQuizTrack.arrVisited replaceObjectAtIndex:intCurrentQuestionIndex withObject:[NSNumber numberWithInt:dragDropRadioView.intVisited]];
            }
            [dragDropRadioView fn_OnSubmitTapped];
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
    
    // Disaply chapter name and thematic area
    resultView.lblChapterName.text = strCurrentChapterName;
    resultView.lblThematicArea.text = strCurrentThematicName;
    resultView.lblScore.text = [NSString stringWithFormat:@"%d out of %d questions answered correctly.", total_score, intTotalQuestions];
    resultView.view.hidden = NO;
    
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
    NSUInteger mask= UIInterfaceOrientationMaskPortrait;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    currentOrientaion = interfaceOrientation;
    [self Fn_CallOrientaion_ios6];
    [resultView supportedInterfaceOrientations];
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

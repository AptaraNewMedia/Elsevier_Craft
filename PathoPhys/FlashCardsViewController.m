//
//  FlashCardsViewController.m
//  CraftApp
//
//  Created by Rohit Yermalkar on 20/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "FlashCardsViewController.h"
#import "FlashcardButton.h"
#import "FlashcardsSet.h"
#import "CustomRightBarItem.h"
#import "CustomLeftBarItem.h"
#import "Chapters.h"
#import "Notes.h"
#import "FlipViewButton.h"


@interface FlashCardsViewController ()
{
    FlashcardButton *bnFront;
    FlashcardButton *bnBack;
    NSMutableArray *arrFlashcards;
    NSMutableArray *arrThumbs, *arrThumbsLarge;
    int currentindex;
    FlashcardsSet *objFlashcardSet;
    int STATEOFFLASHCARD;
    int intCurrentQuestionIndex;
    int intTotalQuestions;
    int prevThumbTapped;
    CustomRightBarItem *customRightBar;
    CustomLeftBarItem *customLeftBar;
    
    Notes *objNotes;
    NSInteger currentOrientaion;
    
    int touchBeganX, touchBeganY;
    int touchMovedX, touchMovedY;
    
    BOOL pageControlBeingUsed;
    
    FlipViewButton *flipViewButton;
    
    int prevFlipViewIndex;
    
}
@end

@implementation FlashCardsViewController

-(IBAction)Bn_Back_Tapped:(id)sender{
    //[md Fn_SubFlashCards];
    //[md Fn_AddMenu];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = str_BarTitle;
    
    // Do any additional setup after loading the view from its nib.
    scrollGallery.showsHorizontalScrollIndicator = NO;
    scrollGallery.showsVerticalScrollIndicator = NO;    

    scrollGallery.bounces = NO;

    Bn_Alphabet.titleLabel.textColor = COLOR_WHITE;
    Bn_ByChapter.titleLabel.textColor = COLOR_WHITE;
    Bn_Shuffle.titleLabel.textColor = COLOR_WHITE;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        scrollViewMiddle.frame = CGRectMake(scrollViewMiddle.frame.origin.x, scrollViewMiddle.frame.origin.y, 172, 350);
        
        Bn_Alphabet.titleLabel.font = FONT_10;
        Bn_ByChapter.titleLabel.font = FONT_10;
        Bn_Shuffle.titleLabel.font = FONT_10;
        
        lblChapterList.font = FONT_12;
        lblQuestionNo.font = FONT_10;
        
        
    }
    else {
        scrollViewMiddle.frame = CGRectMake(scrollViewMiddle.frame.origin.x, scrollViewMiddle.frame.origin.y, 382, 600);
        
        Bn_Alphabet.titleLabel.font = FONT_17;
        Bn_ByChapter.titleLabel.font = FONT_17;
        Bn_Shuffle.titleLabel.font = FONT_17;
        
        lblChapterList.font = FONT_17;
        lblQuestionNo.font = FONT_17;
        
    }
    
    [self fnAddNavigationItems];
    
    STATEOFFLASHCARD = 0;    
//    if (STATEOFFLASHCARD == 0) {
//        tblAlphabet.hidden = NO;
//        imgAlphabetBg.hidden = NO;
//    }

    tblAlphabet.hidden = YES;
    imgAlphabetBg.hidden = YES;

    
    view_chapterTbl.hidden=YES;
    btn_popupRemove.hidden=YES;

    lblQuestionNo.textColor = COLOR_BLACK;
    
    [self fnGetFlashcardData];
    
    if(viewAllFlashCards == 1){
        viewAllFlashCards = 0;
    }
    
    prevFlipViewIndex = 0;
    
    //Code for Exclusive Touch Enabling.
    for (UIView *myview in [self.view subviews]){
        if([myview isKindOfClass:[UIButton class]]){
            myview.exclusiveTouch = YES;
        }
    }
}

-(void) Fn_CheckNote:(NSString *)word {
    
    int question_no = intCurrentQuestionIndex + 1;
    
    objNotes = [db fnGetNote:categoryNumber AndChapterID:intCurrentFlashcard_ChapterId AndThematicId:0 AndQuestionNo:question_no];
    
    if (objNotes == Nil) {
        objNotes = [[Notes alloc] init];
        NOTES_MODE = 1;
        objNotes.intMode = 1;
        objNotes.strNoteTitle = [NSString stringWithFormat:@"FC-%d-%@", intCurrentFlashcard_ChapterId, word];
        [customRightBar.Bn_Addnote setTitle:@"Add Note" forState:UIControlStateNormal];
    }
    else {
        NOTES_MODE = 2;
        objNotes.intMode = 2;
        [customRightBar.Bn_Addnote setTitle:@"Edit Note" forState:UIControlStateNormal];
    }
    objNotes.intCategoryId = categoryNumber;
    objNotes.intChapterId = intCurrentFlashcard_ChapterId;
    objNotes.intThematicId = 0;
    objNotes.intQuestionNo = question_no;
    [md Fn_AddNote:objNotes];
}
-(void) fnAddNavigationItems{
    if (DEVICE_VERSION >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_topbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
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
-(void) fnGetFlashcardData{
    arrFlashcards = [db fnGetFlashcardsSet:intCurrentFlashcard_ChapterId];
    [self fnSetThumnailsLarge];
    [self fnSetThumnails];
}
-(void) fnSetLargeImage:(int)imageIndex ThumbIndex:(int)thumbIndex {

    
    objFlashcardSet = (FlashcardsSet *)[arrFlashcards objectAtIndex:imageIndex];
    
    flipViewButton = [arrThumbsLarge objectAtIndex:thumbIndex];
    flipViewButton.tag = objFlashcardSet.intIndex;    
    flipViewButton.textLabel.backgroundColor = COLOR_CLEAR;
    flipViewButton.textLabel.text = objFlashcardSet.strDefinition;
    flipViewButton.textLabel.textColor = COLOR_WHITE;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        flipViewButton.textLabel.frame = CGRectMake(5, 5, 160, 210);
        flipViewButton.textLabel.font = FONT_10;
        [flipViewButton setBackgroundImage:[UIImage imageNamed:@"Big_blue_flash_card.png"] forState:UIControlStateNormal];
    }
    else {
        flipViewButton.textLabel.frame = CGRectMake(55, 15, 270, 370);
        flipViewButton.textLabel.font = FONT_17;
        [flipViewButton setBackgroundImage:[UIImage imageNamed:@"img_flashcard_back.png"] forState:UIControlStateNormal];
    }
    flipViewButton.selectedButton = 1;
    
    lblQuestionNo.text = [NSString stringWithFormat:@"%d of %d", intCurrentQuestionIndex+1, intTotalQuestions];
    
    [self fnSetPreviousImage];
    
    prevFlipViewIndex = imageIndex;
    
    [self Fn_CheckNote:objFlashcardSet.strKey];
}
-(void) fnSetThumnailsLarge{
    
    int length = [arrFlashcards count];
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        scrollViewMiddle.contentSize = CGSizeMake(172*length, 225);
    }
    else {
        scrollViewMiddle.contentSize = CGSizeMake(382*length, 415);
    }
    CGFloat xOrigin = 0;
    arrThumbsLarge = [[NSMutableArray alloc] init];
    pageControlBeingUsed = NO;    
    for (int i=0; i<length; i++) {
        
        flipViewButton = [[FlipViewButton alloc] initWithFrame:CGRectMake(xOrigin, 0, 382, 415)];
        
        objFlashcardSet = (FlashcardsSet *)[arrFlashcards objectAtIndex:i];        
        
        flipViewButton.textLabel.frame = CGRectMake(55, 15, 270, 370);
        flipViewButton.textLabel.font = FONT_25;
        flipViewButton.textLabel.text = objFlashcardSet.strKey;
        
        flipViewButton.tag=i;
        flipViewButton.backgroundColor = COLOR_CLEAR;
        [flipViewButton setBackgroundImage:[UIImage imageNamed:@"img_flashcard_front.png"] forState:UIControlStateNormal];
        [flipViewButton addTarget:self action:@selector(onImageClick:) forControlEvents:UIControlEventTouchUpInside];
        flipViewButton.selectedButton = 0;        
        
        [scrollViewMiddle addSubview:flipViewButton];
        
        [arrThumbsLarge addObject:flipViewButton];
        
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            
            flipViewButton.frame = CGRectMake(xOrigin, 0, 172, 225);
            flipViewButton.textLabel.frame = CGRectMake(5, 5, 160, 210);
            flipViewButton.textLabel.font = FONT_12;
            [flipViewButton setBackgroundImage:[UIImage imageNamed:@"Big_grey_flash_card.png"] forState:UIControlStateNormal];
            xOrigin = xOrigin + 172;
        }
        else {
            xOrigin = xOrigin + 382;
        }
        
    }

}

-(void) fnSetThumnails{
    int length = [arrFlashcards count];
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        scrollGallery.contentSize = CGSizeMake(66*length, 98);
    }
    else {
        scrollGallery.contentSize = CGSizeMake(115*length, 180);
    }
    CGFloat xOrigin = 0;
    arrThumbs = [[NSMutableArray alloc] init];
    for (int i=0; i<length; i++) {
        objFlashcardSet = (FlashcardsSet *)[arrFlashcards objectAtIndex:i];
        
        FlashcardButton *bnThumb = [FlashcardButton buttonWithType:UIButtonTypeCustom];
        bnThumb.frame = CGRectMake(xOrigin, 0, 113, 158);
        bnThumb.tag = objFlashcardSet.intIndex;
        bnThumb.backgroundColor = COLOR_CLEAR;
        bnThumb.selectedButton = i;
        bnThumb.backgroundColor = COLOR_CLEAR;
        bnThumb.txtLabel.frame = CGRectMake(10, 5, 95, 140);
        bnThumb.txtLabel.backgroundColor = COLOR_CLEAR;
        bnThumb.txtLabel.font = FONT_14;
        bnThumb.txtLabel.text = objFlashcardSet.strKey;
        bnThumb.txtLabel.textColor = COLOR_BLACK;
        [bnThumb setTitle:@"" forState:UIControlStateNormal];        
        [bnThumb setImage:[UIImage imageNamed:@"img_flashcard_thumb.png"] forState:UIControlStateNormal];
        [bnThumb setImage:[UIImage imageNamed:@"img_flashcard_thumb_highlight.png"] forState:UIControlStateHighlighted];      
        [bnThumb addTarget:self action:@selector(onImageThumbTapped:) forControlEvents:UIControlEventTouchUpInside];
        [arrThumbs addObject:bnThumb];
        [scrollGallery addSubview:bnThumb];
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            bnThumb.frame = CGRectMake(xOrigin, 0, 66, 98);
            bnThumb.txtLabel.frame = CGRectMake(5, 5, 55, 90);
            bnThumb.txtLabel.font = FONT_10;
            [bnThumb setImage:[UIImage imageNamed:@"small_flash_card.png"] forState:UIControlStateNormal];
            [bnThumb setImage:[UIImage imageNamed:@"small_highlite_flash_card.png"] forState:UIControlStateHighlighted];
            
            xOrigin = xOrigin + 66;
            
        }
        else {
            xOrigin = xOrigin + 115;            
        }
        
    }
    
    intTotalQuestions = [arrThumbs count];
    intCurrentQuestionIndex = 0;
    prevThumbTapped = 0;
    btnPrev.enabled = NO;
    btnLargePrev.enabled = NO;
    if (intTotalQuestions == 1) {
        btnNext.enabled = NO;
        btnLargeNext.enabled = NO;
    }
    else {
        btnNext.enabled = YES;
        btnLargeNext.enabled = YES;
    }
    
    FlashcardButton *bn = [arrThumbs objectAtIndex:prevThumbTapped];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        [bn setImage:[UIImage imageNamed:@"small_highlite_flash_card.png"] forState:UIControlStateNormal];
    }
    else {
        [bn setImage:[UIImage imageNamed:@"img_flashcard_thumb_highlight.png"] forState:UIControlStateNormal];        
    }
    
    [self fnSetLargeImage:intCurrentQuestionIndex ThumbIndex:intCurrentQuestionIndex];
}
-(void) fnResetThumnails:(int)charno{
   
    NSString *let  =  [NSString stringWithFormat:@"%c", (char) charno + 64];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strKey BEGINSWITH[cd] %@", let];
    NSArray *aElements = [arrFlashcards filteredArrayUsingPredicate:predicate];
    int length = [aElements count];
    if (length != 0) {
        
        // Thumbnails        
        [self fnRemoveThumnails];
        arrThumbs = [[NSMutableArray alloc] init];        
        scrollGallery.contentSize = CGSizeMake(115*length, 180);
        CGFloat xOrigin = 0;
        for (int i=0; i<length; i++) {
            objFlashcardSet = (FlashcardsSet *)[aElements objectAtIndex:i];
            
            FlashcardButton *bnThumb = [FlashcardButton buttonWithType:UIButtonTypeCustom];
            bnThumb.frame = CGRectMake(xOrigin, 0, 113, 158);
            bnThumb.tag = objFlashcardSet.intIndex;
            bnThumb.backgroundColor = COLOR_CLEAR;
            bnThumb.selectedButton = i;            
            bnThumb.backgroundColor = COLOR_CLEAR;
            bnThumb.txtLabel.frame = CGRectMake(5, 5, 100, 150);
            bnThumb.txtLabel.backgroundColor = COLOR_CLEAR;
            bnThumb.txtLabel.font = FONT_15;
            bnThumb.txtLabel.text = objFlashcardSet.strKey;
            bnThumb.txtLabel.textColor = COLOR_BLACK;
            [bnThumb setTitle:@"" forState:UIControlStateNormal];
            [bnThumb setBackgroundImage:[UIImage imageNamed:@"img_flashcard_thumb.png"] forState:UIControlStateNormal];
            [bnThumb setBackgroundImage:[UIImage imageNamed:@"img_flashcard_thumb_highlight.png"] forState:UIControlStateHighlighted];
            [bnThumb addTarget:self action:@selector(onImageThumbTapped:) forControlEvents:UIControlEventTouchUpInside];
            [arrThumbs addObject:bnThumb];
            [scrollGallery addSubview:bnThumb];
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                bnThumb.frame = CGRectMake(xOrigin, 0, 66, 98);
                bnThumb.txtLabel.frame = CGRectMake(5, 5, 55, 90);
                bnThumb.txtLabel.font = FONT_10;
                [bnThumb setImage:[UIImage imageNamed:@"small_flash_card.png"] forState:UIControlStateNormal];
                [bnThumb setImage:[UIImage imageNamed:@"small_highlite_flash_card.png"] forState:UIControlStateHighlighted];
                
                xOrigin = xOrigin + 66;
                
            }
            else {
                xOrigin = xOrigin + 115;
            }
        }
        intTotalQuestions = [arrThumbs count];
        intCurrentQuestionIndex = 0;
        prevThumbTapped = 0;
        prevFlipViewIndex = 0;
        btnPrev.enabled = NO;
        btnLargePrev.enabled = NO;
        if (intTotalQuestions == 1) {
            btnNext.enabled = NO;
            btnLargeNext.enabled = NO;
        }
        else {
            btnNext.enabled = YES;
            btnLargeNext.enabled = YES;
        }
        FlashcardButton *bn = [arrThumbs objectAtIndex:prevThumbTapped];
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            [bn setImage:[UIImage imageNamed:@"small_highlite_flash_card.png"] forState:UIControlStateNormal];            
        }
        else {
            [bn setImage:[UIImage imageNamed:@"img_flashcard_thumb_highlight.png"] forState:UIControlStateNormal];
        }
        
        lblQuestionNo.text = [NSString stringWithFormat:@"%d of %d", intCurrentQuestionIndex+1, intTotalQuestions];
        
        
        // Large Thumbs
        scrollViewMiddle.contentSize = CGSizeMake(382*length, 415);
        xOrigin = 0;
        arrThumbsLarge = [[NSMutableArray alloc] init];
        for (int i=0; i<length; i++) {
            
            flipViewButton = [[FlipViewButton alloc] initWithFrame:CGRectMake(xOrigin, 0, 382, 415)];
            objFlashcardSet = (FlashcardsSet *)[aElements objectAtIndex:i];
            flipViewButton.textLabel.frame = CGRectMake(55, 15, 270, 370);
            flipViewButton.textLabel.font = FONT_25;
            flipViewButton.textLabel.text = objFlashcardSet.strKey;
            
            flipViewButton.tag = objFlashcardSet.intIndex;
            flipViewButton.backgroundColor = COLOR_CLEAR;
//            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
//                [flipViewButton setBackgroundImage:[UIImage imageNamed:@"Big_grey_flash_card.png"] forState:UIControlStateNormal];            }
//            else {
//                [flipViewButton setBackgroundImage:[UIImage imageNamed:@"img_flashcard_front.png"] forState:UIControlStateNormal];
//            }
            
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                
                flipViewButton.frame = CGRectMake(xOrigin, 0, 172, 225);
                flipViewButton.textLabel.frame = CGRectMake(5, 5, 160, 210);
                flipViewButton.textLabel.font = FONT_12;
                [flipViewButton setBackgroundImage:[UIImage imageNamed:@"Big_grey_flash_card.png"] forState:UIControlStateNormal];
                xOrigin = xOrigin + 172;
            }
            else {
                xOrigin = xOrigin + 382;
            }

            
            
            
            [flipViewButton addTarget:self action:@selector(onImageClick:) forControlEvents:UIControlEventTouchUpInside];
            flipViewButton.selectedButton = 0;
            [scrollViewMiddle addSubview:flipViewButton];
            [arrThumbsLarge addObject:flipViewButton];
            
            //xOrigin = xOrigin + 382;
        }
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Message"];
        [alert addButtonWithTitle:@"Ok"];
        [alert setMessage:@"No data found."];
        [alert show];
    }
}
-(void) fnRemoveThumnails{
    
    for (UIView *subView in scrollGallery.subviews)
    {
        [subView removeFromSuperview];
    }
    
    for (UIView *subView in scrollViewMiddle.subviews)
    {
        [subView removeFromSuperview];
    }
    
}
-(void) fnThumbScrollerMove {
	
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        int index = (intCurrentQuestionIndex/4);
        
        [scrollGallery setContentOffset:CGPointMake(index * scrollGallery.frame.size.width, 0) animated:YES];
        [scrollViewMiddle setContentOffset:CGPointMake(intCurrentQuestionIndex*172, 0) animated:YES];
    }
    else {
        int index = (intCurrentQuestionIndex/6);
        if (DEVICE_ORIENTATION == 1 || DEVICE_ORIENTATION == 2) {
            index = (intCurrentQuestionIndex/4);
        }
        
        [scrollGallery setContentOffset:CGPointMake(index * scrollGallery.frame.size.width, 0) animated:YES];
        [scrollViewMiddle setContentOffset:CGPointMake(intCurrentQuestionIndex*382, 0) animated:YES];        
    }
}
-(void) fnSetPreviousImage {
    if (prevFlipViewIndex != -1) {
        
        if(arrThumbsLarge.count > 1) {
        
        FlipViewButton *newflipViewButton = [arrThumbsLarge objectAtIndex:prevFlipViewIndex];
        
        objFlashcardSet = (FlashcardsSet *)[arrFlashcards objectAtIndex:newflipViewButton.tag];

            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                newflipViewButton.textLabel.frame = CGRectMake(5, 5, 160, 210);
                newflipViewButton.textLabel.font = FONT_12;
                [newflipViewButton setBackgroundImage:[UIImage imageNamed:@"Big_grey_flash_card.png"] forState:UIControlStateNormal];

            }
            else {
                newflipViewButton.textLabel.frame = CGRectMake(55, 15, 270, 370);
                newflipViewButton.textLabel.font = FONT_25;
                [newflipViewButton setBackgroundImage:[UIImage imageNamed:@"img_flashcard_front.png"] forState:UIControlStateNormal];
            }
            newflipViewButton.textLabel.text = objFlashcardSet.strKey;
            newflipViewButton.selectedButton = 0;
            
        }
    }
}

// =====================================================
-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onImageThumbTapped:(id)sender{
    
    
    FlashcardButton *bn1 = [arrThumbs objectAtIndex:prevThumbTapped];
    FlashcardButton *bn2 = [arrThumbs objectAtIndex:[sender selectedButton]];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        [bn1 setImage:[UIImage imageNamed:@"small_flash_card.png"] forState:UIControlStateNormal];
        [bn2 setImage:[UIImage imageNamed:@"small_highlite_flash_card.png"] forState:UIControlStateNormal];
        
    }
    else {
        [bn1 setImage:[UIImage imageNamed:@"img_flashcard_thumb.png"] forState:UIControlStateNormal];
        [bn2 setImage:[UIImage imageNamed:@"img_flashcard_thumb_highlight.png"] forState:UIControlStateNormal];
    }
    
    if (intTotalQuestions == 1) {
        btnPrev.enabled = NO;
        btnLargePrev.enabled = NO;
        btnNext.enabled = NO;
        btnLargeNext.enabled = NO;
    }
    else if ([sender selectedButton] == intTotalQuestions-1) {
        btnPrev.enabled = YES;
        btnLargePrev.enabled = YES;        
        btnNext.enabled = NO;
        btnLargeNext.enabled = NO;
    }
    else if ([sender selectedButton] == 0) {
        btnPrev.enabled = NO;
        btnLargePrev.enabled = NO;
        btnNext.enabled = YES;
        btnLargeNext.enabled = YES;        
    }
    else {
        btnNext.enabled = YES;
        btnLargeNext.enabled = YES;
        btnPrev.enabled = YES;
        btnLargePrev.enabled = YES;
    }
    intCurrentQuestionIndex = [sender selectedButton];
    prevThumbTapped = [sender selectedButton];
    [self fnThumbScrollerMove];
    [self fnSetLargeImage:bn2.tag ThumbIndex:[sender selectedButton]];
    prevFlipViewIndex = [sender selectedButton];
}

-(IBAction)onNext:(id)sender{
    if (intCurrentQuestionIndex == intTotalQuestions-1) {
        return;
    }
    intCurrentQuestionIndex++;
    btnPrev.enabled = YES;
    btnLargePrev.enabled = YES;
    for (int i =0; i < [arrThumbs count]; i++) {
        FlashcardButton *bnTemp = [arrThumbs objectAtIndex:i];
        [bnTemp setImage:[UIImage imageNamed:@"img_flashcard_thumb.png"] forState:UIControlStateNormal];    
    }
    
    lblQuestionNo.text = [NSString stringWithFormat:@"%d of %d", intCurrentQuestionIndex+1, intTotalQuestions];

    
    FlashcardButton *bn2 = [arrThumbs objectAtIndex:intCurrentQuestionIndex];
    [bn2 setImage:[UIImage imageNamed:@"img_flashcard_thumb_highlight.png"] forState:UIControlStateNormal];
    prevThumbTapped = intCurrentQuestionIndex;
    prevFlipViewIndex = intCurrentQuestionIndex;
    [self fnSetPreviousImage];
    [self fnThumbScrollerMove];
    if (intCurrentQuestionIndex == intTotalQuestions-1) {
        btnNext.enabled = NO;
        btnLargeNext.enabled = NO;
    }
        
}
-(IBAction)onPrev:(id)sender{
    if (intCurrentQuestionIndex == 0) {
        return;
    }
    intCurrentQuestionIndex--;
    btnNext.enabled = YES;
    btnLargeNext.enabled = YES;
    for (int i =0; i < [arrThumbs count]; i++) {
        FlashcardButton *bnTemp = [arrThumbs objectAtIndex:i];
        [bnTemp setImage:[UIImage imageNamed:@"img_flashcard_thumb.png"] forState:UIControlStateNormal];
    }
    
    lblQuestionNo.text = [NSString stringWithFormat:@"%d of %d", intCurrentQuestionIndex+1, intTotalQuestions];
    
    FlashcardButton *bn2 = [arrThumbs objectAtIndex:intCurrentQuestionIndex];
    [bn2 setImage:[UIImage imageNamed:@"img_flashcard_thumb_highlight.png"] forState:UIControlStateNormal];
    prevThumbTapped = intCurrentQuestionIndex;
    prevFlipViewIndex = intCurrentQuestionIndex;
    [self fnSetPreviousImage];
    [self fnThumbScrollerMove];
    if (intCurrentQuestionIndex == 0) {
        btnPrev.enabled = NO;
        btnLargePrev.enabled = NO;
    }
    
}
-(void) onImageClick :(id) sender {
	
	flipViewButton = (FlipViewButton*)sender;
    objFlashcardSet = (FlashcardsSet *)[arrFlashcards objectAtIndex:flipViewButton.tag];
    
	if(flipViewButton.selectedButton==1)
	{
		//Animation;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:sender cache:YES];
		[UIView commitAnimations];		
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            flipViewButton.textLabel.frame = CGRectMake(5, 5, 160, 210);
            flipViewButton.textLabel.font = FONT_12;
            [flipViewButton setBackgroundImage:[UIImage imageNamed:@"Big_grey_flash_card.png"] forState:UIControlStateNormal];
            
        }
        else {
            flipViewButton.textLabel.frame = CGRectMake(55, 15, 270, 370);
            flipViewButton.textLabel.font = FONT_25;
            [flipViewButton setBackgroundImage:[UIImage imageNamed:@"img_flashcard_front.png"] forState:UIControlStateNormal];
        }
        
        flipViewButton.textLabel.text = objFlashcardSet.strKey;
        flipViewButton.selectedButton = 0;
	}
	else
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:sender cache:YES];
		[UIView commitAnimations];		
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            flipViewButton.textLabel.frame = CGRectMake(5, 5, 160, 210);
            flipViewButton.textLabel.font = FONT_10;
            [flipViewButton setBackgroundImage:[UIImage imageNamed:@"Big_blue_flash_card.png"] forState:UIControlStateNormal];
        }
        else {
            flipViewButton.textLabel.frame = CGRectMake(55, 15, 270, 370);
            flipViewButton.textLabel.font = FONT_12;
            [flipViewButton setBackgroundImage:[UIImage imageNamed:@"img_flashcard_back.png"] forState:UIControlStateNormal];
        }
        flipViewButton.textLabel.backgroundColor = COLOR_CLEAR;
        flipViewButton.textLabel.text = objFlashcardSet.strDefinition;
        flipViewButton.textLabel.textColor = COLOR_WHITE;
        flipViewButton.selectedButton = 1;
        
	}
}
//=====================================================



// Segment
//=======================================================================================
-(IBAction)segment_Tapped:(id)sender{
    [Bn_Alphabet setBackgroundImage:nil forState:UIControlStateNormal];
    [Bn_Shuffle setBackgroundImage:nil forState:UIControlStateNormal];
    [Bn_ByChapter setBackgroundImage:nil forState:UIControlStateNormal];
    
    STATEOFFLASHCARD = [sender tag];
    if ([sender tag] == 0)
    {
        tblAlphabet.hidden = NO;
        imgAlphabetBg.hidden = NO;
        view_chapterTbl.hidden=YES;
        btn_popupRemove.hidden=YES;
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            [Bn_Alphabet setBackgroundImage:[UIImage imageNamed:@"flash_card_Segment_BG_01.png"] forState:UIControlStateNormal];
        }
        else {
            [Bn_Alphabet setBackgroundImage:[UIImage imageNamed:@"Flash_Card_blue_01.png"] forState:UIControlStateNormal];
        }
        
        arrFlashcards = [db fnGetSortedFlashcards:intCurrentFlashcard_ChapterId];        
        
        [self fnRemoveThumnails];
        [self fnSetThumnails];
        [self fnSetThumnailsLarge];
    }
    else if ([sender tag] == 1)
    {
        tblAlphabet.hidden = YES;
        imgAlphabetBg.hidden = YES;
        view_chapterTbl.hidden=YES;
        btn_popupRemove.hidden=YES;        

        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            [Bn_Shuffle setBackgroundImage:[UIImage imageNamed:@"flash_card_Segment_BG_02.png"] forState:UIControlStateNormal];            
        }
        else {
            [Bn_Shuffle setBackgroundImage:[UIImage imageNamed:@"Flash_Card_blue_02.png"] forState:UIControlStateNormal];
        }
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[arrFlashcards count]];		
		NSMutableArray *copy = [arrFlashcards mutableCopy];
		while ([copy count] > 0)
		{
			int index = arc4random() % [copy count];
			id objectToMove = [copy objectAtIndex:index];
			[array addObject:objectToMove];
			[copy removeObjectAtIndex:index];
		}		
		arrFlashcards = [array mutableCopy];        
        [self fnRemoveThumnails];
        [self fnSetThumnails];
        [self fnSetThumnailsLarge];        
    }
    else if ([sender tag] == 2)
    {
        tblAlphabet.hidden = YES;
        imgAlphabetBg.hidden = YES;
        view_chapterTbl.hidden=NO;
        btn_popupRemove.hidden=NO;
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            [Bn_ByChapter setBackgroundImage:[UIImage imageNamed:@"flash_card_Segment_BG_03.png"] forState:UIControlStateNormal];            
        }
        else {
            [Bn_ByChapter setBackgroundImage:[UIImage imageNamed:@"Flash_Card_blue_03.png"] forState:UIControlStateNormal];
        }
        
    }
    
}
//=======================================================================================


// TableView Delegate Methods
//=======================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int returnCount;
    
        if (tableView==tblAlphabet)
        {
            returnCount =27;
        }
        else
        {
            returnCount =[arr_chaptersTestAndFlashcard count];
            //return [arr_chaptersTestAndFlashcard count];
        }
    NSLog(@"Return Count %d",returnCount);
    return returnCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (tableView==tblAlphabet)
    {

        NSLog(@"Counter: %d",indexPath.row);
        
        
             if (cell == nil)
             {
                 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

             }
             cell.textLabel.textColor = COLOR_BottomBlueButton;
             cell.textLabel.font = FONT_12;
             if (indexPath.row == 0)
             {
                 cell.textLabel.text = @"All";
             }
             else
             {
                 char letter = (char) indexPath.row + 64;
                 cell.textLabel.text = [NSString stringWithFormat:@"%c", letter];                 
             }
        
             NSLog(@"Text: %@",cell.textLabel.text);
        
             cell.textLabel.textAlignment = UITextAlignmentCenter;             
             UIImageView *selectionImage = [[UIImageView alloc] init];
             if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {                 
                 cell.textLabel.font = FONT_10;
                 selectionImage.image = [UIImage imageNamed:@"highlite_patch_abcd_bar.png"];
             }
             else {
                 
                 selectionImage.image = [UIImage imageNamed:@"img_abcd_row.png"];
             }
             cell.selectedBackgroundView = selectionImage;
             
             NSString *let  =  [NSString stringWithFormat:@"%c", (char) indexPath.row + 64];
 
             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strKey BEGINSWITH[cd] %@", let];
             NSArray *aElements = [arrFlashcards filteredArrayUsingPredicate:predicate];
             int length = [aElements count];
             
             if(length == 0 && indexPath.row != 0){
                 cell.userInteractionEnabled = NO;
                 cell.textLabel.textColor = COLOR_DARKGRAY;
             }
             else{
                 cell.userInteractionEnabled = YES;
             }             
         }
    else
    {
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.textColor = COLOR_BottomBlueButton;
            cell.textLabel.font = FONT_15;
            
            Chapters *objChap;
            objChap = (Chapters *) [arr_chaptersTestAndFlashcard objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%d. %@",indexPath.row + 1,objChap.strChapterTitle];
            UIImageView *selectionImage = [[UIImageView alloc] init];
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
                selectionImage.image = [UIImage imageNamed:@"Chapter_list_box_Select.png"];                
                cell.textLabel.font = FONT_10;
            }
            else {
                selectionImage.image = [UIImage imageNamed:@"img_chaplist_popup_row.png"];
                
            }
            
            cell.selectedBackgroundView = selectionImage;
            
            if (indexPath.row == intCurrentFlashcard_ChapterId-1) {             
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }

        }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==tblAlphabet)
    {
        if (indexPath.row == 0)
        {
            intCurrentQuestionIndex = 0;
            prevFlipViewIndex = 0;
            prevThumbTapped = 0;
            [self fnRemoveThumnails];
            [self fnSetThumnails];
            [self fnSetThumnailsLarge];
        }
        else
        {
            [self fnResetThumnails:indexPath.row];

            
        }
    }
    else
    {
        Chapters *objChap = (Chapters *)[arr_chaptersTestAndFlashcard objectAtIndex:indexPath.row];
        intCurrentFlashcard_ChapterId = objChap.intChapterId;
        arrFlashcards = [db fnGetFlashcardsSet:intCurrentFlashcard_ChapterId];
        str_BarTitle = [NSString stringWithFormat:@"Flash Cards - %@", objChap.strChapterTitle];
        intCurrentQuestionIndex = 0;
        prevFlipViewIndex = 0;
        prevThumbTapped = 0;
        self.title = str_BarTitle;
        [self fnRemoveThumnails];
        [self fnSetThumnails];
        [self fnSetThumnailsLarge];
        [tblAlphabet reloadData];
        view_chapterTbl.hidden=YES;
        btn_popupRemove.hidden=YES;
        [Bn_ByChapter setBackgroundImage:nil forState:UIControlStateNormal];
    }
}
//=======================================================================================
#pragma Orientation
//------------------------------
- (BOOL) shouldAutorotate{
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    currentOrientaion = interfaceOrientation;
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations{
    
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
-(void)Fn_rotatePortrait{
    [imgBG setFrame:CGRectMake(0, 0, 768, 1004)];
    [imgBG setImage:[UIImage imageNamed:@"img_bg_p.png"]];
    
    [viewLargeImage setFrame:CGRectMake(194, 177, 382, 415)];
    
    
    [scrollViewMiddle setFrame:CGRectMake(194, 177, 382, scrollViewMiddle.frame.size.height)];
    
    
    
    [scrollGallery setFrame:CGRectMake(147, 716, 467, 280)];
    
    
    [btnLargePrev setFrame:CGRectMake(78, 345, 70, 70)];
    [btnLargeNext setFrame:CGRectMake(596, 345, 70, 70)];
    [btnPrev setFrame:CGRectMake(93, 772, 32, 32)];
    [btnNext setFrame:CGRectMake(650, 772, 32, 32)];
    
    [imgAlphabetBg setFrame:CGRectMake(700, 60, 34, 614)];
    
    
    [tblAlphabet setFrame:CGRectMake(700, 70, 34, 614)];
    
    [view_chapterTbl setFrame:CGRectMake(570, 68, 188, 417)];
    [segControllor setFrame:CGRectMake(209, 68, 350, 44)];
    [img_shado setFrame:CGRectMake(0, 700, 768, 60)];
    [btn_popupRemove setFrame:CGRectMake(0, 168, 768, 900)];
    
    [viewSegment setFrame:CGRectMake(190, 68, 374, 45)];
    
    [Bn_Alphabet setFrame:CGRectMake(2, 0, 123, 45)];
    [Bn_Shuffle setFrame:CGRectMake(127, 0, 120, 45)];
    [Bn_ByChapter setFrame:CGRectMake(249, 0, 123, 45)];
    
    [lblQuestionNo  setFrame:CGRectMake(340, 600, 92, 21)];
    
}
-(void)Fn_rotateLandscape{
    [imgBG setFrame:CGRectMake(0, 0, 1024, 699)];
    [imgBG setImage:[UIImage imageNamed:@"img_bg.png"]];
    
    [viewLargeImage setFrame:CGRectMake(321, 67, 382, 415)];
    
    [scrollViewMiddle setFrame:CGRectMake(321, 67, 382, scrollViewMiddle.frame.size.height)];
    
    [scrollGallery setFrame:CGRectMake(147, 516, 687, 280)];
    
    [btnLargePrev setFrame:CGRectMake(242, 235, 70, 70)];
    [btnLargeNext setFrame:CGRectMake(712, 235, 70, 70)];
    
    [btnPrev setFrame:CGRectMake(93, 572, 32, 32)];
    [btnNext setFrame:CGRectMake(865, 572, 32, 32)];
    
    [imgAlphabetBg setFrame:CGRectMake(972, 10, 34, 614)];
    
    [tblAlphabet setFrame:CGRectMake(972, 20, 34, 614)];
    
    [view_chapterTbl setFrame:CGRectMake(704, 18, 188, 417)];
    
    [segControllor setFrame:CGRectMake(337, 18, 350, 44)];
    
    [img_shado setFrame:CGRectMake(0, 500, 1024, 60)];
    
    [btn_popupRemove setFrame:CGRectMake(0, 68, 1024, 700)];
    
    [viewSegment setFrame:CGRectMake(325, 15, 374, 45)];
    
    
    [Bn_Alphabet setFrame:CGRectMake(2, 0, 123, 45)];
    [Bn_Shuffle setFrame:CGRectMake(127, 0, 120, 45)];
    [Bn_ByChapter setFrame:CGRectMake(249, 0, 123, 45)];
    
    [lblQuestionNo  setFrame:CGRectMake(466, 471, 92, 21)];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
    if (scrollViewMiddle == scrollView) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            intCurrentQuestionIndex = (scrollView.contentOffset.x / 172);
        }
        else {
            intCurrentQuestionIndex = (scrollView.contentOffset.x / 382);
        }
    }
    else if (scrollGallery == scrollView) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            intCurrentQuestionIndex = (scrollView.contentOffset.x / 115);
        }
        else {
            intCurrentQuestionIndex = (scrollView.contentOffset.x / 66);
        }
        
    }
    lblQuestionNo.text = [NSString stringWithFormat:@"%d of %d", intCurrentQuestionIndex+1, intTotalQuestions];
    
    int index = (intCurrentQuestionIndex/6);
    if (DEVICE_ORIENTATION == 1 || DEVICE_ORIENTATION == 2) {
        index = (intCurrentQuestionIndex/4);
    }
    
    [scrollGallery setContentOffset:CGPointMake(index * scrollGallery.frame.size.width, 0) animated:YES];        
    
    FlashcardButton *bn1 = [arrThumbs objectAtIndex:prevThumbTapped];
    [bn1 setImage:[UIImage imageNamed:@"img_flashcard_thumb.png"] forState:UIControlStateNormal];
    FlashcardButton *bn2 = [arrThumbs objectAtIndex:intCurrentQuestionIndex];
    [bn2 setImage:[UIImage imageNamed:@"img_flashcard_thumb_highlight.png"] forState:UIControlStateNormal];
    
    if (intCurrentQuestionIndex == intTotalQuestions-1) {
        btnNext.enabled = NO;
        btnLargeNext.enabled = NO;
    }
    else if (intCurrentQuestionIndex == 0) {
        btnPrev.enabled = NO;
        btnLargePrev.enabled = NO;
    }
    else {
        btnNext.enabled = YES;
        btnLargeNext.enabled = YES;
        btnPrev.enabled = YES;
        btnLargePrev.enabled = YES;
    }
    [self fnSetPreviousImage];
    
    prevFlipViewIndex = intCurrentQuestionIndex;
    prevThumbTapped = intCurrentQuestionIndex;
    [self fnThumbScrollerMove];

}

//Touch Swipe Detection Methods
//=======================================================================================
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint pt;
	NSSet *allTouches = [event allTouches];
	if ([allTouches count] == 1)
	{
		UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
		if ([touch tapCount] == 1)
		{
			pt = [touch locationInView:self.view];
			touchBeganX = pt.x;
			touchBeganY = pt.y;
		}
	}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint pt;
	NSSet *allTouches = [event allTouches];
	if ([allTouches count] == 1)
	{
		UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
		if ([touch tapCount] == 1)
		{
			pt = [touch locationInView:self.view];
			touchMovedX = pt.x;
			touchMovedY = pt.y;
		}
	}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event allTouches];
	if ([allTouches count] == 1)
	{
		int diffX = touchMovedX - touchBeganX;
		int diffY = touchMovedY - touchBeganY;
		if (diffY >= -20 && diffY <= 20)
		{
 			if (diffX > 2)
			{
				NSLog(@"swipe right");
                //Previous
                [self onPrev:nil];
				// do something here
			}
			else if (diffX < -2)
			{
				NSLog(@"swipe left");
                //Next
                [self onNext:nil];
				// do something else here
			}
		}
	}
}
//=======================================================================================



@end
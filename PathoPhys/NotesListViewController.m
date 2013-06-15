//
//  ScoreViewController.m
//  ScoreViewApp
//
//  Created by Aptara on 10/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "NotesListViewController.h"
#import "NotesCell.h"
#import "Notes.h"
#import "Chapters.h"
#import "ThematicArea.h"
#import "FlashCardsViewController.h"
#import "TestYourSelfViewController.h"
#import "CaseStudyViewController.h"
#import "CustomLeftBarItem.h"
#import "CustomRightBarItem.h"

@interface NotesListViewController ()
{
    IBOutlet UIImageView *imgPatch;
    IBOutlet UIImageView *imgBG;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnClose;
    IBOutlet UITableView *tbl;
    
    IBOutlet UILabel *lblTitleSerialNo;
    IBOutlet UILabel *lblTitleName;
    IBOutlet UILabel *lblTitleDescription;
    IBOutlet UILabel *lblTitleDate;
    
    IBOutlet UILabel *lblAddNote;
    
    IBOutlet UITextField *txtSearch;
    
    NSMutableArray * arrNotes;
    Notes *objNotes;
    
    NSMutableArray *arrsearch;
    
    NSMutableArray *tableData;
    
    int currentOrientation;
    FlashCardsViewController *flashCardsViewController;
    TestYourSelfViewController *testYourSelfViewController;
    CaseStudyViewController *caseStudyViewController;
    
    
    CustomRightBarItem *customRightBar;
    CustomLeftBarItem *customLeftBar;
    
    IBOutlet UILabel *lbl_swipe;
    
    
    // 1- Landscape
    // 2- Portrait
}
@end

@implementation NotesListViewController
@synthesize FromMenu;
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"Notes List";
    
    [self fnAddNavigationItems];
    
    arrNotes = [db fnGetNotesList];
    arrsearch = [[NSMutableArray alloc] init];
    //arrsearch = arrNotes;
    
    [arrsearch addObjectsFromArray:arrNotes];
    
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        txtSearch.font = FONT_8;
    }
    else
    {
        txtSearch.font = FONT_17;
    }
    
    txtSearch.delegate = self;
    txtSearch.textColor = COLOR_BLACK;
    
//    lblTitle.font = FONT_20;
//    lblTitle.textColor = COLOR_WHITE;
    
    //btnClose.hidden = YES;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        if (FromMenu == 0) {
            [lblAddNote setFrame:CGRectMake(lblAddNote.frame.origin.x, 25, lblAddNote.frame.size.width, lblAddNote.frame.size.height)];
            [btnClose setFrame:CGRectMake(btnClose.frame.origin.x, 20, btnClose.frame.size.width, btnClose.frame.size.height)];
            [lblTitleSerialNo setFrame:CGRectMake(lblTitleSerialNo.frame.origin.x, 75, lblTitleSerialNo.frame.size.width, lblTitleSerialNo.frame.size.height)];
            [lblTitleName setFrame:CGRectMake(lblTitleName.frame.origin.x, 75, lblTitleName.frame.size.width, lblTitleName.frame.size.height)];
            [lblTitleDate setFrame:CGRectMake(lblTitleDate.frame.origin.x, 75, lblTitleDate.frame.size.width, lblTitleDate.frame.size.height)];
            
            [txtSearch setFrame:CGRectMake(txtSearch.frame.origin.x, 52, txtSearch.frame.size.width, txtSearch.frame.size.height)];
            
            [tbl setFrame:CGRectMake(tbl.frame.origin.x, 98, tbl.frame.size.width, tbl.frame.size.height)];
        }
        
    }
    else {
        if (FromMenu == 1) {
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"img_topbar.png"] forBarMetrics:UIBarMetricsDefault];
            self.title = @"";
            lblTitle = [[UILabel alloc] init];
            [lblTitle setFrame:CGRectMake(0, 0, 100, 30)];
            lblTitle.text = @"Notes List";
            lblTitle.textColor = COLOR_WHITE;
            [self.navigationItem.titleView addSubview:lblTitle];

        }        
    }

}
-(void)viewWillAppear:(BOOL)animated {
    [md Fn_removeInfoViewPopup];
    [md Fn_removeNoteViewPopup];
    NOTES_MODE = 0;
    
    if([arrsearch count] > 0)
    {
        lbl_swipe.hidden=NO;
    }
    else
    {
        lbl_swipe.hidden=YES;
    }
}
-(IBAction)onClose:(id)sender{
    if (FromMenu == 1) {
        [md Fn_SubNotesListOnMenu];
        [md Fn_AddMenu];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)onBack:(id)sender{
    if (FromMenu == 1) {
        [md Fn_SubNotesListOnMenu];
        [md Fn_AddMenu];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    
    
    
    customRightBar.btnScore.hidden = YES;
    customRightBar.btnNote.hidden = YES;
    customRightBar.btnInfo.hidden = YES;
    
    customLeftBar.btnHome.hidden = YES;
    customLeftBar.btnBack.frame = CGRectMake(0, 7, 45, 30) ;
    
}

// Tables

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrsearch.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"tblCellView";
    NotesCell *cell = (NotesCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil) {
        
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
        {
            NSArray *cellArray_Phone = [[NSBundle mainBundle] loadNibNamed:@"NotesCell_iPhone" owner:self options:nil];
            cell = [cellArray_Phone lastObject];
        }
        else
        {
            if (currentOrientation == 2) {
                NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"NotesCellP" owner:self options:nil];
                cell = [cellArray lastObject];
                
            }
            else  {
                NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"NotesCell" owner:self options:nil];
                cell = [cellArray lastObject];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        cell.lbl_serionNo.font = FONT_8;
        cell.lbl_name.font = FONT_8;
        cell.lbl_date.font = FONT_8;
        cell.lbl_desc.font = FONT_8;
    }
    else
    {
        cell.lbl_serionNo.font = FONT_17;
        cell.lbl_name.font = FONT_17;
        cell.lbl_date.font = FONT_17;
        cell.lbl_desc.font = FONT_17;
    }
    
    cell.lbl_serionNo.textColor = COLOR_BLACK;
    cell.lbl_name.textColor = COLOR_BLACK;
    cell.lbl_date.textColor = COLOR_BLACK;
    cell.lbl_desc.textColor = COLOR_BLACK;
    
    cell.lbl_name.numberOfLines = 3;
    

    
    
    objNotes = (Notes *)[arrsearch objectAtIndex:indexPath.row];
    cell.lbl_serionNo.text = [NSString stringWithFormat:@"%d",objNotes.intNotesId];
    cell.lbl_name.text = [NSString stringWithFormat:@"%@",objNotes.strNoteTitle];
    cell.lbl_date.text = [NSString stringWithFormat:@"%@", objNotes.strCreatedDate];
    NSString *stringFromWS =[NSString stringWithString:objNotes.strCreatedDate];
    //date formatter for the above string
    NSDateFormatter *dateFormatterWS = [[NSDateFormatter alloc] init];
    [dateFormatterWS setDateFormat:@"MM-dd-yyyy"];
    NSDate *date =[dateFormatterWS dateFromString:stringFromWS];
    
    //date formatter that you want
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setDateFormat:@"dd-MM-yyyy"];
    
    NSString *stringForNewDate = [dateFormatterNew stringFromDate:date];
    
    cell.lbl_date.text = stringForNewDate;
    
    cell.lbl_desc.text = [NSString stringWithFormat:@"%@", objNotes.strNoteDesc];
    cell.lbl_desc.hidden = YES;
    //    if(currentOrientation == 2){
    //        NSLog(@"protrait");
    //        cell.imgview_cellpatch.image = [UIImage imageNamed:@"white_patch_with_line.png"];
    //    }
    //    else{
    //        NSLog(@"protrait");
    //        cell.imgview_cellpatch.image = [UIImage imageNamed:@"img_notelist_centerrow.png"];
    //    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    objNotes = (Notes *)[arrsearch objectAtIndex:indexPath.row];

    //Navigation Logic
    //[md Fn_SubNotesList];

    
    
    NSString *message;
    if(objNotes.intCategoryId == 1){
        //Flash Cards
        message = @"Flash Cards";
        categoryNumber = 1;

        intCurrentFlashcard_ChapterId = objNotes.intChapterId;
        
        Chapters *objChap = (Chapters *)[arr_chaptersTestAndFlashcard objectAtIndex:intCurrentFlashcard_ChapterId-1];
        str_BarTitle = [NSString stringWithFormat:@"Flash Cards - %@", objChap.strChapterTitle];
        
        if([UIScreen mainScreen].bounds.size.height == 568.0){
            flashCardsViewController = [[FlashCardsViewController alloc] initWithNibName:@"FlashCardsViewController_iPhone5" bundle:nil];
        }
        else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            flashCardsViewController = [[FlashCardsViewController alloc] initWithNibName:@"FlashCardsViewController_iPhone" bundle:nil];
        }
        else {
            flashCardsViewController = [[FlashCardsViewController alloc] initWithNibName:@"FlashCardsViewController_iPad" bundle:nil];
        }
        
        [self.navigationController pushViewController:flashCardsViewController animated:YES];
        
        
        [flashCardsViewController disableAllButtons:objNotes.intQuestionNo];
        
        
        
    }
    else if(objNotes.intCategoryId == 2){
        //Test Yourself
        message = @"Test Yourself";
        categoryNumber = 2;
        
        
        intCurrentTestYourSelf_ChapterId = objNotes.intChapterId;
        intCurrentTestYourSelf_ThematicId = -1;
        
        Chapters *objChap = (Chapters *)[arr_chaptersTestAndFlashcard objectAtIndex:objNotes.intChapterId-1];

        str_BarTitle = [NSString stringWithFormat:@"%@", objChap.strChapterTitle];
        strCurrentChapterName = [NSString stringWithFormat:@"%@", objChap.strChapterTitle];
        
        ThematicArea *objThematic;
        if(objNotes.intThematicId!=-1) {
            intCurrentTestYourSelf_ThematicId = objNotes.intThematicId;
            objThematic = (ThematicArea *)[objChap.thematicData objectAtIndex:objNotes.intThematicId - 1];        
            str_BarTitle = [NSString stringWithFormat:@"%@ - %@", objChap.strChapterTitle, objThematic.strThematicTitle];
            strCurrentThematicName = [NSString stringWithFormat:@"%@",  objThematic.strThematicTitle];
        
        }
        
        if([UIScreen mainScreen].bounds.size.height == 568.0){
            testYourSelfViewController = [[TestYourSelfViewController alloc] initWithNibName:@"TestYourSelfViewController_iPhone5" bundle:nil];
        }
        else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            testYourSelfViewController = [[TestYourSelfViewController alloc] initWithNibName:@"TestYourSelfViewController_iPhone" bundle:nil];
        }
        else {
            testYourSelfViewController = [[TestYourSelfViewController alloc] initWithNibName:@"TestYourSelfViewController_iPad" bundle:nil];
            
        }
        [self.navigationController pushViewController:testYourSelfViewController animated:YES];
        [testYourSelfViewController disableAllButtons:objNotes.intQuestionNo];
        
    }
    else if(objNotes.intCategoryId == 3){
        //Case Studies
        message = @"Case Studies";
        categoryNumber = 3;
        
        intCurrentCaseStudy_ChapterId = objNotes.intChapterId;
        intCurrentCaseStudy_ThematicId = -1;
        
        Chapters *objChap = (Chapters *)[arr_chaptersCaseStudy objectAtIndex:objNotes.intChapterId-40];
        
        str_BarTitle = [NSString stringWithFormat:@"%@", objChap.strChapterTitle];
        strCurrentChapterName = [NSString stringWithFormat:@"%@", objChap.strChapterTitle];
        
        ThematicArea *objThematic;
        if(objNotes.intThematicId!=0) {
            intCurrentCaseStudy_ThematicId = objNotes.intThematicId;
            objThematic = (ThematicArea *)[objChap.thematicData objectAtIndex:objNotes.intThematicId - 1];
            str_BarTitle = [NSString stringWithFormat:@"%@ - %@", objChap.strChapterTitle, objThematic.strThematicTitle];
            strCurrentThematicName = [NSString stringWithFormat:@"%@",  objThematic.strThematicTitle];
            
        }
        
        if([UIScreen mainScreen].bounds.size.height == 568.0){
            caseStudyViewController = [[CaseStudyViewController alloc] initWithNibName:@"CaseStudyViewController_iPhone5" bundle:nil];
        }
        else if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
            caseStudyViewController = [[CaseStudyViewController alloc] initWithNibName:@"CaseStudyViewController_iPhone" bundle:nil];
        }
        else {
            caseStudyViewController = [[CaseStudyViewController alloc] initWithNibName:@"CaseStudyViewController_iPad" bundle:nil];
        }
        
        [self.navigationController pushViewController:caseStudyViewController animated:YES];
        [caseStudyViewController disableAllButtons:objNotes.intQuestionNo];

    }
    else{
        //Nothing
        message = @"";
    }
    
    
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *data = txtSearch.text;
    // [db Fn_GetSearchList:data];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for(int i =0 ;i<[arrsearch count];i++)
    {
        objNotes = (Notes *)[arrNotes objectAtIndex:i];
        NSString *str11 = objNotes.strNoteDesc;
        NSLog(@"Str111 i%d  %@",i,objNotes.strNoteDesc);
        
        
        if ([str11 rangeOfString:data options:NSCaseInsensitiveSearch].location == NSNotFound)
        {
            NSLog(@"string does not contain data");
        }
        else {
            
            NSLog(@"string contains data!");
            NSLog(@"%@",objNotes.strNoteTitle);
            
            
            [arr addObject:objNotes];
            NSLog(@" Result %@",arr);
            
        }
    }
    arrNotes = arr;
    [tbl reloadData];
    
    arrNotes = arrsearch;
    return YES;
}
*/

-(void)textFieldDidBeginEditing:(UITextField *)sender{
    if(txtSearch.text.length > 0){
        txtSearch.autocorrectionType = UITextAutocorrectionTypeNo;
        [arrsearch removeAllObjects];
    }
    
  }
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if([txtSearch.text isEqualToString:@""]){
        [arrsearch removeAllObjects];
		[tbl reloadData];
		return YES;
	}

    [arrsearch removeAllObjects];
    for( int i= 0; i< [arrNotes count]; i++){
        objNotes = (Notes *)[arrNotes objectAtIndex:i];
        NSRange r = [[objNotes.strNoteDesc lowercaseString] rangeOfString:[txtSearch.text lowercaseString]];
        NSRange r1 = [[objNotes.strNoteTitle lowercaseString] rangeOfString:[txtSearch.text lowercaseString]];
        
        if(r.location != NSNotFound || r1.location != NSNotFound){
            [arrsearch addObject:objNotes];
        }
        
    }
    
	[tbl reloadData];

    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if([txtSearch.text isEqualToString:@""]){
        [arrsearch removeAllObjects];
        [arrsearch addObjectsFromArray:arrNotes];
		[tbl reloadData];
		return YES;
	}
    else{
    
    }

    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    //write code to be executed on tap of clear button

    [arrsearch removeAllObjects];
    [arrsearch addObjectsFromArray:arrNotes];
    [tbl reloadData];
    return YES;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        objNotes = (Notes *)[arrNotes objectAtIndex:indexPath.row];
        //int int_success = [db Fn_DeleteNotes:obj.int_note_id];
        
        [db Fn_DeleteNotes:objNotes.intNotesId];
        [arrNotes removeObjectAtIndex:indexPath.row];
        arrsearch=arrNotes;
        
        if([arrsearch count] > 0)
        {
            lbl_swipe.hidden=NO;
        }
        else
        {
            lbl_swipe.hidden=YES;
        }
        
        [tbl reloadData];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        return 25;
    }
    else {
        return 57;
    }
    return 0.0;
}




- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)
    {
        return NO;
    }
    
    if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        [self Fn_rotateLandscape];
        currentOrientation =1;
    }
    else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
		[self Fn_rotateLandscape];
        currentOrientation =1;
	}
	else if(interfaceOrientation==UIInterfaceOrientationPortrait){
		[self Fn_rotatePortrait];
        currentOrientation =2;
	}
	else {
        [self Fn_rotatePortrait];
        currentOrientation =2;
	}
    
	return YES;
}
- (void)Fn_rotatePortrait{
    
    
    [self.view setFrame:CGRectMake(0,0,768,1024)];
    
    [imgBG setImage:[UIImage imageNamed:@"img_bg_p.png"]];
    [imgBG setFrame:CGRectMake(0, 0, 768, 1024)];
    
    
    [imgPatch setImage:[UIImage imageNamed:@"Portrait_Note_BG_01.png"]];
    [imgPatch  setFrame:CGRectMake(0,0,768,1024)];

    
    
//    [lblTitle setFrame:CGRectMake(88,109, 683, 36)];
    [btnClose setFrame:CGRectMake(644,118,41,36)];
    [tbl setFrame:CGRectMake(35,246,682,433)];
    [lblTitleSerialNo setFrame:CGRectMake(55, 208, 61, 38)];
    [lblTitleName setFrame:CGRectMake(279, 208, 61, 38)];
    [lblTitleDescription setFrame:CGRectMake(495,208,104,38)];
    [lblTitleDate setFrame:CGRectMake(605,208,104,38)];
    [txtSearch setFrame:CGRectMake(110,171,583,30)];
    [lbl_swipe setFrame:CGRectMake(230, 860, 302, 21)];
    [tbl reloadData];
    //white_patch_with_line.png
}
- (void)Fn_rotateLandscape{
    
    [self.view setFrame:CGRectMake(0,0,1024,768)];
    
    [imgBG setImage:[UIImage imageNamed:@"img_bg.png"]];
    [imgBG setFrame:CGRectMake(0, 0, 1024, 768)];

    
    [imgPatch setImage:[UIImage imageNamed:@"landscape_Note_box_01.png"]];
    [imgPatch  setFrame:CGRectMake(0,-44,1024,768)];
    
//    [imgBG setImage:[UIImage imageNamed:@"img_notelist_bg.png"]];
//    [imgBG setFrame:CGRectMake(90, 58, 843, 633)];
    
//    [lblTitle setFrame:CGRectMake(170, 75, 683, 36)];
    [btnClose setFrame:CGRectMake(855,59,41,36)];
    [tbl setFrame:CGRectMake(87,194,822,433)];
    [lblTitleSerialNo setFrame:CGRectMake(106, 156, 61, 38)];
    [lblTitleName setFrame:CGRectMake(370, 156, 61, 38)];
    [lblTitleDescription setFrame:CGRectMake(650,156,104,38)];
    [lblTitleDate setFrame:CGRectMake(785,156,104,38)];
    [txtSearch setFrame:CGRectMake( 157,115,732,30)];
    [lbl_swipe setFrame:CGRectMake(361, 640, 302, 21)];
    [tbl reloadData];
}
@end

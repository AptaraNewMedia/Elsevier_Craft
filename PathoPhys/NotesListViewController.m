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

@interface NotesListViewController ()
{
    IBOutlet UIImageView *imgPatch;
//    IBOutlet UIImageView *imgBG;
//    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnClose;
    IBOutlet UITableView *tbl;
    
    IBOutlet UILabel *lblTitleSerialNo;
    IBOutlet UILabel *lblTitleName;
    IBOutlet UILabel *lblTitleDescription;
    IBOutlet UILabel *lblTitleDate;
    
    IBOutlet UITextField *txtSearch;
    
    NSMutableArray * arrNotes;
    Notes *objNotes;
    
    NSMutableArray *arrsearch;
    
    int currentOrientation;
    
    // 1- Landscape
    // 2- Portrait
}
@end

@implementation NotesListViewController

 
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
    arrNotes = [db fnGetNotesList];
    arrsearch = [[NSMutableArray alloc] init];
    arrsearch = arrNotes;
    
    
    txtSearch.delegate = self;

    txtSearch.font = FONT_17;
    txtSearch.textColor = COLOR_BLACK;
    
//    lblTitle.font = FONT_20;
//    lblTitle.textColor = COLOR_WHITE;

}
-(IBAction)onClose:(id)sender{
    [md Fn_SubNotesList];
}

// Tables
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrNotes.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"tblCellView";
    NotesCell *cell = (NotesCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil) {
        
        if (currentOrientation == 2) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"NotesCellP" owner:self options:nil];
            cell = [cellArray lastObject];
            
        }
        else  {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"NotesCell" owner:self options:nil];
            cell = [cellArray lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.lbl_serionNo.font = FONT_17;
    cell.lbl_name.font = FONT_17;
    cell.lbl_date.font = FONT_17;
    cell.lbl_desc.font = FONT_17;
    
    cell.lbl_serionNo.textColor = COLOR_BLACK;
    cell.lbl_name.textColor = COLOR_BLACK;
    cell.lbl_date.textColor = COLOR_BLACK;
    cell.lbl_desc.textColor = COLOR_BLACK;
    
    
    
    cell.lbl_name.numberOfLines = 3;

    
    objNotes = (Notes *)[arrNotes objectAtIndex:indexPath.row];
    cell.lbl_serionNo.text = [NSString stringWithFormat:@"%d",objNotes.intNotesId];
    cell.lbl_name.text = [NSString stringWithFormat:@"%@",objNotes.strNoteTitle];
    cell.lbl_date.text = [NSString stringWithFormat:@"%@", objNotes.strCreatedDate];
    cell.lbl_desc.text = [NSString stringWithFormat:@"%@", objNotes.strNoteDesc];
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

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        objNotes = (Notes *)[arrNotes objectAtIndex:indexPath.row];
        //int int_success = [db Fn_DeleteNotes:obj.int_note_id];
        
        [db Fn_DeleteNotes:objNotes.intNotesId];
        
        [arrNotes removeObjectAtIndex:indexPath.row];
        [tbl reloadData];
    }
}


- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
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
    
    [imgPatch setImage:[UIImage imageNamed:@"Portrait_Note_BG_01.png"]];
    [imgPatch  setFrame:CGRectMake(0,0,768,1024)];

    
//    [imgBG setImage:[UIImage imageNamed:@"P_Img _viewNote.png"]];
//    [imgBG setFrame:CGRectMake(40, 83, 697, 723)];
    
//    [lblTitle setFrame:CGRectMake(88,109, 683, 36)];
    [btnClose setFrame:CGRectMake(644,118,41,36)];
    [tbl setFrame:CGRectMake(35,246,682,433)];
    [lblTitleSerialNo setFrame:CGRectMake(55, 208, 61, 38)];
    [lblTitleName setFrame:CGRectMake(279, 208, 61, 38)];
    [lblTitleDescription setFrame:CGRectMake(495,208,104,38)];
    [lblTitleDate setFrame:CGRectMake(605,208,104,38)];
    [txtSearch setFrame:CGRectMake(110,171,583,30)];
    
    [tbl reloadData];
    //white_patch_with_line.png
}
- (void)Fn_rotateLandscape{
    
    [imgPatch setImage:[UIImage imageNamed:@"landscape_Note_box_01.png"]];
    [imgPatch  setFrame:CGRectMake(0,0,1024,768)];
    
//    [imgBG setImage:[UIImage imageNamed:@"img_notelist_bg.png"]];
//    [imgBG setFrame:CGRectMake(90, 58, 843, 633)];
    
//    [lblTitle setFrame:CGRectMake(170, 75, 683, 36)];
    [btnClose setFrame:CGRectMake(855,103,41,36)];
    [tbl setFrame:CGRectMake(87,238,822,433)];
    [lblTitleSerialNo setFrame:CGRectMake(106, 200, 61, 38)];
    [lblTitleName setFrame:CGRectMake(370, 200, 61, 38)];
    [lblTitleDescription setFrame:CGRectMake(650,200,104,38)];
    [lblTitleDate setFrame:CGRectMake(785,200,104,38)];
    [txtSearch setFrame:CGRectMake( 157,159,732,30)];
    [tbl reloadData];
}
@end

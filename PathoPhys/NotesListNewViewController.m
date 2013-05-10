//
//  NotesListNewViewController.m
//  PathoPhys
//
//  Created by Rohit Yermalkar on 10/05/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "NotesListNewViewController.h"

@interface NotesListNewViewController ()
-(IBAction)onClose:(id)sender;
@end

@implementation NotesListNewViewController

-(IBAction)onClose:(id)sender{
    [md Fn_SubNotesList1];
    [md Fn_AddMenu];
}

@end

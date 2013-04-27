//
//  ChapterlistCell_iPad.m
//  PathoPhys
//
//  Created by PUN-MAC-012 on 08/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "ChapterlistSubCell_iPad.h"

@implementation ChapterlistSubCell_iPad
@synthesize imgTableCellBG;
@synthesize lblThematicName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

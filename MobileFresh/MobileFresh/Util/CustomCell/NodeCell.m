//
//  NodeCell.m
//  MobileFresh
//
//  Created by ShaffiullaKhan on 18/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "NodeCell.h"

@implementation NodeCell
@synthesize isNodeSelected,title;//,nodeSwitch;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        isNodeSelected = NO;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

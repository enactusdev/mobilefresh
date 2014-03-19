//
//  NodeCell.m
//  MobileFresh
//
//  Created by ShaffiullaKhan on 18/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import "NodeCell.h"
#import "MobileFreshUtil.h"
@implementation NodeCell
@synthesize isNodeSelected,title,nodeSwitch;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        isNodeSelected = NO;
        
        nodeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 6, 51, 31)];
        title = [MobileFreshUtil labelWithFrame:CGRectMake(93, 11, 170, 21) title:@""];
        
        [nodeSwitch addTarget:delegate action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:nodeSwitch];
        [self.contentView addSubview:title];
//        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)updateSwitchAtIndexPath:(id)sender
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

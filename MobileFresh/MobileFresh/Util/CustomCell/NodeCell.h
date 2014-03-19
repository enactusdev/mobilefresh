//
//  NodeCell.h
//  MobileFresh
//
//  Created by ShaffiullaKhan on 18/03/14.
//  Copyright (c) 2014 Enactus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NodeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UISwitch *nodeSwitch;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, assign) BOOL isNodeSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate;
@end

//
//  PlayTableViewCell.m
//  ProstoPleer Music
//
//  Created by Mariya Dychko on 23.02.16.
//  Copyright © 2016 Simple Project. All rights reserved.
//

#import "PlayTableViewCell.h"

@implementation PlayTableViewCell
@synthesize label = _label;
@synthesize action = _action;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

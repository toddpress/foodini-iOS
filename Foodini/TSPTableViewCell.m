//
//  TSPTableViewCell.m
//  Foodini
//
//  Created by Todd Presley on 9/8/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import "TSPTableViewCell.h"

@implementation TSPTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

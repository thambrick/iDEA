//
//  tableViewCell.m
//  i-ShaRE
//
//  Created by Trey Hambrick on 5/4/13.
//  Copyright (c) 2013 Trey Hambrick. All rights reserved.
//

#import "tableViewCell.h"

@implementation tableViewCell

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

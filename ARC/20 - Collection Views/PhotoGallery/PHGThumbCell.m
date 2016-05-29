//
//  PHGThumbCell.m
//  PhotoGallery
//
//  Created by Joe Keeley on 6/9/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGThumbCell.h"

@implementation PHGThumbCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView.backgroundColor = [UIColor redColor];
    }
    return self;
}

@end

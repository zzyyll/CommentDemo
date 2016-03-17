//
//  CommentCell.m
//  XWDC
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 hcb. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageWidth)];

        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];

        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ImageWidth-15, 0, 25, 25)];
        [_cancelBtn setImage:[UIImage imageNamed:@"delete_the_picture"] forState:UIControlStateNormal];
//        _cancelBtn.tag = indexPath.row;
        
        [self addSubview:_cancelBtn];
    }

    return self;
}

@end

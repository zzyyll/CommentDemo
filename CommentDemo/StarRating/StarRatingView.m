//
//  StarRatingView.m
//  CommentTest
//
//  Created by 北京与车行信息技术有限公司 on 14-9-7.
//  Copyright (c) 2014年 北京与车行信息技术有限公司. All rights reserved.
//

#import "StarRatingView.h"

#define kImageCount     5

#define kImageSpace_B         4.0

#define kImageWidth_B         20.0
#define kImageHeight_B        20.0

#define kStarImageBlank_B     @"comment_star_gray_big"
#define kStarImageFull_B      @"comment_star_yellow_big"
#define kStarImageHalf_B      @"comment_star_yellow_half_big"

#define kImageSpace_S         0.0

#define kImageWidth_S         14.0
#define kImageHeight_S        14.0

#define kStarImageBlank_S     @"comment_star_gray"
#define kStarImageFull_S      @"comment_star_yellow"
#define kStarImageHalf_S      @"comment_star_yellow_half"

@interface StarRatingView ()

@end

@implementation StarRatingView
{
    StarType     _type;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:kImageCount type:StarTypeSmall];
}

- (id)initWithFrame:(CGRect)frame type:(StarType)type
{
    return [self initWithFrame:frame numberOfStar:kImageCount type:type];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number type:(StarType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _numberOfStar = number;
        _type = type;
        
        self.rate = 0;
        self.editable = YES;
        
        [self initSubviews];
    }
    return self;
}

+ (float)defaultWidth
{
    return 120;
}

- (void)initSubviews
{
    CGRect frame = self.bounds;
    
    float imageWidth,imageSpace;
    
    if (_type == StarTypeLargeNew) {
        imageWidth = 20;
        imageSpace = 15;
    } else {
        imageWidth = (_type == StarTypeSmall) ? kImageWidth_S : kImageWidth_B;
        imageSpace = (_type == StarTypeSmall) ? kImageSpace_S : kImageSpace_B;
    }
    
    for (int i = 0; i < _numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i * (imageWidth + imageSpace), 0, imageWidth, frame.size.height);
        imageView.tag = i + 1;
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        imageTap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:imageTap];
    }
}

- (void)setRate:(float)rate
{
    if (rate < 0) {
        rate = 0;
    }
    if (rate > _numberOfStar) {
        rate = _numberOfStar;
    }
    
    _rate = rate;
    
    for (int i = 0; i < _numberOfStar; i ++) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:i + 1];
        if (imageView.tag <= _rate) {
            if (_type == StarTypeLargeNew) {
                imageView.image = [self fullNewImage];
            } else {
                imageView.image = [self fullImage];
            }
        }
        else {
            if ((float)imageView.tag - _rate <= 0.5) {
                
                if (_type == StarTypeLargeNew) {
                    imageView.image = [self halfNewImage];
                } else {
                    imageView.image = [self halfImage];
                }
            }
            else {
                if (_type == StarTypeLargeNew) {
                    imageView.image = [self blankNewImage];
                } else {
                    imageView.image = [self blankImage];
                }
            }
        }
    }
}

- (UIImage *)fullImage
{
    return [UIImage imageNamed:(_type == StarTypeLarge) ? kStarImageFull_B : kStarImageFull_S];
}

- (UIImage *)halfImage
{
    return [UIImage imageNamed:(_type == StarTypeLarge) ? kStarImageHalf_B : kStarImageHalf_S];
}

- (UIImage *)blankImage
{
    return [UIImage imageNamed:(_type == StarTypeLarge) ? kStarImageBlank_B : kStarImageBlank_S];
}

- (UIImage *)halfNewImage
{
    return [UIImage imageNamed:@"comment_star_yellow_harf_bigbig"];
}

- (UIImage *)fullNewImage
{
    return [UIImage imageNamed:@"comment_star_yellow_bigbig"];
}

- (UIImage *)blankNewImage
{
    return [UIImage imageNamed:@"comment_star_gray_bigbig"];
}

- (void)setEditable:(BOOL)editable
{
    self.userInteractionEnabled = editable;
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    float tempRate = tap.view.tag;
    self.rate = tempRate;
    
    if ([self.delegate respondsToSelector:@selector(starRatingView:rateDidChange:)]) {
        [self.delegate starRatingView:self rateDidChange:self.rate];
    }
}

@end

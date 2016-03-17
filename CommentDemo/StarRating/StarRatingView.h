//
//  StarRatingView.h
//  CommentTest
//
//  Created by 北京与车行信息技术有限公司 on 14-9-7.
//  Copyright (c) 2014年 北京与车行信息技术有限公司. All rights reserved.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    StarTypeSmall,
    StarTypeLarge,
    StarTypeLargeNew,
} StarType;

@class StarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
- (void)starRatingView:(StarRatingView *)view rateDidChange:(float)rate;

@end

@interface StarRatingView : UIView

- (id)initWithFrame:(CGRect)frame type:(StarType)type;

+ (float)defaultWidth;

@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

@property (nonatomic) float rate;
@property (nonatomic) BOOL editable;            // default is YES

@end

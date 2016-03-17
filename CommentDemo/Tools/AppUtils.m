//
//  AppUtils.m
//  DefineControlView
//
//  Created by 韩占禀 on 14/12/21.
//  Copyright (c) 2014年 hzb. All rights reserved.
//

#import "AppUtils.h"

@implementation AppUtils

//加标签
#pragma mark -------------自定义弹框-------------
+(void)showAlert:(NSString *)_message //弹出框
{
    UIAlertView *promptAlert = [[UIAlertView alloc]initWithTitle:nil message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timerFireMethod:) userInfo:promptAlert repeats:YES];
    [promptAlert show];
}

+(void)timerFireMethod:(NSTimer *)theTimer //时间
{
    UIAlertView *promptAlert = (UIAlertView *)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}

#pragma mark ---------自定义消息提示框-------
+ (void)showTipWindow:(NSString *)str
{
    if (str.length<6) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-117)/2, (ScreenHeight-84)/2, 117, 84)];
        bgView.image = [UIImage imageNamed:@"弹窗"];
        bgView.hidden = NO;
        [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timerFire:) userInfo:bgView repeats:YES];
        
        UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(17, 17, 100, 67)];
        tipLab.text = str;
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.textColor = [UIColor whiteColor];
        tipLab.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:tipLab];
    } else {
        int fontValue = 16;
        if (str.length>8) {
            fontValue=15;
        }
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-176)/2, (ScreenHeight-126)/2, 176, 110)];
        bgView.image = [UIImage imageNamed:@"弹窗"];
        bgView.hidden = NO;
        [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timerFire:) userInfo:bgView repeats:YES];
        
        UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, 140, 88)];
        tipLab.text = str;
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.textColor = [UIColor whiteColor];
        tipLab.font = [UIFont systemFontOfSize:fontValue];
        //自动折行设置
        tipLab.lineBreakMode = UILineBreakModeWordWrap;
        tipLab.numberOfLines = 0;
        [bgView addSubview:tipLab];
    }
}

+ (void)showTipWindow:(UIImage *)bgImage andText:(NSString *)str
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-117)/2, (ScreenHeight-84)/2, 117, 84)];
    bgView.image = bgImage;
    bgView.hidden = NO;
    [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timerFire:) userInfo:bgView repeats:YES];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(17, 17, 100, 67)];
    tipLab.text = str;
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = [UIColor whiteColor];
    tipLab.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:tipLab];
}

+(void)timerFire:(NSTimer *)theTimer //时间
{
    UIImageView *bgView = (UIImageView *)[theTimer userInfo];
    bgView.hidden = YES;
}

#pragma mark -------------网页跳转-------------
+(void)jumpWebSite:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark -------------打电话-------------
+(void)callPhone:(NSString *)number
{
    NSString *phone = [NSString stringWithFormat:@"tel://%@",number];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:phone]];
}

#pragma mark -------------改变图片至指定大小-------------
+(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 根据文字内容、字体大小、行宽返回文本高度
+(CGFloat ) getTextHeight:(NSString *) text font:(UIFont *)font forWidth:(CGFloat) width  {
    if ( text == nil || font == nil || width <= 0) {
        return 0 ;
    }
    
    CGSize size;
    if (IsIOS7) {
        NSDictionary *attribute = @{NSFontAttributeName: font};
        size = [text boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil ].size ;
    }else{
        size = [text sizeWithFont: font forWidth:width lineBreakMode:NSLineBreakByClipping ] ;
    }
    return size.height ;
}

#pragma mark - 根据文字内容、字体大小、行宽返回文本尺寸
+(CGSize)boundingRectWithSize:(CGSize)size addLable:(UIFont *)font  andText:(NSString *)text {
    NSDictionary *attribute =font.fontDescriptor.fontAttributes;
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    
    return retSize;
}

#pragma mark - 根据内容改变内容某些字体的颜色
+ (NSMutableAttributedString *)getTextColor:(NSString *)string andRang:(NSRange )range andColor:(UIColor *)color
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    return str;
}

#pragma mark - 根据内容改变内容某些字体的大小
+ (NSMutableAttributedString *)getTextFont:(NSString *)string andRang:(NSRange )range andFont:(UIFont *)font {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    [str addAttribute:NSFontAttributeName value:font range:range];
    return str;
}

#pragma mark - 根据内容改变内容某些字体的大小以及颜色
+ (NSMutableAttributedString *)getTextFontColor:(NSString *)string andRang:(NSRange )range andFont:(UIFont *)font andColor:(UIColor *)color {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    [str addAttribute:NSFontAttributeName value:font range:range];
    return str;
}

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
#pragma mark - 截取指定大小的图片
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

#pragma mark - 图片按比例缩放,size是你要把图显示到 多大区域 CGSizeMake(300, 140)
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size {
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 图片指定宽度按比例缩放
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 压缩、裁剪图片
+ (UIImage *)cutImage:(UIImage*)image andSize:(CGSize)size
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (size.width / size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * size.height / size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * size.width / size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    
    return [UIImage imageWithCGImage:imageRef];
}

#pragma mark - 判断后台返回的字符串是否为空
+ (BOOL)isStringEmpty:(NSString *)str {
    if ([str isKindOfClass:[NSNull class]] || str.length==0 || [str isEqualToString:@"(null)"] || [str isEqualToString:@"<null>"]) {
        return YES;
    } else {
        return NO;
    }
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
}

/*!
 * @brief 把字典转换成格式化的JSON格式的字符串
 * @param dic 字典
 * @return 返回JSON格式的字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end

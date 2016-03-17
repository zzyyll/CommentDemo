//
//  commentVC.m
//  XWDC
//
//  Created by mac on 15/12/30.
//  Copyright © 2015年 hcb. All rights reserved.
//

#import "ViewController.h"
#import "StarRatingView.h"

#import "CommentCell.h"

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define MaxCount 9
#define Count 5  //一行最多放几张图片
#define ImageWidth ([UIScreen mainScreen].bounds.size.width-80)/Count

@interface ViewController ()
{
    UIButton        *sendBtn; //发送按钮

    UIView          *storeView; //店铺View
    UILabel         *storeName; //店铺名字
    StarRatingView  *ratingView; //星星评级

    UIView          *contentView; //评论内容View
    UITextView      *commentContent; //评论内容
    UILabel         *tip; //评论内容提示

    UIView          *addImgView; //评论图片View
    UIButton        *addImg; //中间添加图片按钮
    UICollectionView *collection; //存放图片的容器
    NSMutableArray  *imageArr; //存放图片数据源

    //有关点击头像弹出照相机还是本地图库的菜单
    UIActionSheet   *myActionSheet;
    BOOL cansend;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"评价";
    cansend = NO;

    imageArr = [NSMutableArray array];

    [self initView]; //初始化视图
    //隐藏键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
    [self.view addGestureRecognizer:tap];
}


#pragma mark - 初始化视图
- (void)initView {
    _shop_name = @"饭店评价的名字";
    //店铺View
    storeView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 50)];
    storeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:storeView];

    //店铺名称
    storeName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-30, 25)];
    storeName.text = _shop_name;
    storeName.font = [UIFont systemFontOfSize:15];
    storeName.textColor = [UIColor colorWithRed:0.2824 green:0.2863 blue:0.2902 alpha:1.0];
    [storeView addSubview:storeName];

    //总体评价
    NSString *scoreFlagStr = @"饭店总体评价：";
    CGSize nameSize = [scoreFlagStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    UILabel *scoreLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, nameSize.width, 25)];
    scoreLab.font = [UIFont systemFontOfSize:14];
    scoreLab.text = scoreFlagStr;
    scoreLab.textColor = [UIColor colorWithRed:0.2824 green:0.2863 blue:0.2902 alpha:1.0];
    [storeView addSubview:scoreLab];

    ratingView = [[StarRatingView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scoreLab.frame), 25, [StarRatingView defaultWidth], 25) type:StarTypeLarge];
    ratingView.rate = 5;
    [storeView addSubview:ratingView];

    /********************************/

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(storeView.frame)+9.5, ScreenWidth, 0.5)];
    line1.backgroundColor = [UIColor colorWithRed:0.7322 green:0.7322 blue:0.7322 alpha:1.0];
    [self.view addSubview:line1];

    //评论内容View
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(storeView.frame)+10, ScreenWidth, 130)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];

    //评论提示
    tip = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, ScreenWidth-20, 30)];
    tip.font = [UIFont systemFontOfSize:14];
    tip.textColor = [UIColor colorWithWhite:0.3563 alpha:1.0];
    tip.text = @"说点什么吧……";
    tip.userInteractionEnabled = NO;
    [contentView addSubview:tip];

    //评论内容
    commentContent = [[UITextView alloc] initWithFrame:CGRectMake(7, 5, ScreenWidth-20, 120)];
    commentContent.tintColor = [UIColor colorWithRed:0.9059 green:0.502 blue:0.0863 alpha:1.0];
    commentContent.font = [UIFont systemFontOfSize:14];
    commentContent.textColor = [UIColor blackColor];
    commentContent.delegate = self;
    commentContent.backgroundColor = [UIColor clearColor];
    [contentView addSubview:commentContent];

    /********************************/

    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame)+9.5, ScreenWidth, 0.5)];
    line1.backgroundColor = [UIColor colorWithRed:0.7902 green:0.7902 blue:0.7902 alpha:1.0];
    [self.view addSubview:line2];

    //评论图片View
    addImgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame)+10, ScreenWidth, ImageWidth+20)];
    addImgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addImgView];


    //    添加图片的按钮
    addImg = [UIButton buttonWithType:UIButtonTypeCustom];
    addImg.frame = CGRectMake(10, 10, ImageWidth, ImageWidth);
    [addImg setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    [addImg setBackgroundImage:[UIImage imageNamed:@"addImage_highlighted"] forState:UIControlStateSelected];
    [addImg addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [addImgView addSubview:addImg];

    //存放图片的UICollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addImg.frame)+10, 5, ScreenWidth-10-CGRectGetMaxX(addImg.frame), ImageWidth+10) collectionViewLayout:flowLayout];
    [collection registerClass:[CommentCell class] forCellWithReuseIdentifier:@"myCell"];
    [collection setAllowsMultipleSelection:YES];
    collection.showsHorizontalScrollIndicator = NO;
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor clearColor];
    [addImgView addSubview:collection];


    sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(addImgView.frame)+20, ScreenWidth-40, 35)];
    sendBtn.layer.cornerRadius = 8;
    sendBtn.layer.masksToBounds = YES;
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    sendBtn.backgroundColor = [UIColor colorWithRed:0.9598 green:0.5126 blue:0.143 alpha:1.0];
    [self.view addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    //    sendBtn.enabled = NO;

}





#pragma mark - 发送监听
- (void)send {
    [self hiddenKeyboard]; //隐藏键盘
    int rates = (int)ratingView.rate; //获取星级评级的等级
   NSString *content = [commentContent.text substringFromIndex:[self getTextBlankIndex]];
    if (content.length==0) {
        return;
    }

    NSLog(@"评论的星星的等级:%d 评论的内容%@",rates,content);
    //评论的图片数组  imageArr




    NSLog(@"开始处理图片的上传");

}


#pragma  mark - 处理评价内容的空格
- (NSInteger)getTextBlankIndex{
    NSString *strUrl = commentContent.text;
     NSInteger index = strUrl.length;
    for (int i = 0 ; i < strUrl.length; i ++) { //处理评价内容的空
        NSString *str = [strUrl substringWithRange:NSMakeRange(i, 1)];
        if (![str isEqualToString:@" "]) {
            index = i;
            break;
        }

    }
    return index;


}

#pragma mark - 添加图片监听
- (void)addImage {
    if (imageArr.count>=MaxCount) {
        //[BHUD showErrorMessage:@"亲，最多只能上传9张图片哦~~"];
    } else {
        [self hiddenKeyboard]; //隐藏键盘
        myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从本地图库获取", nil];
        [myActionSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0://打开照相机拍照
            [self takePhoto];
            break;
        case 1://打开本地相册
            [self LocalPhoto];
            break;
    }
}

#pragma mark - 打开照相机
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        ////NSLog(@"模拟器中无法使用照相机，请在真机中使用");
    }
}

#pragma mark - 打开本地图库
-(void)LocalPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = MaxCount-imageArr.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];

    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate【把选中的图片放到这里】
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type=[info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image=[info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        data=UIImageJPEGRepresentation(image, 0.5); //0.0最大压缩率  1.0最小压缩率
        //将获取到的图像image赋给UserImage，改变其头像
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *originalImage = [UIImage imageWithData:data];
        UIImage *handleImage;
        handleImage = originalImage;

        if (imageArr.count<MaxCount) {
            [imageArr addObject:data];
        }

        if (imageArr.count<MaxCount) {
        } else {
            addImg.hidden = YES; //最多上传6张图片
        }
        if (imageArr.count*(ImageWidth+10)>ScreenWidth+20) {

        }
        [collection reloadData];
    }

}

#pragma mark - 照片选取取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];

            NSData *data;
            data=UIImageJPEGRepresentation(tempImg, 0.0); //0.0最大压缩率  1.0最小压缩率
            UIImage *originalImage = [UIImage imageWithData:data];
            UIImage *scaleImage = [self imageWithImageSimple:[UIImage imageWithData:data] scaledToSize:CGSizeMake(originalImage.size.width*0.5, originalImage.size.height*0.5)];

            UIImage *handleImage;
            double diagonalLength = hypot(scaleImage.size.width, scaleImage.size.height); //对角线
            if (diagonalLength>917) {
                double i = diagonalLength/917;
                handleImage = [self cutImage:scaleImage andSize:CGSizeMake(scaleImage.size.width/i, scaleImage.size.height/i)];
            } else {
                handleImage = scaleImage;
            }

            if (imageArr.count<MaxCount) {
                [imageArr addObject:data];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            if (imageArr.count<MaxCount) {
            } else {
                addImg.hidden = YES; //最多上传9张图片
            }

            [collection reloadData];
        });

    });
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ImageWidth, ImageWidth);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"myCell";
    CommentCell *cell = (CommentCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.imageView.image = [UIImage imageWithData:imageArr[indexPath.row]];
    cell.cancelBtn.tag = indexPath.row;
    [cell.cancelBtn addTarget:self action:@selector(cancelImg:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 取消选择的图片
- (void)cancelImg:(UIButton *)btn {
    CommentCell *cell = (CommentCell *)btn.superview;
    NSIndexPath *indexPath = [collection indexPathForCell:cell];
    [imageArr removeObjectAtIndex:indexPath.row];
    if (imageArr.count<MaxCount) {
        addImg.hidden = NO;
        //添加图片的按钮在第一行
        [collection reloadData];
    } else {
        addImg.hidden = YES; //最多上传6张图片
    }

}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;

}

#pragma mark - UITextViewDelegate代理
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        tip.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if (![text isEqualToString:@""]) {
        tip.hidden = YES;
    }

    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        tip.hidden = NO;
    }

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

#pragma mark - 隐藏键盘
- (void)hiddenKeyboard {
    [self.view endEditing:YES]; //结束编辑设置
}

#pragma mark - 压缩、裁剪图片
- (UIImage *)cutImage:(UIImage*)image andSize:(CGSize)size
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


- (void)viewWillAppear:(BOOL)animated{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.9451 green:0.5686 blue:0.1725 alpha:1.0]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.9451 green:0.5686 blue:0.1725 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

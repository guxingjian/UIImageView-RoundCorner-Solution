
#import "HECornerImageMaker.h"
#import "HECornerImageCacher.h"
#import <objc/runtime.h>

@implementation HECornerImageMaker

+ (HECornerImageMaker *)imageMaker
{
    static HECornerImageMaker* maker;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        maker = [[self alloc] init];
    });
    
    return maker;
}

- (UIImage*)drawMaskImage:(CGFloat)cR viewSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rt = CGRectMake(0, 0, size.width, size.height);
    //
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    UIColor* colorCorner = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    CGContextSetFillColorWithColor(context, colorCorner.CGColor);
    
    CGMutablePathRef pathCorner = CGPathCreateMutable();
    
    // left top
    CGPathMoveToPoint(pathCorner, &transform, cR, 0);
    CGPathAddLineToPoint(pathCorner, &transform, 0, 0);
    CGPathAddLineToPoint(pathCorner, &transform, 0, cR);
    CGPathAddArc(pathCorner, &transform, cR, cR, cR, M_PI, M_PI + M_PI_2, NO);
    
    // left bottom
    CGPathMoveToPoint(pathCorner, &transform, 0, rt.size.height - cR);
    CGPathAddLineToPoint(pathCorner, &transform, 0, rt.size.height);
    CGPathAddLineToPoint(pathCorner, &transform, cR, rt.size.height);
    CGPathAddArc(pathCorner, &transform, cR, rt.size.height - cR, cR, M_PI_2, M_PI, NO);
    
    // right bottom
    CGPathMoveToPoint(pathCorner, &transform, rt.size.width - cR, rt.size.height);
    CGPathAddLineToPoint(pathCorner, &transform, rt.size.width, rt.size.height);
    CGPathAddLineToPoint(pathCorner, &transform, rt.size.width, rt.size.height - cR);
    CGPathAddArc(pathCorner, &transform, rt.size.width - cR, rt.size.height - cR, cR, 0, M_PI_2, NO);
    
    // right top
    CGPathMoveToPoint(pathCorner, &transform, rt.size.width, cR);
    CGPathAddLineToPoint(pathCorner, &transform, rt.size.width, 0);
    CGPathAddLineToPoint(pathCorner, &transform, rt.size.width - cR, 0);
    CGPathAddArc(pathCorner, &transform, rt.size.width - cR, cR, cR, M_PI_2*3, M_PI_2*4, NO);
    
    CGContextAddPath(context, pathCorner);
    CGContextFillPath(context);
    
    // 中间图片区域
    
    UIColor* colorCircle = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    CGContextSetFillColorWithColor(context, colorCircle.CGColor);
    
    CGMutablePathRef pathCircle = CGPathCreateMutable();
    CGPathMoveToPoint(pathCircle, &transform, cR, 0);
    
    CGPathAddArcToPoint(pathCircle, &transform, 0, 0, 0, rt.size.height - cR, cR);
    CGPathAddArcToPoint(pathCircle, &transform, 0, rt.size.height, rt.size.width - cR, rt.size.height, cR);
    CGPathAddArcToPoint(pathCircle, &transform, rt.size.width, rt.size.height, rt.size.width, cR, cR);
    CGPathAddArcToPoint(pathCircle, &transform, rt.size.width, 0, cR, 0, cR);
    
    CGContextAddPath(context, pathCircle);
    CGContextFillPath(context);
    
    UIImage* maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return maskImage;
}

- (void)makeCornerImageWithImage:(UIImage*)origImage cR:(CGFloat)cr viewSize:(CGSize)size contentMode:(UIViewContentMode)contentMode completely:(CornerImageComplete)block
{
    UIImage* maskImage = nil;
    if(cr <= size.width/2 && cr <= size.height/2)
        maskImage = [[HECornerImageCacher maskImageCacher] maskImageWithCR:cr andSize:size];
    
    if(!maskImage)
    {
        maskImage = [self drawMaskImage:cr viewSize:size];
        [[HECornerImageCacher maskImageCacher] storeMaskImageWith:maskImage cR:cr andSize:size];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rt = CGRectMake(0, 0, size.width, size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -size.height);
    
    CGContextDrawImage(context, rt, origImage.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
    CGContextDrawImage(context, rt, maskImage.CGImage);
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    block(image);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    UIGraphicsEndImageContext();

    extern const char* imageCacheKey;
    NSString* strKey = objc_getAssociatedObject(origImage, imageCacheKey);
    [[HECornerImageCacher maskImageCacher] storeOrigImage:image name:strKey cR:cr andSize:size contentMode:contentMode];
}

@end

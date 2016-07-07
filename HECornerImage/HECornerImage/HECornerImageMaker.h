
#import <UIKit/UIKit.h>

typedef void (^CornerImageComplete)(UIImage* origImage);

@interface HECornerImageMaker : NSObject

+ (HECornerImageMaker*)imageMaker;

- (void)makeCornerImageWithImage:(UIImage*)origImage cR:(CGFloat)cr viewSize:(CGSize)size contentMode:(UIViewContentMode)contentMode completely:(CornerImageComplete)block;

@end

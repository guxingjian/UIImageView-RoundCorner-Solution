
#import "HECornerImageCacher.h"

static const NSUInteger maxCost = 1024*1024*5;

@implementation HECornerImageCacher
{
    NSCache* _maskImageCache;
}

+ (HECornerImageCacher *)maskImageCacher
{
    static HECornerImageCacher* cacher;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacher = [[self alloc] init];
    });
    
    return cacher;
}

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _maskImageCache = [[NSCache alloc] init];
        _maskImageCache.totalCostLimit = maxCost;
        
        [[NSNotificationCenter defaultCenter] addObserver:_maskImageCache selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

- (NSString*)cacheKeyWithCR:(CGFloat)cr andSize:(CGSize)size
{
    return [NSString stringWithFormat:@"%@_%f", NSStringFromCGSize(size), cr];
}

- (UIImage*)originalImage:(NSString *)name cR:(CGFloat)cr andSize:(CGSize)size contentMode:(UIViewContentMode)mode
{
    return [_maskImageCache objectForKey:[NSString stringWithFormat:@"%ld_%@_%@", mode, name, [self cacheKeyWithCR:cr andSize:size]]];
}

- (void)storeOrigImage:(UIImage *)image name:(NSString *)name cR:(CGFloat)cr andSize:(CGSize)size contentMode:(UIViewContentMode)mode
{
    [_maskImageCache setObject:image forKey:[NSString stringWithFormat:@"%ld_%@_%@", mode, name, [self cacheKeyWithCR:cr andSize:size]] cost:image.size.width*image.size.height];
}

- (UIImage *)maskImageWithCR:(CGFloat)cr andSize:(CGSize)size
{
    return [_maskImageCache objectForKey:[self cacheKeyWithCR:cr andSize:size]];
}

- (void)storeMaskImageWith:(UIImage *)image cR:(CGFloat)cr andSize:(CGSize)size
{
    [_maskImageCache setObject:image forKey:[self cacheKeyWithCR:cr andSize:size] cost:image.size.width*image.size.height];
}

@end

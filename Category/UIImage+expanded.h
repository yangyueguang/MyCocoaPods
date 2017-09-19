
#import <UIKit/UIKit.h>

@interface UIImage (expanded)

- (UIImage *)imageAtRect:(CGRect)rect;

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)fixOrientation;

- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect;
- (UIImage *) imageWithWaterText:(NSString*)text inRect:(CGRect)rect;

- (UIImage *)croppedImage:(CGRect)bounds;
//- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
//          transparentBorder:(NSUInteger)borderSize
//               cornerRadius:(NSUInteger)cornerRadius
//       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

-(UIImage*)rotate:(UIImageOrientation)orient;
- (UIImage*)resizeImageWithNewSize:(CGSize)newSize;
+(UIImage *)imageName:(NSString *)name;
/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;
/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizableImageWithName:(NSString *)imageName;
/// 获取屏幕截图
///
/// @return 屏幕截图图像
+ (UIImage *)scott_screenShot;


/**
 *  生成一张高斯模糊的图片
 *
 *  @param image 原图
 *  @param blur  模糊程度 (0~1)
 *
 *  @return 高斯模糊图片
 */
+ (UIImage *)scott_blurImage:(UIImage *)image blur:(CGFloat)blur;
///图片灰色
- (UIImage *)grayImage;
@end

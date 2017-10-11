
#import "UIImage+expanded.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <Accelerate/Accelerate.h>
CGFloat DegreesToRadians_afd(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees_afd(CGFloat radians) {return radians * 180/M_PI;};
static int16_t gaussianblur_kernel[25] = {1, 4, 6, 4, 1,4, 16, 24, 16, 4,6, 24, 36, 24, 6,4, 16, 24, 16, 4,1, 4, 6, 4, 1};
#define basePicPath @"http://www.baidu.com/"
@implementation UIImage (expanded)
// 画水印
- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        UIGraphicsBeginImageContextWithOptions([self size], NO, 1.0); // 0.0 for scale means "scale for device's main screen".
    }
    //原图
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //水印图
    [mask drawInRect:rect];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}
// 画水印
- (UIImage *) imageWithWaterText:(NSString*)text inRect:(CGRect)rect{
    CGSize size = self.size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 1.0); // 0.0 for scale means "scale for device's main screen".
    }
    //原图
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //水印文字
    [[UIColor whiteColor] setFill];
    [text drawInRect:rect withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:MAX(size.width/32, 10)],NSFontAttributeName, nil]];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}
-(UIImage *)imageAtRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    return subImage;
}
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    return newImage ;
}
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    return newImage ;
}
- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    return newImage ;
}
- (UIImage *)imageRotatedByRadians:(CGFloat)radians{
    return [self imageRotatedByDegrees:RadiansToDegrees_afd(radians)];
}
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians_afd(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    //[rotatedViewBox release];
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians_afd(degrees));
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)fixOrientation {
    // No-op ifthe orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch ((NSInteger)self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    switch ((NSInteger)self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
static CGRect swapWidthAndHeight(CGRect rect){
    CGFloat  swap = rect.size.width;
    rect.size.width  = rect.size.height;
    rect.size.height = swap;
    return rect;
}
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
        default:
            drawTransposed = NO;
    }
    return [self resizedImage:newSize transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}
// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (long)contentMode];
    }
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    return [self resizedImage:newSize interpolationQuality:quality];
}
- (UIImage*)resizeImageWithNewSize:(CGSize)newSize{
	CGFloat newWidth = newSize.width;
	CGFloat newHeight = newSize.height;
    // Resize image if needed.
    float width  = self.size.width;
    float height = self.size.height;
    // fail safe
    if (width == 0 || height == 0)
		return self;
    if (width != newWidth || height != newHeight) {
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
		
        UIImage *resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //NSData *jpeg = UIImageJPEGRepresentation(image, 0.8);
        return resized;
    }
    return self;
}
- (UIImage *)resizedImage:(CGSize)newSize transform:(CGAffineTransform)transform drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,newRect.size.width,newRect.size.height,CGImageGetBitsPerComponent(imageRef),0,
                                                CGImageGetColorSpace(imageRef),CGImageGetBitmapInfo(imageRef));
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    return newImage;
}
// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}
#pragma clang diagnostic pop
-(UIImage*)rotate:(UIImageOrientation)orient{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGImageRef         imag = self.CGImage;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    bnds = rect;
    switch (orient){
        case UIImageOrientationUp:
			// would get you an exact copy of the original
			assert(false);
			return nil;
        case UIImageOrientationUpMirrored:
			tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			break;
        case UIImageOrientationDown:
			tran = CGAffineTransformMakeTranslation(rect.size.width, rect.size.height);
			tran = CGAffineTransformRotate(tran, M_PI);
			break;
        case UIImageOrientationDownMirrored:
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
			tran = CGAffineTransformScale(tran, 1.0, -1.0);
			break;
        case UIImageOrientationLeft:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
			break;
			
        case UIImageOrientationLeftMirrored:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(rect.size.height,
													rect.size.width);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
			break;
			
        case UIImageOrientationRight:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
			break;
			
        case UIImageOrientationRightMirrored:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeScale(-1.0, 1.0);
			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
			break;
			
        default:
			// orientation value supplied is invalid
			assert(false);
			return nil;
    }
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    switch (orient){
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
			CGContextScaleCTM(ctxt, -1.0, 1.0);
			CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
			break;
        default:
			CGContextScaleCTM(ctxt, 1.0, -1.0);
			CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
			break;
    }
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return copy;
}
+ (UIImage *)resizedImage:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.8];
}
+(UIImage *)imageName:(NSString *)name{
    NSString *path = [name lastPathComponent];
    return [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:nil]];
}
+ (UIImage *)resizableImageWithName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    // 获取原有图片的宽高的一半
    CGFloat w = image.size.width * 0.5;
    CGFloat h = image.size.height * 0.5;
    // 生成可以拉伸指定位置的图片
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    return newImage;
}
/// 获取屏幕截图
+ (UIImage *)scott_screenShot {
    // 1. 获取到窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 2. 开始上下文
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, 0);
    // 3. 将 window 中的内容绘制输出到当前上下文
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
    // 4. 获取图片
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    // 5. 关闭上下文
    UIGraphicsEndImageContext();
    return screenShot;
}

+ (UIImage *)scott_blurImage:(UIImage *)image blur:(CGFloat)blur {
    // 模糊度越界
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    if(!image)return image;
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *CGImageGetHeight(img));
    if(pixelBuffer == NULL){
        NSLog(@"No pixelbuffer");
    }
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,outBuffer.width,outBuffer.height,8,outBuffer.rowBytes,colorSpace,kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}
- (UIImage *)grayImage:(UIImage *)sourceImage{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

- (UIImage *)grayImage{
    int bitmapInfo = kCGImageAlphaNone;
    int width = self.size.width;
    int height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), self.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}
//截取部分图像
-(UIImage*)subImageAtRect:(CGRect)rect{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    // 设置图片旋转方向
    //    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef scale:1.0f orientation:self.imageOrientation];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}
//等比例缩放
-(UIImage*)imageScaledToSize:(CGSize)size{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1){
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }else{
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    width = width*radio;
    height = height*radio;
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
- (UIImage *)imageScaledToWidth:(CGFloat)value{
    //    NSLog(@"self.size=%f, %f", self.size.width , self.size.height);
    return [self imageScaledToSize: CGSizeMake(value, self.size.height * value / self.size.width)];
}
- (UIImage *)imageScaledToHeight:(CGFloat)value{
    return [self imageScaledToSize: CGSizeMake(self.size.width * value / self.size.height, value)];
}
// 指定大小的图片显示，高度超出的截取指定高度，宽度超出的截取指定宽度
- (UIImage *)imageScaledToSizeEx:(CGSize)size{
    CGSize imageSize = self.size;
    CGFloat height  =  imageSize.width * size.height / size.width;
    CGFloat width  =  imageSize.height * size.width / size.height;
    if (height < imageSize.height){
        CGFloat originY = (imageSize.height - height)/2;
        return [self subImageAtRect:CGRectMake(0, (originY > 50) ? 50 : originY, imageSize.width, height)];
    }else if (width < imageSize.width){
        CGFloat originX = (imageSize.width - width)/2;
        //DEBUGLOG(@"width == %f ==== %f", width, imageSize.width);
        return [self subImageAtRect:CGRectMake(originX, 0, width, imageSize.height)];
    }
    return self;
}
- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur{
    //get size
    CGSize border = CGSizeMake(fabs(offset.width) + blur, fabs(offset.height) + blur);
    CGSize size = CGSizeMake(self.size.width + border.width * 2.0f, self.size.height + border.height * 2.0f);
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //set up shadow
    CGContextSetShadowWithColor(context, offset, blur, color.CGColor);
    //draw with shadow
    [self drawAtPoint:CGPointMake(border.width, border.height)];
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //return image
    return image;
}

- (UIImage *)imageWithCornerRadius:(CGFloat)radius{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //clip image
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, radius);
    CGContextAddLineToPoint(context, 0.0f, self.size.height - radius);
    CGContextAddArc(context, radius, self.size.height - radius, radius, M_PI, M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, self.size.width - radius, self.size.height);
    CGContextAddArc(context, self.size.width - radius, self.size.height - radius, radius, M_PI / 2.0f, 0.0f, 1);
    CGContextAddLineToPoint(context, self.size.width, radius);
    CGContextAddArc(context, self.size.width - radius, radius, radius, 0.0f, -M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, radius, 0.0f);
    CGContextAddArc(context, radius, radius, radius, -M_PI / 2.0f, M_PI, 1);
    CGContextClip(context);
    //draw image
    [self drawAtPoint:CGPointZero];
    //captureresultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //return image
    return image;
}
//高斯图像处理
- (UIImage *)gaussianBlur{
    const size_t width = self.size.width;
    const size_t height = self.size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(space);
    if (!bmContext)return nil;
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data){
        CGContextRelease(bmContext);
        return nil;
    }
    const size_t n = sizeof(UInt8) * width * height * 4;
    void* outt = malloc(n);
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {outt, height, width, bytesPerRow};
    
    vImageConvolve_ARGB8888(&src, &dest, NULL, 0, 0, gaussianblur_kernel, 5, 5, 256, NULL, kvImageCopyInPlace);
    memcpy(data, outt, n);
    free(outt);
    CGImageRef blurredImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* blurred = [UIImage imageWithCGImage:blurredImageRef];
    CGImageRelease(blurredImageRef);
    CGContextRelease(bmContext);
    return blurred;
}
- (CGFloat)resizableHeightWithFixedwidth:(CGFloat)width{
    return  (width * [self size].height)/[self size].width;
}
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}
-(UIImage*)getGrayImage:(UIImage*)sourceImage{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGBitmapByteOrder16Little);
    CGColorSpaceRelease(colorSpace);
    if (context != NULL) {
        CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
        CGImageRef cgImageRef = CGBitmapContextCreateImage(context);
        UIImage *grayImage = [UIImage imageWithCGImage:cgImageRef];
        CGContextRelease(context);
        CGImageRelease(cgImageRef);
        return grayImage;
    }
    return nil;
}
+ (UIImage *) getLaunchImage {
    UIImage *image = nil;
    int screenWidth = (int)[[UIScreen mainScreen] currentMode].size.width;
    int screenHeight = (int)[[UIScreen mainScreen] currentMode].size.height;
    if (screenWidth == 640 && screenHeight == 1136) {
        image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }else if (screenWidth == 320 && screenHeight == 480) {
        image = [UIImage imageNamed:@"Default.png"];
    }else if (screenWidth == 640 && screenHeight == 960) {
        image = [UIImage imageNamed:@"Default@2x.png"];
    }else if (screenWidth == 750 && screenHeight == 1334) {
        image = [UIImage imageNamed:@"LaunchImage-800-667h@2x.png"];
    }else if (screenWidth == 1242 && screenHeight == 2208) {
        image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x.png"];
    }else if (screenWidth == 2208 && screenHeight == 1242) {
        image = [UIImage imageNamed:@"LaunchImage-800-Landscape-736h@3x.png"];
    }else if (screenWidth == 2048 && screenHeight == 1536) {
        image = [UIImage imageNamed:@"Default-Landscape@2x~ipad.png"];
    }else if (screenWidth == 1024 && screenHeight == 768) {
        image = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
    }else if (screenWidth == 1536 && screenHeight == 2048) {
        image = [UIImage imageNamed:@"Default-Portrait@2x~ipad.png"];
    }else if (screenWidth == 768 && screenHeight == 1024) {
        image = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
    }
    if (!image) {
        image = [UIImage imageNamed:@"LaunchImage"];
    }
    return image;
}
+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
- (UIImage *)scalingToSize:(CGSize)size{
    CGFloat scale = 0.0f;
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    CGFloat width = size.width;
    CGFloat height = size.height;
    if (CGSizeEqualToSize(self.size, size) == NO) {
        CGFloat widthFactor = size.width / self.size.width;
        CGFloat heightFactor = size.height / self.size.height;
        scale = (widthFactor > heightFactor ? widthFactor : heightFactor);
        width  = self.size.width * scale;
        height = self.size.height * scale;
        y = (size.height - height) * 0.5;
        x = (size.width - width) * 0.5;
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(x, y, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil) {
        NSLog(@"绘制指定大小的图片失败");
        return self;
    }
    return newImage ;
}
+(instancetype)imageWithRenderingOriginalName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    //取消按钮图片的默认渲染效果
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
#pragma mark 加载全屏的图片
+(UIImage *)fullScreenImage:(NSString *)imageName{
    //1.如果是iPhone5，对文件名特殊处理
    //加载图片
    return [self imageNamed:imageName];
}
#pragma mark 可以自由拉伸不会变形的图片
+ (UIImage *)resizedImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}
+ (instancetype)imageWithStretchableName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}
+ (instancetype)resizableWithImageName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}
- (CGRect) getRectWithSize:(CGSize) size {
    CGFloat widthRatio = size.width / self.size.width;
    CGFloat heightRatio = size.height / self.size.height;
    CGFloat scale = MIN(widthRatio, heightRatio);
    CGFloat width = scale * self.size.width;
    CGFloat height = scale * self.size.height;
    return CGRectMake((size.width - width) / 2, (size.height - height) / 2, width, height);
}
@end

//
//  CameraServer.h
//  Encoder Demo
//
//  Created by Geraint Davies on 19/02/2013.
//  Copyright (c) 2013 GDCL http://www.gdcl.co.uk/license.htm
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "UCloudGPUImage.h"

typedef NS_ENUM(NSInteger, UCloudCameraCode)
{
    UCloudCamera_COMPLETED =0,
    UCloudCamera_FILE_SIZE = 1,
    UCloudCamera_FILE_DURATION = 2,
    UCloudCamera_CUR_POS = 3,
    UCloudCamera_CUR_TIME = 4,
    UCloudCamera_URL_ERROR = 5,
    UCloudCamera_OUT_FAIL = 6,
    
    UCloudCamera_STARTED = 7,//推流开始
    UCloudCamera_READ_AUD_ERROR = 8,
    UCloudCamera_READ_VID_ERROR = 9,
    UCloudCamera_OUTPUT_ERROR = 10,//推流错误
    UCloudCamera_STOPPED = 11,//推流停止
    UCloudCamera_READ_AUD_EOS = 12,
    UCloudCamera_READ_VID_EOS = 13,
    UCloudCamera_BUFFER_OVERFLOW = 14,//推流带宽
    
    UCloudCamera_SecretkeyNil = 15,//密钥为空
    UCloudCamera_DomainNil = 16,//推流路径不正确
    UCloudCamera_AuthFail = 17,//鉴权失败
    UCloudCamera_ServerIpError = 18,//鉴权返回IP列表为空
    
    UCloudCamera_PreviewOK = 19,//预览视图准备好
    UCloudCamera_PublishOk = 20,//底层推流配置完毕
    UCloudCamera_StartPublish = 21,//
    UCloudCamera_DigError = 22,//dig失败
    UCloudCamera_Permission = 998,  //摄像头权限
    UCloudCamera_Micphone = 999,    //麦克风权限
};

typedef NS_ENUM(NSInteger, UCloudCameraState)
{
    UCloudCameraCode_Off,//关闭
    UCloudCameraCode_On,//打开
    UCloudCameraCode_Auto,//自动
};

#pragma mark Notifications

#ifdef __cplusplus
#define UCLOUD_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define UCLOUD_EXTERN extern __attribute__((visibility ("default")))
#endif

/**
 *  推流出错，重新推流
 */
UCLOUD_EXTERN NSString *const UCloudNeedRestart;

#pragma mark - block
//推流状态回掉闭包
typedef void(^CameraMessage)(UCloudCameraCode code, NSInteger arg1, NSInteger arg2, id data);
//相机回调
typedef void(^CameraDevice)(AVCaptureDevice *dev);
//

typedef CMSampleBufferRef (^CameraData)(CMSampleBufferRef buffer);

#pragma mark -
@interface CameraServer : NSObject
/**
 *  视屏宽
 */
@property (assign, nonatomic) int width;
/**
 *  视屏高
 */
@property (assign, nonatomic) int height;
/**
 *  帧率(15\25\30)
 */
@property (assign, nonatomic) int fps;
/**
 *  比特率(4.04 11.4)
 */
@property (assign, nonatomic) float bitrate;
/**
 *  鉴权密钥
 */
@property (strong, nonatomic) NSString *secretkey;
/**
 *  是否支持滤镜(iphpne5以上才能支持)
 */
@property (assign, nonatomic) BOOL supportFilter;
/**
 *  默认打开的摄像头
 */
@property (assign, nonatomic) AVCaptureDevicePosition capteureDevicePos;

/**
 *  是否静音，默认NO
 */
@property (nonatomic, assign) BOOL muted;

/**
 *  单例
 */
+ (CameraServer*) server;

/**
 *  配置参数(不会自动开始要在底层配置完成之后调用cameraStart)
 *
 *  @param outPutUrl   推流地址
 *  @param filters     滤镜
 *  @param block       推流状态回调
 *  @param deviceBlock 相机回掉(定制相机参数)
 *  @param cameraData  视频数据
 */
- (void)configureCameraWithOutputUrl:(NSString *)outPutUrl filter:(NSArray *)filters messageCallBack:(CameraMessage)block deviceBlock:(CameraDevice)deviceBlock cameraData:(CameraData)cameraData;

/**
 *  执行此方法先打开摄像头预览，不进行推流上传
 */
- (void)cameraPrepare;

/**
 *  开始录像上传
 *
 *  @return 操作结果
 */
- (BOOL)cameraStart;

/**
 *  关闭录像停止推流
 */
- (void)shutdown:(void(^)(void))completion;

- (UCloudGPUImageView *)createBlurringScreenshot;

/**
 *  获取采集图像
 *
 *  @return 采集图像
 */
- (UIView*)getCameraView;

/**
 *  切换摄像头
 */
- (void)changeCamera;

/**
 *  码率
 *
 *  @return 码率
 */
- (NSString *)biteRate;

/**
 *  设置闪光灯状态
 *
 *  @param state 状态
 *
 *  @return 设置是否成功
 */
- (BOOL)setFlashState:(UCloudCameraState)state;

/**
 *  设置手电筒状态
 *
 *  @param state 状态
 *
 *  @return 设置是否成功
 */
- (BOOL)setTorchState:(UCloudCameraState)state;
/**
 *  获取当前摄像头的位置
 *
 *  @return 摄像头位置
 */
- (AVCaptureDevicePosition)currentCapturePosition;
/**
 *  iPhone5以下的机型
 *
 *  @return 是否是iPhone5以下的机型
 */
- (BOOL)lowThan5;
/**
 *  调整摄像头ISO
 *
 *  @param value value
 *
 *  @return 操作结果(value越界和8一下系统返回no)
 */
- (BOOL)changeISO:(float)value;

/**
 *  添加滤镜
 *
 *  @param filters 滤镜数组
 */
- (void)addFilters:(NSArray *)filters;

/**
 *  打开美颜功能
 */
- (void)openFilter;

/**
 *  关闭美颜功能
 */
- (void)closeFilter;

@end
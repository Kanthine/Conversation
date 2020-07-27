//
//  GravityInduction.h
//  objective_c_language
//
//  Created by 苏沫离 on 2018/5/31.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface GravityInduction : NSObject

@property(nonatomic,strong)CMMotionManager *manager;

/**
 *  时间间隔
 */
@property (nonatomic,assign) float timeInterval;

/**
 *  单例创建方法
 *
 *  @return 单例
 */
+ (GravityInduction *)sharedGravity;

/**
 *  开始重力加速度
 *
 *  @param completeBlock 重力加速度block，返回xyz
 */
-(void)startAccelerometerUpdatesBlock:(void(^)(float x,float y,float z))completeBlock;

/**
 *  开始重力感应
 *
 *  @param completeBlock 重力感应block，返回xyz
 */
-(void)startGyroUpdatesBlock:(void(^)(float x,float y,float z))completeBlock;

/**
 *  开始陀螺仪
 *
 *  @param completeBlock 陀螺仪block，返回xyz
 */
-(void)startDeviceMotionUpdatesBlock:(void(^)(float x,float y,float z))completeBlock;

/**
 *  停止
 */
-(void)stop;


@end

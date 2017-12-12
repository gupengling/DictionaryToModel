//
//  NSObject+GPLDicToModel.h
//  OCDicToModel
//
//  Created by GPL on 2017/11/7.
//  Copyright © 2017年 GPL. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GPLModelDicOther <NSObject>

@optional
/**
 数组中类型

 @return key属性名，value数组中的存储类型
 */
+ (NSDictionary *)gpl_objectClassKeyInArray;


/**
 替换的字段

 @return key模型中的字段，value 字典中的字段
 */
+ (NSDictionary *)gpl_propertyReplacedKeyWithValue;

@end
@interface NSObject (GPLDicToModel) <GPLModelDicOther>

/**
 字典转模型

 @param dic 原数据字典
 @return 转换后的模型
 */
+ (instancetype)gpl_initWithDictionary:(NSDictionary *)dic;


/**
 数组字典转模型

 @param arr 原数据数组
 @return 转换后的模型
 */
+ (instancetype)gpl_initWithArray:(NSArray *)arr;

@end

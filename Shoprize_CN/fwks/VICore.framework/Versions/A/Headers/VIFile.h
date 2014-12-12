//
//  SandboxFile.h
//
//  Sand Box foundation Class

#import <Foundation/Foundation.h>

/**
 *    沙盒的相关操作信息
 *    @author 黄显宏
 */
@interface VIFile : NSObject

/**
 *    获取程序的Home目录路径
 *    @returns 获取根目录
 */
+ (NSString *)getHomeDirectoryPath;

/**
 *    获取document目录路径
 *    @returns 获取Document
 */
+ (NSString *)getDocumentPath;

/**
 *    获取Cache目录路径
 *    @returns 获取的Cache的路径
 */
+ (NSString *)getCachePath;

/**
 *    获取Library目录路径
 *    @returns 获得Library的路径
 */
+ (NSString *)getLibraryPath;

/**
 *    获取Tmp目录路径
 *    @returns 获得Tmp的路径
 */
+ (NSString *)getTmpPath;

/**
 * 获取Document子目录的路径
 */
+ (NSString *)getDirectoryForDocuments:(NSString *)dir;

/**
 *    创建目录文件夹
 *    @param List 创建一个目录文件
 *    @param Name 文件名字
 *    @returns 整个文件所在的路径
 */
+ (NSString *)createList:(NSString *)list listName:(NSString *)Name;

/**
 *    写入NsArray文件
 *    @param ArrarObject Array数据对象
 *    @param path 路径
 *    @returns 成功与否
 */
+ (BOOL)writeFileArray:(NSArray *)arrarObject specifiedFile:(NSString *)path;

/**
 *    写入NSDictionary文件
 *    @param DictionaryObject 数据对象
 *    @param path 路径信息
 *    @returns YES 写入成功
 */
+ (BOOL)writeFileDictionary:(NSMutableDictionary *)dictionaryObject specifiedFile:(NSString *)path;

/**
 *    是否存在该文件
 *    @param filepath 文件路径
 *    @returns 存在则返回 YES
 */
+ (BOOL)isFileExists:(NSString *)filepath;

/**
 *    删除指定文件
 *    @param filepath 文件的路径
 */
+ (void)deleteFile:(NSString *)filepath;

/**
 *    删除 document/dir 目录下 所有文件
 *    @param dir 目录
 */
+ (void)deleteAllForDocumentsDir:(NSString *)dir;

/**
 *    获取目录列表里所有的文件名
 *    @param path 文件路径
 *    @returns 返回文件夹下的所有路径
 */
+ (NSArray *)getSubpathsAtPath:(NSString *)path;

/**
 *    直接取文件数据
 *    @param name 资源的名字
 *    @param type 类型
 *    @returns 返回NSData数据
 */
+ (NSData *)getDataForResource:(NSString *)name inDir:(NSString *)type;
+ (NSData *)getDataForDocuments:(NSString *)name inDir:(NSString *)dir;
+ (NSData *)getDataForPath:(NSString *)path;

/**
 *    获取文件路径
 *    @param filename 获得
 *    @returns 获得在Cache目录下的文件路径
 *    @param dir 所在的目录下
 */

+ (NSString *)getPathForCaches:(NSString *)filename;
+ (NSString *)getPathForCaches:(NSString *)filename inDir:(NSString *)dir;

/**
 *    获得文件名的路径
 *    @param filename 获得文件名+路径
 *    @param dir 文件夹
 *    @returns 返回全路径
 */
+ (NSString *)getPathForDocuments:(NSString *)filename;
+ (NSString *)getPathForDocuments:(NSString *)filename inDir:(NSString *)dir;


/**
 *    获得Resource的路径
 *    @param name 获得bundel下的所有文件
 *    @param dir 子目录
 *    @returns 返回文件的路径
 */
+ (NSString *)getPathForResource:(NSString *)name;
+ (NSString *)getPathForResource:(NSString *)name inDir:(NSString *)dir;


#pragma mark 沙盒文件操作

/*!
 * 新建一个文件
 * \param filename 文件名，重复的话直接覆盖
 */
+ (void)newFile:(NSString *)filename;

/*!
 * 新建一个文件,如果不存在的话
 * \param filename 文件名
 */
+ (void)newFileIfNotExist:(NSString *)filename;

/*!
 * 清空一个文件
 * \param filename 文件名，重复的话直接覆盖
 */
+ (void)clean:(NSString *)filename;

/*!
 * 删除这个配置文件
 * \param filename 删除的文件名
 */
+ (void)deleteIt:(NSString *)filename;
/*!
 * 获取对应的值
 * \param filename 值的名字
 */
+ (id)IdValue:(NSString *)filename;

/*!
 * 添加一个键值对
 * \param key 键名
 * \param value 值
 * \param filename 文件名
 */
+ (void)addKey:(NSString *)key value:(id)value filename:(NSString *)filename;

/*!
 * 添加一个键值对
 * \param dict 对应的键值对
 * \param filename 文件名
 */
+ (void)addEntity:(NSDictionary *)dict filename:(NSString *)filename;

/*!
 * 删除一个键值对
 * \param key 对应的键
 * \param filename 文件名
 */
+ (void)removeFor:(NSString *)key filename:(NSString *)filename;

/*!
 * 删除一个键值对
 * \param filename 对应的键
 * \param ... 参数名字
 */
+ (void)removeFileName:(NSString *)filename keys:(NSArray *)waitDel;


@end


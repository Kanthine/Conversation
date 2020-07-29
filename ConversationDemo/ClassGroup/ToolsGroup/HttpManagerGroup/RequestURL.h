//
//  RequestURL.h
//  objective_c_language
//
//  Created by 龙 on 2018/5/22.
//  Copyright © 2018年 longlong. All rights reserved.
//

#ifndef RequestURL_h

#define RequestURL_h


#define PostTimeOutInterval 15.0f  //post网络请求时间
#define UploadTimeOutInterval 40.0f  //文件上传网络请求时间

#define ITunes @"http://itunes.apple.com/cn/lookup?id=414478124"

#define DOMAINBASE @"http://route.51mypc.cn"
#define URL_Login @"api/user/login"
#define URL_Register @"api/user/reg"
#define URL_Update_Info @"api/user/update"


#define URL_Test @"fancy/test"
#define URL_Update_Header @"fancy/userService.do?method=updatePhoto"
#define URL_Load_Header @"fancy/userService.do?method=updatePhoto"
#define URL_File_List @"fancy/userService.do?method=getFileListOrFile"
#define URL_File_Upload @"fancy/userService.do?method=updateFile"
#define URL_File_Download @"fancy/userService.do?method=makeFolder&path="


#define URL_CityList @"fancy/tools/getCity"

#endif /* RequestURL_h */

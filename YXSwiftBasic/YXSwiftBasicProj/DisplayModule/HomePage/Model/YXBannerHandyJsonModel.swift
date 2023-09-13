//
//  YXBannerHandyJsonModel.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2023/4/19.
//

import Foundation

//MARK: - 基础模型
class YXBannerHandyJsonModel: HandyJSON {
    
    /**
     * 跳转id
     * 1：商品，2：福袋，3：搜索，4：分类，5/9：领券中心(二级页)/福利中心(一级页)，6：首页，7：直购商城，8：个人中心
     */
    var jumpType: Int?
    /** 显示的广告图 */
    var advertisementImgUrl: String!
    /** 显示的广告标题 */
    var title: String?
    /** h5跳转页 */
    var htmlUrl: String?
    /** 跳转数据 */
    var jumpValueObj: YXBannerHandyJsonJumpModel?
    
    required init() {}
}

//MARK: - 跳转数据模型
class YXBannerHandyJsonJumpModel: HandyJSON {
    
    /** 搜索关键字 */
    var value: String?
    /** 福袋id */
    var luckyBagId: String?
    /** 商品id */
    var shopId: String?
    /** 分类数据 */
    var classifyId: YXBannerHandyJsonJumpCategoryModel?
    /** 跳转外链链接 */
    var withinUrl: String?
    /** 跳转外链链接 */
    var externalUrl: String?
    /** 跳转文章链接 */
    var articleUrl: String?
    
    required init() {}
}

//MARK: - 分类数据模型
class YXBannerHandyJsonJumpCategoryModel: HandyJSON {

    /** 专题id */
    var themeId: String?
    /** 标题名 */
    var title: String?
    /** 专题名 */
    var themeTitle: String?
    /** 是否推荐 */
    var isRecommend: Bool?
    /** 类型 1:数字藏品，2:发售日历，3：内容精选，4：文章，5：合成，6：平台公告，7：热门活动 */
    var type: Int?
    
    required init() {}
}

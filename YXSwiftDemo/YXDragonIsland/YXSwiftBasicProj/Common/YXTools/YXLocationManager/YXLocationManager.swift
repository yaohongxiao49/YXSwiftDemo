//
//  YXLocationManager.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/5.
//

import UIKit
import CoreLocation

typealias cityNameBlock = (_ name: String) -> ()

class YXLocationManager: NSObject {
    
    /** 单例 */
    static let locationTool = YXLocationManager()
    
    var locationManager = CLLocationManager() //定位管理器
    var cityNameBlock : cityNameBlock?
    
    private override init() {}
    
    //MARK: - 定位相关
    /** 定位城市功能 */
    func locationManagerWithCity(city: @escaping cityNameBlock) {
        
        cityNameBlock = city
        //检测定位功能是否开启
        if CLLocationManager.locationServicesEnabled() {
            
            //定位，获取城市
            locationManager.delegate = self
            //设置定位精度
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //更新距离
            locationManager.distanceFilter = 100
            //发送授权申请
            locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                //允许使用定位服务的话，开启定位服务更新
                locationManager.startUpdatingLocation()
                NSLog("定位开始")
            }
        }
        else {
            NSLog("没有开启定位功能")
        }
    }

}

//MARK: - CLLocationManagerDelegate
extension YXLocationManager: CLLocationManagerDelegate {
    
    //MARK: - CLLocationManangerDelegate 定位改变执行，可以得到新位置、旧位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        //获取最新的坐标
        let currLocation:CLLocation = locations.last!
        self.reverseGeocoder(currentLocation: currLocation)
        
        NSLog("精度\(currLocation.coordinate.longitude), 纬度\(currLocation.coordinate.latitude)")
    }
    
    //MARK: - 反地理编码
    func reverseGeocoder(currentLocation: CLLocation) {
        
        let geocoder = CLGeocoder.init()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            
            if (error != nil) || placemarks?.count == 0 {
                NSLog(error.debugDescription)
            }
            else {
                let placemark: CLPlacemark = (placemarks?.first)!
                let street = placemark.thoroughfare!
                let city = placemark.subAdministrativeArea!
                let state = placemark.administrativeArea!
                let code = placemark.isoCountryCode!
                let country = placemark.country!
                
                print("street：\(street), city：\(city), state：\(state), code：\(code), country：\(country)")
                guard let tmpCityName = self.cityNameBlock else { return }
                tmpCityName(city)
            }
        }
    }
}

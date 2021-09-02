//
//  BasicDataFour.swift
//  YXSwiftDemo
//
//  Created by ios on 2021/9/2.
//
/**
 * 集合类型
 *
 * 数组
 * 集合
 * 字典
 */

import UIKit

class BasicDataFour: YXBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationView.titleLab.text = "集合类型"
        self.navigationView.backBtn.isHidden = false
        
        self.initArr()
        self.getArrDemo()
        self.initSetDemo()
    }

    //MARK:- 初始化数组
    func initArr() {
        
        //初始化
        var firstArr = [Int]()
        print("数组数量 == \(firstArr.count)")
        
        //创建多条重复数据数组
        let secondArr = Array.init(repeating: 0, count: 3)
        print("多条重复数据数组 == \(secondArr)")
        
        //拼接
        firstArr.append(1)
        firstArr += secondArr
        print("拼接数组 == \(firstArr)")
        
        //组合数组（需要元素为相同类型）
        let combinationArr = firstArr + secondArr
        print("组合数组 == \(combinationArr)")
        
        //字面量构建数组
        let literalArr: [String] = ["1", "2"]
        print("字面量数组 == \(literalArr)")
        
        //判断数组是否为空
        print("判断数组是否为空 == \(literalArr.isEmpty)")
    }
    
    //MARK:- 获取数组元素
    func getArrDemo() {
        
        var valueArr: [String] = ["a", "b", "c", "d"]
        
        //索引取值
        print("索引取值 \(valueArr[1])")
        print("索引取值 \(valueArr[1...2])")
        
        //替换数组
        valueArr[0] = "e"
        valueArr[1...2] = ["f", "g"]
        print("替换数组 \(valueArr)")
        
        //添加
        valueArr.insert("h", at: valueArr.endIndex)
        print("指定添加元素 \(valueArr)")
        
        //移除
        valueArr.remove(at: 2)
        valueArr.removeLast()
        valueArr.removeAll(where: {$0 == "e"})
        valueArr.removeAll { value in
            return value == "f"
        }
       
        print("移除元素后的数组 \(valueArr)")
        
        //遍历获取数组中所有元素
        for value in valueArr {
            print("遍历获取数组中所有元素 \(value)")
        }
        
        //遍历获取数组中的值和索引
        for (index, value) in valueArr.enumerated() {
            print("遍历获取数组中的值和索引 \(String(index)): \(value)")
        }
    }
    
    //MARK:- 集合
    func initSetDemo() {
        
        //初始指定元素为字符串的集合，也可以不指定var sets: Set = ["1", "2", "3"]
        var sets: Set<String> = ["1", "2", "3"]
        
        //插入值
        sets.insert("a")
        print("集合添加元素 \(sets)")
        
        //移除值
        sets.remove("2")
        print("集合移除元素 \(sets)")
        
        //判断是否包含某个元素
        print("集合中是否包含指定元素 \(sets.contains("1"))")
        
        //集合循环-有序
        for value in sets.sorted() {
            print("集合-有序 \(value)")
        }
        
        //交集、并集
        let oddDigits: Set = [1, 3, 5, 7, 9]
        let evenDigits: Set = [0, 2, 4, 6, 8]
        let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]
        
        //根据关系创建新集合
        print("根据两个集合的所有值创建一个新的集合 \(oddDigits.union(evenDigits).sorted())")
        print("根据两个集合的交集创建一个新的集合 \(oddDigits.intersection(evenDigits).sorted())")
        print("根据不在另一个集合中的值创建一个新的集合 \(oddDigits.subtracting(singleDigitPrimeNumbers).sorted())")
        print("根据两个集合不相交的值创建一个新的集合 \(oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted())")
        
        //判断集合关系
        print("判断一个集合中的所有值是否也被包含在另外一个集合中 \(oddDigits.isSubset(of: singleDigitPrimeNumbers))")
        print("判断一个集合是否包含另一个集合中所有的值 \(oddDigits.isSuperset(of: singleDigitPrimeNumbers))")
        print("判断两个集合是否不含有相同的值（是否没有交集） \(oddDigits.isDisjoint(with: singleDigitPrimeNumbers))")
    }
    
}

//
//  YXUserDefaults.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/4.
//

import Foundation
//MARK: - UserDefault
/** 填充以及获取 */
protocol UserDefaultsSettable {
    
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsSettable where defaultKeys.RawValue == String {
    
    static func set<T>(value: T, forKey key: defaultKeys) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    /** 整形 */
    static func int(forKey key: defaultKeys) -> Int? {
        
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    /** 字符串 */
    static func string(forKey key: defaultKeys) -> String? {
        
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    /** 集合 */
    static func array(forKey key: defaultKeys) -> Array<Any>? {
        
        return UserDefaults.standard.array(forKey: key.rawValue)
    }
 
    //MARK: - 自定义对象遵守Codable协议
    /** 设置item */
    static func setItem<T: Encodable>(_ object: T, forKey key: defaultKeys) {
        
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        
        UserDefaults.standard.set(encoded, forKey: key.rawValue)
    }
    
    /** 获取item */
    static func getItem<T: Decodable>(_ type: T.Type, forKey key: defaultKeys) -> T? {
        
        guard let data = UserDefaults.standard.data(forKey: key.rawValue) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            print("Couldnt find key")
            return nil
        }
        
        return object
    }
    
}

//MAKR: - Sqlite
struct TableColumn {
    var cid: Int64?
    var name: String?
    var type: String?
    var notnul: Int64?
    var defaultValue: Any?
    var primaryKey: Int64?
}

class SqLiteManager {
    
    private var db: Connection?
    init(sqlPath: String) {
        db = try? Connection.init(sqlPath)
        db?.busyTimeout = 5.0
    }
}

//MARK: - Sql语句-表操作
extension SqLiteManager {
    
    /** 创建数据表 */
    func createTable(tableName: String, block: (TableBuilder) -> Void) -> Table? {
        
        do {
            let table = Table.init(tableName)
            try db?.run(table.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (builder) in
                
                block(builder)
            }))
            return table
        } catch (let error) {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    /** 移除数据表 */
    @discardableResult func deleteTable(tableName: String) -> Bool {
        
        let exeStr = "drop table if exists \(tableName)"
        do {
            try db?.execute(exeStr)
            return true
        } catch (let error) {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    
    /** 更新数据表(重命名) */
    @discardableResult func updateTable(oldName: String, newName: String) -> Bool {
        
        let exeStr = "alert table \(oldName) rename to \(newName)"
        do {
            try db?.execute(exeStr)
            return true
        } catch (let error) {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    
}

//MARK: - Sql语句-数据操作
extension SqLiteManager {
    
    /**
     * 给指定表增加列名及类型
     * - Parameters:
     *   - tableName: 表名
     *   - columnName: 列名
     *   - columnType: 列类型
     */
    @discardableResult func addColumn(tableName: String, columnName: String, columnType: String) -> Bool {
        
        let exeStr = "alert table \(tableName) add \(columnName) \(columnType)"
        do {
            try db?.execute(exeStr)
            return true
        } catch (let error) {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    
    /**
     * 检查指定列是否存在
     * - Parameters:
     *   - tableName: 表名
     *   - columnName: 列名
     */
    func checkColumnExist(tableName: String, columnName: String) -> Bool {
        
        return allColumns(tableName: tableName).filter { (model) -> Bool in
            
            return model.name == columnName
        }.count != 0
    }
    
    /**
     * 查询表所有列
     * - Parameter tableName: 表名
     * - Returns: TableBaseColum 这是基础枚举，具体使用时需要将TableBaseColum更改为自己具体是用的数据
     */
    func allColumns(tableName: String) -> [TableColumn] {
        
        let exeStr = "PRAGMA table_info([\(tableName)])"
        do {
            let stmt = try db?.prepare(exeStr)
            guard let result = stmt else {
                return []
            }
            var columns: [TableColumn] = []
            for case let row in result {
                guard row.count == columns.count else {
                    continue
                }
                let column = TableColumn.init(cid: row[0] as? Int64, name: row[1] as? String, type: row[2] as? String, notnul: row[3] as? Int64 ??  0, defaultValue: row[4], primaryKey: row[5]  as? Int64 ??  0)
                columns.append(column)
            }
            return columns
        } catch (let error) {
            debugPrint(error.localizedDescription)
            return []
        }
    }
}

//MARK: - Sql语句-增删改查
extension SqLiteManager {
    
    /**
     * 添加数据
     * - Parameters:
     *   - table: 表
     *   - setters: 添加输入，需要添加在create时初始的相应属性，如 [name <- "小红", isMan <- true]
     */
    @discardableResult func insert(table: Table?, setters: [Setter]) -> Bool {
        
        guard let tab = table else {
            return false
        }
        do {
            try db?.run(tab.insert(setters))
            return true
        } catch let error {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    
    /**
     * 移除数据
     * - Parameters:
     *   - table: 表
     *   - filter: 移除条件，如 name == "小红"
     */
    @discardableResult func delete(table: Table?, filter: Expression<Bool>? = nil) -> Bool {
        
        guard var filterTab = table else {
            return false
        }
        do {
            if let filterTmp = filter {
                filterTab = filterTab.filter(filterTmp)
            }
            try db?.run(filterTab.delete())
            return true
        } catch let error {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    
    /**
     * 更新数据
     * - Parameters:
     *   - table: 表
     *   - setters: 修改后的数据，如 [name <- "小明"]
     *   - filter: 需要修改的数据，如 name == "小红"
     */
    @discardableResult func update(table: Table?, setters: [Setter], filter: Expression<Bool>? = nil) -> Bool {
        
        guard var filterTab = table else {
            return false
        }
        do {
            if let filterTmp = filter {
                filterTab = filterTab.filter(filterTmp)
            }
            try db?.run(filterTab.update(setters))
            return true
        } catch let error {
            debugPrint(error.localizedDescription)
            return false
        }
    }

    /**
     * 查询数据
     * - Parameters:
     *   - table: 表
     *   - selected: 需要取出的数据，如 [id, name, isMan]
     *   - filter: 筛选条件，如 id >= 0
     *   - order: 可为空
     *   - limit: 可为空
     *   - offset: 可为空
     */
    @discardableResult func select(table: Table?, selected: [Expressible] = [], filter: Expression<Bool>? = nil, order: [Expressible] = [], limit: Int? = nil, offset: Int? = nil) -> [Row]? {
        
        guard var queryTab = table else {
            return nil
        }
        do {
            if selected.count != 0 {
                queryTab = queryTab.select(selected).order(order)
            }
            else {
                queryTab = queryTab.order(order)
            }
            
            if let filterTmp = filter {
                queryTab = queryTab.filter(filterTmp)
            }
            if let lim = limit {
                if let off = offset {
                    queryTab = queryTab.limit(lim, offset: off)
                }
                else {
                    queryTab = queryTab.limit(lim)
                }
            }
            guard let result = try db?.prepare(queryTab) else {
                return nil
            }
            return Array.init(result)
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
}

//
//  NetworkService.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//
import Alamofire
import Foundation

class KeywordSearchXMLService: BaseXMLService, XMLParserDelegate {
    static let shared = KeywordSearchXMLService()
    
    func fetch(about keyword: String) {
        guard let encodedString = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return }
        let urlString = baseUrl + language(.kr) + "/searchKeyword?ServiceKey=\(Key.encoding)&keyword=\(encodedString)&numOfRows=100&MobileOS=ETC&MobileApp=Lamp"
        
        guard
            let url = URL(string: urlString),
            let xmlParser = XMLParser(contentsOf: url)
        else { return }
        
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    private var currentElement = ""
    
    private var item: LocationItem?
    @Published private(set) var items = [LocationItem]()
    
    // XMLParserDelegate 함수
    // XML 파서가 시작 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        
        if currentElement == "item" {
            item = .init(areaCode: "", title: "", firstimage: "", addr1: "", addr2: "", mapx: 0, mapy: 0)
        }
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName == "item") {
            
            guard
                let item = item
            else { return }

            items.append(item)
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    public func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if (currentElement == "title") {
            item?.title = string
        } else if currentElement == "areacode" {
            item?.areaCode = string
        } else if (currentElement == "firstimage") {
            item?.firstimage = string
        } else if currentElement == "addr1" {
            item?.addr1 = string
        } else if currentElement == "addr2" {
            item?.addr2 = string
        } else if currentElement == "mapx" {
            item?.mapx = Int(string) ?? 0
        } else if currentElement == "mapy" {
            item?.mapy = Int(string) ?? 0
        }
    }
}

struct LocationItem: Decodable, Hashable {
    var uuid = UUID()
    var areaCode: String
    var title: String
    var firstimage: String
    var addr1: String
    var addr2: String
    var mapx: Int
    var mapy: Int
    
    var isFavorite: Bool?
    
    var score: Float?
    
    var allOrderScore: Int?
    var recommendingOrderScore: Int?
    var travelOrderScore: Int?
    var notVisitOrderScore: Int?
}

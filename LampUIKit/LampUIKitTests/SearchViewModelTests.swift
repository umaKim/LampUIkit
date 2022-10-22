//
//  SearchViewModelTests.swift
//  LampUIKitTests
//
//  Created by 김윤석 on 2022/10/20.
//

@testable import LampUIKit
import Quick
import Nimble
import Combine

class SearchViewModelTests: QuickSpec {
    override func spec() {
        var auth: MockAuthManager!
        var network: MockNetworkManager!
        var viewModel: SearchViewModel!
        
        let locations: RecommendedLocationResponse = .init(result: [.init(image: nil,
                                                                         contentId: "",
                                                                         contentTypeId: "",
                                                                         title: "",
                                                                         addr: "",
                                                                         rate: nil,
                                                                         bookMarkIdx: nil,
                                                                         isBookMarked: false,
                                                                         mapX: "",
                                                                         mapY: "",
                                                                         planIdx: nil,
                                                                         travelCompletedDate: nil)])
        
        func prepare() {
            auth = MockAuthManager()
            network = MockNetworkManager()
            network.recommendedLocationResponse = locations
            viewModel = SearchViewModel(auth, network)
        }
        
        describe("locations") {
            beforeEach {
                prepare()
                viewModel.setKeyword("강남")
                viewModel.fetchSearchKeywordData()
            }
            
            it("when fetchSearchKeywordData is called, should be locations.result") {
                expect(viewModel.locations).to(equal(locations.result))
            }
            
            it("when searchButtonDidTap is called, should be locations.result") {
                expect(viewModel.locations).to(equal(locations.result))
            }
            
            it("when save is called for certain index, locations[index].isBookMarked should be true") {
                let index = 0
                viewModel.save(index)
                expect(viewModel.locations[index].isBookMarked).to(beTrue())
            }
        }
    }
}

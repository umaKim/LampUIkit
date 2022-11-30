//
//  MainViewModelTests.swift
//  LampUIKitTests
//
//  Created by 김윤석 on 2022/10/20.
//

@testable import LampUIKit
import Quick
import Nimble
import Combine

class MainViewModelTests: QuickSpec {
    override func spec() {
        var auth: MockAuthManager!
        var network: MockNetworkManager!
        var viewModel: MainViewModel!
        
        func prepare() {
            auth = MockAuthManager()
            auth.setToken("token")
            network = MockNetworkManager()
            
            let userExistCheckResponse = UserExistCheckResponse(isSuccess: true, nicknameExist: true, userIdx: 0)
            
            network.userExistCheckResponse = userExistCheckResponse
            
            viewModel = MainViewModel(auth, network)
        }
        
        describe("zoom") {
            beforeEach {
                prepare()
            }
            
            it("'s initial value of has to be 15") {
                expect(viewModel.zoom).to(equal(15))
            }
            
            it(" has to be increased by 1,when zoomIn") {
                viewModel.zoomIn()
                expect(viewModel.zoom).to(equal(16))
            }
            
            it(" has to be decreased by 1, when zoomOut") {
                viewModel.zoomOut()
                expect(viewModel.zoom).to(equal(14))
            }
            
            it("has to be equal to value putting in setMyZoomLevel") {
                viewModel.setMyZoomLevel(20)
                expect(viewModel.zoom).to(equal(20))
            }
        }
        
        describe("coord") {
            prepare()
            
            viewModel.setMyLocation()
            expect(viewModel.coord).to(equal(Coord(latitude: 0, longitude: 0)))
            
            viewModel.setLocation(with: 10, 10)
            expect(viewModel.coord).to(equal(Coord(latitude: 10, longitude: 10)))
        }
        
        describe("myLocation") {
            prepare()
            
            viewModel.setMyLocation()
            expect(viewModel.myLocation).to(equal(Coord(latitude: 0, longitude: 0)))
            
            viewModel.setMyLocation(with: 10, 10)
            expect(viewModel.myLocation).to(equal(Coord(latitude: 10, longitude: 10)))
        }
        
        describe("fetchItems") {
            prepare()
            
            let recommendedLocation = RecommendedLocation(image: nil,
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
                                                          travelCompletedDate: nil)
            
            network.recommendedLocationResponse = .init(result: [recommendedLocation])
            
            viewModel.fetchItems()
            
            expect(viewModel.recommendedPlaces).to(equal([recommendedLocation]))
            expect(viewModel.markerType).to(equal(.recommended))
        }
        
        describe("fetchAllOver") {
            prepare()
            
            let recommendedLocation = RecommendedLocation(image: nil,
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
                                                          travelCompletedDate: nil)
            
            network.recommendedLocationResponse = .init(result: [recommendedLocation])
            
            viewModel.fetchAllOver()
            
            expect(viewModel.recommendedPlaces).to(equal([recommendedLocation]))
            expect(viewModel.markerType).to(equal(.recommended))
        }
        
        describe("fetchUnvisited") {
            prepare()
            
            let myTravelLocation = MyTravelLocation(image: nil,
                                                    planIdx: "",
                                                    contentId: "",
                                                    contentTypeId: "",
                                                    placeName: "",
                                                    placeInfo: "",
                                                    placeAddress: "",
                                                    userMemo: nil,
                                                    mapX: nil,
                                                    mapY: nil,
                                                    bookMarkIdx: "",
                                                    isBookMarked: false)
            
            let recommendedLocation = RecommendedLocation(image: nil,
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
                                                          travelCompletedDate: nil)
            
            network.myTravelLocations = [myTravelLocation]
            
            viewModel.fetchUnvisited()
            
            expect(viewModel.recommendedPlaces).to(equal([recommendedLocation]))
            expect(viewModel.markerType).to(equal(.destination))
        }
        
        describe("fetchCompleted") {
            prepare()
            
            let recommendedLocation = RecommendedLocation(image: nil,
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
                                                          travelCompletedDate: nil)
            
            network.recommendedLocationResponse = .init(result: [recommendedLocation])
            
            viewModel.fetchCompleted()
            
            expect(viewModel.recommendedPlaces).to(equal([recommendedLocation]))
            expect(viewModel.markerType).to(equal(.completed))
        }
        
        describe("fetchPlaces") {
            prepare()
            
            let recommendedLocation = RecommendedLocation(image: nil,
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
                                                          travelCompletedDate: nil)
            
            network.recommendedLocationResponse = .init(result: [recommendedLocation])
            
            viewModel.fetchPlaces(for: .art)
            
            expect(viewModel.recommendedPlaces).to(equal([recommendedLocation]))
            expect(viewModel.markerType).to(equal(.recommended))
        }
        
        describe("appendPlace") {
            prepare()
            
            let recommendedLocation = RecommendedLocation(image: nil,
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
                                                          travelCompletedDate: nil)
            
            viewModel.appendPlace(recommendedLocation)
            expect(viewModel.recommendedPlaces).to(equal([recommendedLocation]))
        }
    }
}

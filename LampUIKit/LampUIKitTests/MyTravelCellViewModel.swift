//
//  MyTravelCellViewModel.swift
//  LampUIKitTests
//
//  Created by 김윤석 on 2022/10/25.
//

@testable import LampUIKit
import Quick
import Nimble
import Combine

class MyTravelCellViewModelTests: QuickSpec {
    
    override func spec() {
        var auth: MockAuthManager!
        var network: MockNetworkManager!
        var viewModel: MyTravelCellViewModel!
        
        let models: [MyTravelLocation] = [.init(image: nil, planIdx: "", contentId: "", contentTypeId: "", placeName: "", placeInfo: "", placeAddress: "", userMemo: nil, mapX: nil, mapY: nil, bookMarkIdx: "", isBookMarked: false)]
        
        func prepare() {
            auth = MockAuthManager()
            auth.setToken("testToken")
            
            network = MockNetworkManager()
            network.myTravelLocations = models
            
            viewModel = MyTravelCellViewModel(auth, network)
        }
        
        describe("showDeleteButton") {
            beforeEach {
                prepare()
            }
            
            it("shoudl be true, when toggleShowDeleteButton is being called") {
                viewModel.toggleShowDeleteButton
                expect(viewModel.showDeleteButton).to(beTrue())
            }
        }
        
        describe("isRefreshing") {
            beforeEach {
                prepare()
            }
            
            it("should be true, when setIsRefreshing is true") {
                viewModel.setIsRefreshing = true
                expect(viewModel.isRefreshing).to(beTrue())
            }
            
            it("should be false, when setIsRefreshing is nil") {
                viewModel.setIsRefreshing = nil
                expect(viewModel.isRefreshing).to(beFalse())
            }
        }
        
        describe("models") {
            beforeEach {
                prepare()
            }
            
            it("should be equal to models, when fetchMyTravel is called") {
                viewModel.fetchMyTravel()
                expect(viewModel.models).to(equal(models))
            }
            
            it("should be empty, when deleteMyTravel is being called") {
                network.response = .init(isSuccess: true, message: nil)
                
                viewModel.fetchMyTravel()
                viewModel.deleteMyTravel(at: 0)
                expect(viewModel.models.isEmpty).to(beTrue())
            }
            
            it("should be empty, when completeTrip is being called") {
                network.response = .init(isSuccess: true, message: nil)
                
                viewModel.fetchMyTravel()
                viewModel.completeTrip(at: 0)
                expect(viewModel.models.isEmpty).to(beTrue())
            }
        }
    }
}

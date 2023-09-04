# LampUIkit
map based app 

## 📖 상세 내용

**Apple Store**

[https://apps.apple.com/kr/app/lamp-램프-여행-지도/id1641478631](https://apps.apple.com/kr/app/lamp-%EB%9E%A8%ED%94%84-%EC%97%AC%ED%96%89-%EC%A7%80%EB%8F%84/id1641478631)

**GitHub**

[https://github.com/umaKim/LampUIkit](https://github.com/umaKim/LampUIkit)

## **👥 Team Composition**

- 1 iOS Developer - Kim Yoonsuk (Uma Kim)
- 1 Backend Developer
- 1 Designer
- 1 Product Manager (Presenter)

## **🛠️ Technologies and Libraries Used**

- Swift, iOS
- Combine
- AutoLayout
- FloatingPanel
- SDWebImage
- GoogleMap SDK
- SkeletonView
- Lottie
- Alamofire
- CombineCocoa
- UmaBasicAlertKit
- Kakao SDK
- Quick, Nimble

## **📱 Features Implemented (iOS)**

- Implemented asynchronous processing to display map pins with animation in the order that the photos are loaded
- Utilized Combine framework for implementation
- Reduced code duplication and increased code reusability through modularization
- Implemented all UI and functionalities programmatically without using Storyboard
- Implemented animation for changes in cells using DiffableDataSource introduced in WWDC 19
- Used SDWebImage library for image caching to prevent performance degradation during image loading
- Implemented auto cell sizing based on content length for variable cell height and improved user experience
- Implemented localization support for English and Japanese languages
- Implemented language switching functionality within the app
- Wrote unit tests (in early stages, not fully completed)

## **👨‍🏭 Problem Encountered and Solution 1**

- Problem:
    
    When fetching and displaying approximately 30 locations on the map, the entire process takes about 10 seconds. During this time, the user is forced to view a loading screen, resulting in a poor user experience.
    
- Problem Analysis:
    
    To understand what happens during the loading screen, I listed the sequence of events:
    
    1. Fetch an array containing information and image links of 30 locations.
    2. Pass the information and image links of each element in the array to a map pin object.
    3. The object fetches the image using the provided image link, and once all images are fetched, it proceeds to the next location and performs the same operation.
    4. After completing this process for all 30 locations, the loading screen is removed, and the map with map pins is displayed to the user.
    
    The step that takes the most time is step 3, where images are fetched using URLs. This process is time-consuming because it waits for each image to be fully fetched before proceeding to the next one, blocking the main thread.
    
- Solution:
    
    Instead of waiting for all image data to be fetched, I implemented a solution where each image is displayed as soon as it is fetched. This gives the impression to the user that the map is being updated without any loading time.
    
    <Technical Solution>: Execute the **try**? Data(contentsOf: url) part asynchronously on a background thread, and once the image data is fetched, update the view on the main thread.
    

## **💁‍♂️ Problem Encountered and Solution 2**

- Problem:
    
    Following the existing approach, to implement fetching data from a new API, I had to repeatedly write similar code that was already written for other API calls.
    
- Desired Approach:
    
    Enable fetching of desired APIs by simply adding the endpoint, without having to write repetitive code.
    
- Solution:
    
    By using generics, I minimized the duplication of code. I actively utilized enums so that by simply adding the endpoint, the desired API could be used immediately.

## 👥 팀 구성

- iOS 개발자 1명 ← 김윤석
- 서버 개발자 1명
- 디자이너 1명
- 기획자(발표자) 1명

## 🛠️ 사용 기술 및 라이브러리

- Swift, iOS
- Combine
- AutoLayout
- FloatingPanel
- SDWebImage
- GoogleMap SDK
- SkeletonView
- Lottie
- Alamofire
- CombineCocoa
- UmaBasicAlertKit
- Kakao SDK
- Quick, Nimble

## 📱 담당한 기능 (iOS)

- 비동기 처리를 통해서 map pin들이 사진이 로딩 되는 순서로 애니메이션과 함께 화면에 보이게 함
- Combine을 사용해서 구현
- 모듈화를 통해서 코드의 양을 줄이고 코드 재활용성을 높임
- 모든 UI와 동작을 Storyboard없이 코드로만 구현
- WWDC 19에 소개됐던 DiffableDatasource를 적용해서 Cell에 생기는 변화에 대한 애니메이션 구현
- SD web image 라이브러리를 이용해서 image caching을 가능하게 해서 이미지 로딩시 발생할수 있는 앱의 퍼포먼스 저하를 방지
- 사용자가 작성한 글에 양에 따라 셀의 크기가 변할수 있게 auto cell sizing을 적용해서 ux를 향상
- 영어, 일본어 지원 Localization 구현
- 앱 내부에서 언어 바꾸기 기능 구현
- Unit test 작성 ( 완전히 끝내지는 않음 - 아직 초반 단계 )

## 👨‍🏭 발생된 문제와 해결 방법 1

- 문제:
    
    지도상에 등장하는 약 30개의 장소를 fetch하고 map pin으로 띄워주는 모든 동작이 완료할 때까지 로딩 화면을 띄워준다. 그런데 이 모든 과정이 완료되는 데에는 약 10초 정도 소요된다. 약 10초 동안 사용자는 로딩 화면만을 보고 있어야 한다. 이것은 사용자에게 불쾌한 경험을 준다.
    

- 문제 파악:
    
    문제파악을 위해 로딩화면이 띄워져 있는 동안 무슨일이 일어나는지 나열해 보았다.
    
    1. 장소의 정보와 이미지 링크가 30개 담겨있는 배열을 불러온다. → 2. 해당 배열에 있는 각 요소에 있는 정보들과 이미지 링크를 map pin 객체에 넘긴다. → 3. 객체는 받은 이미지 링크를 통해 이미지를 받아오고 다 받아 왔으면 다음 장소에 대한 데이터들을 가지고 다음 객체에서 같은 작업을 해준다. → 4. 3번 작업을 30번을 다 완료하고 나면 로딩 화면을 제거하고 사용자에게 map pin들이 올려져 있는 지도를 보여준다.
    2. 여기에서 가장 긴 시간이 소요되는 것은 3번 과정이다. 다른 과정과는 다르게 URL을 통해 이미지를 불러오는 과정이 오래 걸린다는 것을 파악했다. 이 과정에서 오래 걸리는 이유는 main thread에서 한 객체의 이미지가 다 불러올 때까지 기다렸다가 다음 이미지를 불러오는 식이어서 그렇다.
    
- 해결 방법:
    
    모든 image data가 받아 올때까지 기다리는 것이 아니라, 한 이미지가 받아 와졌으면 해당 이미지부터 먼저 화면에 띄워주는 방식으로 고쳐야 한다. 이런 식으로 고친다면 사용자 입장에서는 로딩 시간이 없이 지도가 업데이트되는 것 처럼 보이게 된다.
    
    <기술적 해결>: **try**? Data(contentsOf: url) 이 부분을 Background Thread에서 비동기로 실행시켜주고   image data가 받아와지면 그때 main thread에서 view로 업로드해준다.
    

## 💁‍♂️ 발생된 문제와 해결 방법 2

- 문제:
    
    기존에 원래하던 방식을 고집하자면, 새로운 API를 불러오는 것을 구현하기 위해서 기존에 다른 API 호출시에 작성해뒀던 함수와 매우 유사한 코드를 반복해서 작성해야한다.
    
- 원하는 방향:
    
    endpoint만 추가하면 바로 api를 원하는 곳에서 불러오게 하는것
    
- 해결 방법:
    
    generic을 이용해서 기존의 반복되는 코드를 최소화함. enum을 적극적으로 활용해서 endpoint만 추가하면  바로 원하는 api를 사용할수 있게했다.

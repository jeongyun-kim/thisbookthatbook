### 이책저책 
#### 어떤 책을 읽을까 고민될 때, 책을 추천하고 추천받을 수 있는 커뮤니티 앱

---

### ⭐️ 스크린샷
<table>
  <tr align="center" style="font-weight: bold;">
    <td>피드</td>
    <td>포스트 상세보기</td>
    <td>프로필</td>
    <td>검색</td>
    <td>결제 필요 포스트</td>
    <td>결제</td>
  </tr>
  <tr line-height:0 width="19%" height="300">
    <td><img src="https://github.com/user-attachments/assets/00868797-fa76-41ed-a66e-7bbbf619e0ce" width="120" height="300"></td>
    <td><img src="https://github.com/user-attachments/assets/9dc67c5d-de66-4a02-991c-04c07360d6f1" width="120" height="300"></td>
    <td><img src="https://github.com/user-attachments/assets/e01e43f8-197f-431d-a3ec-30a4e47db1dc" width="120" height="300"></td>
    <td><img src="https://github.com/user-attachments/assets/0701f0c1-58a5-402e-a7cd-80e3cfacccc2" width="120" height="300"></td>
    <td><img src="https://github.com/user-attachments/assets/d50a693d-f468-4a46-95e9-3378265667a9" width="120" height="300"></td>
    <td><img src="https://github.com/user-attachments/assets/ebb8b0c9-57ad-46ae-a107-69304a0a4a36" width="120" height="300"></td>
  </tr>
</table>

---

### ✅ 개발환경

- iOS16+
- 다국어 지원(한글/영어)
- 1인 개발 | 2024.08.15~08.31

---

### 👩🏼‍💻 주요 기술

- UI : UIKit, SnapKit, Kingfisher, Toast, Tabman, Pageboy, IQKeyboardManager
- Database : UserDefaults
- Network : Alamofire
- Reactive: RxSwift
- Design Pattern: Singletone, Router, Input-Output, MVVM
- etc: Iamport, NaverAPI

---

### 📚 주요 기능

- 포스트 좋아요 / 북마크
- 포스트 내 추천하는 책 추가
- 포스트 내 댓글 작성
- 사용자 팔로우
- 포스트 결제
- 해시태그를 통한 포스트 검색
- 사용자 프로필 조회 / 수정 / 회원탈퇴

---

### 🧐 개발 포인트
- API 과호출 방지를 위한 입력값에 대한 검증 후 통신
- API 과호출 방지를 위한 버튼 내 쓰로틀링 기법 적용
- 통신 실패 시, 적절한 피드백 제공을 위한 상태코드를 통한 에러 핸들링
- 다양한 사용자 경험을 위한 다국어 지원
- 토큰 갱신 시, 요청의 일관성을 위한 Alamofire의 requestInterceptor 활용
- 코드의 재사용성과 유지보수성을 위해 URLRequestConvertible 프로토콜을 채택한 TargetType을 활용 및 RouterPattern 구성 및 추상화
- 통신 결과, 성공 여부에 따른 분기 처리를 위한 Result Type 활용
- 코드의 재사용성과 유지보수성을 위해 Generic과 PropertyWrapper 활용하여 UserDefaults 내 데이터 저장 및 로드
- 메모리 사용 최적화를 위한 뷰 스택의 루트뷰 관리
- 메모리 릭 방지를 위한 Instruments-Leaks 활용
- 코드의 명확성과 재사용성을 고려한 MVVM 내 Input-Output Pattern 활용
- ViewModel의 구조 일관성과 유지보수성을 위한 프로토콜 활용
- 메모리 낭비 방지와 유지보수성를 위한 자주 사용되는 리소스 관리 구조 구축
- 코드의 재사용성과 일관성을 위한 BaseView 활용

---

### 🚨 트러블슈팅

**✓ 불필요한 API 호출 방지를 위한 Access Token 갱신 시 RequestInterceptor 활용**
<img src="https://github.com/user-attachments/assets/40db65b0-60a5-4fdb-bf6a-dc8279c22644" height="300"/>
    
**- 개요**
<br>
  서버와의 통신으로 419 상태코드가 날아오는 것은 Access Token이 만료된 상태로 Access Token을 Refresh Token을 통해 갱신시켜줘야 했습니다. 그리하여 처음에는 419 상태코드가 올 때마다 토큰을 갱신시켜주는 메서드를 포스트 Access Token 검증을 거치는 메서드 내에서 매번 실행해주고 다시 이전의 통신을 재개하려 하였습니다. <br>
<br>
**- 문제점**
<br>
  하지만 토큰의 검증이 필요한 통신이 생각보다 많았고 재귀함수를 이용하다보니 불필요한 서버 통신이 일어날 가능성도 배제할 수는 없었습니다. <br>
<br>
**- 해결**
<br>
그리하여 이러한 문제들을 해결하기 위해 Alamofire의 Interceptor를 이용해 우선적으로 현상태에서 서버와의 통신이 성공적인지 확인하고 만약 상태코드가 419가 날아왔을 때에는 Token을 갱신시켜주도록 했습니다. 만약 이 때에 Access Token 갱신에 실패한다면 Refresh Token마저 만료된 것으로 간주하여 해당 에러를 그대로 결과로 보내주도록 하여 사용자에게 재로그인이 필요함을 알려주도록 구현하였습니다. <br>
```swift
final class AuthInterceptor:  RequestInterceptor {
    private init() { }
    static let interceptor = AuthInterceptor()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        let ud = UserDefaultsManager.shared
        
        request.setValue(ud.accessToken, forHTTPHeaderField: API.Headers.auth)
    
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode, statusCode == 419 else {
            completion(.doNotRetry)
            return
        }

        NetworkService.shared.getRefreshToken { result in
            switch result {
            case .success(let value):
                UserDefaultsManager.shared.accessToken = value.accessToken
                completion(.retry)
            case .failure(let error):
                // 만약 상태코드가 419라 토큰 리프레시를 진행하려고 했는데, 에러가 발생했다면
                // refreshToken이 만료된 것 -> 로그인을 다시 해달라고 알려야 함 
                UserDefaultsManager.shared.deleteAllData()
                completion(.doNotRetryWithError(error))
            }
        }
    }
}

```
<br>

**✓ 서버의 이미지를 받아오기 위한 Kingfisher의 Modifier 활용**

**- 문제점** 
<br>
서버의 이미지 URL을 이용해 이미지를 받아올 때, 평소와 같이 URL을 이용하여 이미지를 받아오려 했으나 실패하였고, 이는 이미지 로드 시 AccessToken과 Key의 부재로 일어난 문제였습니다.
<br>

**- 해결** 
<br>
코드의 재사용성을 고려하여 Kingfisher의 Modifier를 구성하고 해당 Modifier를 통해 이미지를 받아오도록 하는 ImageFetcher를 Singletone으로 구현하였습니다.
```swift
final class ImageFetcher { 
  ...
  func getImagesFromServer(_ paths: [String], completionHandler: @escaping ((ImageData) -> Void)) {
     for (idx, value) in paths.enumerated() {
     guard let url = configureURL(value) else { return }
     let request = configureModifier()
     let data = ImageData(url: url, idx: idx, modifier: request)
     completionHandler(data)
     }
  }
  ... 
}
```
그리고 사용하는 곳에서는 completionHandler closure를 통해 이렇게 구성한 Modifier를 사용해주어 이미지를 로드하도록 하였습니다.
```swift
override func configureView(_ paths: [String]) {
    let imageViews = [thumbnailImageView1, thumbnailImageView2, thumbnailImageView3]
    // 이미지 받아와 Kingfisher의 Option 활용해 보여주기 
    ImageFetcher.shared.getImagesFromServer(paths) { data in
    guard let idx = data.idx else { return }
    imageViews[idx].kf.setImage(with: data.url, options: [.requestModifier(data.modifier)])
    }
}
```
<br>

**✓ 각 포스트 카테고리 스와이프 전환을 위한 Tabman, Pageboy 활용**

**- 개요** 
<br>
각 카테고리의 콘텐츠를 불러올 때, Tap 뿐만 아니라 Swipe 제스쳐를 포함하여 결과를 가지고 오고 싶었습니다
<br>

**- 1차 시도** 
<br>
CollectionView의 .visibleItemsInvalidationHandler를 이용하여 사용자가 CollectionView의 새로운 Cell로 이동하는 scrollOffset을 이용해 Segment Control 아래에 위치한 View를 이동시키도록 하였습니다.
<br>

**- 문제점** 
<br>
하지만 제가 원하는 결과물은 각 카테고리의 텍스트 길이의 intrinsic content size만큼 View의 길이가 다른 것이었고 이를 구현하는 것을 현시점에서는 어렵다고 판단하게 되었습니다.
<br>
```swift
 section.visibleItemsInvalidationHandler = { visibleItems, scrollOffset, layoutEnvironment in
    let width: CGFloat = 75 // segment 아래 view의 길이
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 0.3초동안 뷰 이동
        let position = scrollOffset.x - width
        view.transform = CGAffineTransformMakeTranslation(position, 0)
    }
}
```

**- 2차 시도**
<br>
그리하여 TabMan 라이브러리를 이용하게 되었고 단순히 TabBar가 들어갈 View에 TabBar를 구성해 추가해주면 될 것이라고 생각한 채 구현했습니다.
<br>

**- 문제점**
<br>
하지만 중간에 위치한 TabBar의 위치와 관계없이 TabBar 내 ViewController들이 현재 보여지고 있는 ViewController의 모든 영역을 차지하는 것을 확인할 수 있었습니다.
<br>

**- 해결**
<br>
다양한 글을 통해 TabBar를 전적으로 관리하는 ViewController를 따로 생성하여 이를 원하는 위치에 추가해줘야함을 깨달았습니다. 그리하여 각 Tab을 관리하는 ViewController를 개별적으로 구성하여 TabBar를 넣어주고자 하는 ViewContoller에 child로 해당 ViewController를 불러와 레이아웃을 구성해주도록 하였습니다.
<br>       
```swift
// ProfileTabManViewController.swift 
// - TabBar 관리 ViewController
final class ProfileTabManViewController: TabmanViewController {
    private let bar = TabmanBar()
    
    private let viewControllers = [
        FilteredPostsViewController(vm: FilteredPostsViewModel(), dataType: .post),
        FilteredPostsViewController(vm: FilteredPostsViewModel(), dataType: .like),
        FilteredPostsViewController(vm: FilteredPostsViewModel(), dataType: .bookmark)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        addBar(bar, dataSource: self, at: .custom(view: self.view, layout: { bar in
            bar.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide)
                make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(24)
            }
        }))
    }
}
```
```swift
// - TabBar 사용
final class ProfileViewController: BaseViewController {
    ...
    private let child = ProfileTabManViewController()
    ...
    override func setupHierarchy() {
        addChild(child)
        view.addSubview(profileImageView)
        view.addSubview(editButton)
        view.addSubview(userInfoHorizontalStackView)
        view.addSubview(border)
        view.addSubview(child.view)
    }
    
    override func setupConstraints() {
        ...
        child.view.snp.makeConstraints { make in
            make.top.equalTo(border.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        ...
    }
```


---

### 👏 회고
**- MultipartForm Data에 대한 이해**
<br>
이번 프로젝트에서 포스트 업로드를 구현해보는 과정 속에서 MultipartForm Data 타입을 어떻게 서버에 업로드할 수 있는지 해당 과정을 이해할 수 있었습니다. 더욱이 이미지(image/png)뿐만 아니라 프로필 수정 시, 사용자의 닉네임과 같은 (text/plain) 타입의 데이터를 함께 업로드해보며 MIME 타입의 구조와 서로 다른 MIME 타입을 아우르는 개념인 multipart에 대해서도 알게된 기회였던 것 같습니다.
<br>

**- ViewModel의 Input-Output Pattern**
<br>
이전에는 CustomObservable을 이용해 MVVM을 적용했다면 이번에는 RxSwift를 주축으로 MVVM을 구현하게 되면서 제대로 Input과 Output을 구분지을 수 있는 Input-Output Pattern을 사용해보았습니다. 그리고 같은 변수명이더라도 Input과 Output으로 나뉘기 때문에 이전에 비해 좀 더 명확히 데이터의 유형을 파악할 수 있었던 것 같습니다. 그렇다하여 해당 형태에 너무 집착하지 않고 패턴을 적용하기에 애매한 곳에서는 이전과 같이 ViewModel의 init()에서 데이터들을 처리하며 상황에 맞게 유동적으로 코드를 작성하려 하였습니다. 현재 포스트 상세정보 내 본문이 TableViewHeader로 구현되며 Rx없이 구현되고 있어 그러한 상황이 발생하고 있습니다. 이후에는 해당 View에 RxDatasource를 적용해보고 ViewModel 또한 Input-Output으로 코드를 개선해보고 싶습니다.
<br>

**- RxSwift의 methodInvoked**
<br>
대다수의 ViewModel이 viewWillAppear 시 서버로부터 데이터를 다시 받아오라는 신호를 받고 있습니다. 이를 Input으로 활용해보고자 viewWillAppear 자체를 Rx의 ControlEvent로 변환해주는 methodInvoked를 사용하였습니다. 하지만 이에대한 완전한 이해가 되지 않았다고 생각하여 Swizzling의 개념부터 methodInvoked까지 학습 후 개선이 필요한 다른 곳들도 개선해 볼 생각입니다.
<br>

**- 유지보수를 위한 서버 통신 상태코드에 대한 개선**
<br>
현재는 상태코드에 대한 처리를 Literal하게 하고있지만 서버에서 각 에러에 대한 상태코드가 변경될 것을 고려하여 추후에는 이러한 부분도 열거형으로 개선해보고 싶습니다.
<br>

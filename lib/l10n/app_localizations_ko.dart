// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '이혁주 포트폴리오';

  @override
  String get navHome => '홈';

  @override
  String get navProjects => '프로젝트';

  @override
  String get navApi => 'API';

  @override
  String get navBlog => '블로그';

  @override
  String get navResume => '이력서';

  @override
  String get navContact => '연락처';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageEnglish => '영어';

  @override
  String get homeFeaturedProjects => '대표 프로젝트';

  @override
  String get homeRecentPosts => '최근 글';

  @override
  String get commonViewAll => '전체 보기';

  @override
  String get commonDownloadResume => '이력서 다운로드';

  @override
  String get commonBlog => '블로그';

  @override
  String get commonContact => '연락처';

  @override
  String get homeNoProjects => '아직 등록된 프로젝트가 없습니다.';

  @override
  String get homeNoPosts => '아직 게시글이 없습니다.';

  @override
  String get errLoadProfile => '프로필을 불러오지 못했습니다';

  @override
  String get errLoadProjects => '프로젝트를 불러오지 못했습니다';

  @override
  String get errLoadPosts => '게시글을 불러오지 못했습니다';

  @override
  String get projectsFilters => '필터';

  @override
  String get projectsStacks => '스택';

  @override
  String get projectsDomains => '도메인';

  @override
  String get projectsSortLatest => '최신순';

  @override
  String get projectsSortTitle => '제목 A-Z';

  @override
  String get projectsClear => '초기화';

  @override
  String get projectsNoMatch => '조건에 맞는 프로젝트가 없습니다.';

  @override
  String get blogSearchTitle => '제목 검색';

  @override
  String get commonTag => '태그';

  @override
  String get commonAll => '전체';

  @override
  String get errFailedToLoad => '불러오지 못했습니다';

  @override
  String get pageNotFound => '페이지를 찾을 수 없습니다';

  @override
  String get goHome => '홈으로 가기';

  @override
  String get commonMenu => '메뉴';

  @override
  String get commonLanguage => '언어';

  @override
  String get skipToContent => '본문으로 건너뛰기';

  @override
  String get privacyTitle => '개인정보처리방침';

  @override
  String get appPrivacyTitle => '앱 개인정보처리방침';

  @override
  String get apiSearchHint => '경로·요약·operationId 검색';

  @override
  String get apiGroupByTag => '태그별 그룹';

  @override
  String get apiIncludeAuth => '인증 헤더 포함';

  @override
  String get apiAuthToken => 'Bearer 토큰';

  @override
  String get apiUntagged => '태그 없음';

  @override
  String get apiParameters => '파라미터';

  @override
  String get apiRequestBodyJson => '요청 본문 (application/json)';

  @override
  String get apiResponseJson => '응답 (application/json, 2xx)';

  @override
  String get apiCurlTitle => 'cURL';

  @override
  String get apiCopy => '복사';

  @override
  String get apiCopiedCurl => 'cURL을 복사했습니다';

  @override
  String get errLoadSpec => '스펙을 불러오지 못했습니다';

  @override
  String get apiTryGet => '실행 (GET)';

  @override
  String get apiTry => '실행';

  @override
  String get apiExecute => '실행';

  @override
  String get apiStatus => '상태';

  @override
  String get apiHeaders => '헤더';

  @override
  String get apiBody => '본문';

  @override
  String get apiNoBaseUrl => 'Base URL이 없습니다';

  @override
  String get apiBaseUrl => 'Base URL';

  @override
  String get apiBaseUrlOverrideHint => '직접 입력(선택)';

  @override
  String get apiDuration => '소요시간';

  @override
  String get apiCopyUrl => 'URL 복사';

  @override
  String get apiCopiedUrl => 'URL을 복사했습니다';

  @override
  String get apiCopyBody => '본문 복사';

  @override
  String get apiCopiedBody => '본문을 복사했습니다';

  @override
  String get apiMockMode => '목업 응답';

  @override
  String get contactTitle => '연락하기';

  @override
  String get contactSubtitle => '새로운 프로젝트나 백엔드 아키텍처에 대해 논의하고 싶으시다면 언제든지 연락주세요.';

  @override
  String get contactFormTitle => '메시지 보내기';

  @override
  String get contactFormName => '이름';

  @override
  String get contactFormNameHint => '성함을 입력해주세요';

  @override
  String get contactFormEmail => '이메일';

  @override
  String get contactFormEmailHint => 'your.email@example.com';

  @override
  String get contactFormSubject => '제목';

  @override
  String get contactFormSubjectHint => '문의 내용을 간단히 요약해주세요';

  @override
  String get contactFormMessage => '메시지';

  @override
  String get contactFormMessageHint => '프로젝트나 문의사항에 대해 자세히 설명해주세요...';

  @override
  String get contactFormSend => '메시지 보내기';

  @override
  String get contactFormSending => '전송 중...';

  @override
  String get contactFormSuccess => '감사합니다! 메일 클라이언트가 열리며 메시지를 보낼 수 있습니다.';

  @override
  String get contactFormNameRequired => '이름을 입력해주세요';

  @override
  String get contactFormEmailRequired => '이메일을 입력해주세요';

  @override
  String get contactFormEmailInvalid => '올바른 이메일 주소를 입력해주세요';

  @override
  String get contactFormSubjectRequired => '제목을 입력해주세요';

  @override
  String get contactFormMessageRequired => '메시지를 입력해주세요';

  @override
  String get contactFormMessageTooShort => '메시지는 최소 10자 이상 입력해주세요';

  @override
  String get contactInfoTitle => '연락 정보';

  @override
  String get contactInfoDescription =>
      '다음 채널을 통해 언제든지 연락해주세요. 보통 24시간 이내에 답변드립니다.';

  @override
  String get contactResponseTime => '평일 기준 24시간 이내에 답변드립니다.';

  @override
  String get navSearch => '검색';

  @override
  String get searchPageTitle => '검색';

  @override
  String get searchHint => '프로젝트와 블로그 글 검색...';

  @override
  String get searchRecentSearches => '최근 검색';

  @override
  String get searchClearHistory => '지우기';

  @override
  String get searchPopularTags => '인기 태그';

  @override
  String searchNoResults(Object query) {
    return '\"$query\"에 대한 검색 결과가 없습니다';
  }

  @override
  String get searchNoResultsHint => '다른 키워드를 시도하거나 프로젝트와 블로그 글을 둘러보세요.';

  @override
  String searchResultsCount(num count, Object query) {
    return '\"$query\"에 대한 검색 결과 $count개';
  }

  @override
  String searchProjectsSection(num count) {
    return '프로젝트 $count개';
  }

  @override
  String searchPostsSection(num count) {
    return '블로그 글 $count개';
  }

  @override
  String get resumeSummaryTitle => '전문 요약';

  @override
  String get resumeExperienceTitle => '경력 사항';

  @override
  String get resumeSkillsTitle => '기술 스택';

  @override
  String get resumeSkillsProgramming => '프로그래밍 언어';

  @override
  String get resumeSkillsBackend => '백엔드 기술';

  @override
  String get resumeSkillsInfrastructure => '인프라 & DevOps';

  @override
  String get resumeSkillsData => '데이터 처리';

  @override
  String get resumeEducationTitle => '학력';

  @override
  String get resumeCertificationsTitle => '자격증';

  @override
  String get resumeProjectsTitle => '주요 프로젝트';

  @override
  String get resumeLanguagesTitle => '언어';

  @override
  String get resumeInterestsTitle => '관심사';
}

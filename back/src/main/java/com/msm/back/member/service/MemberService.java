package com.msm.back.member.service;

import com.msm.back.board.dto.BoardImageDto;
import com.msm.back.board.dto.BoardResponseDto;
import com.msm.back.common.SecurityUtil;
import com.msm.back.db.entity.*;
import com.msm.back.db.repository.*;
import com.msm.back.exception.MemberNotFoundException;
import com.msm.back.exception.ProductNotFoundException;
import com.msm.back.member.dto.*;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class MemberService {

	private final MemberRepository memberRepository;
	private final ReportRepository reportRepository;
	private final BoardRepository boardRepository;
	private final ScrapRepository scrapRepository;
	private final FileService fileService;
	private final ProductRepository productRepository;
	private final MyProductRepository myProductRepository;

	public ProfileResponseDto getMyProfile() {
		Long memberId = SecurityUtil.getCurrentMemberId();
		return getProfile(memberId);
	}

	public ProfileResponseDto getProfileById(Long profileMemberId) {
		return getProfile(profileMemberId);
	}

	public ProfileResponseDto getProfile(Long profileMemberId) {
		Member member = memberRepository.findById(profileMemberId)
			.orElseThrow(MemberNotFoundException::new);

		// Report에서 최신 정보 가져오기 (여기서는 가장 최근 Report를 기준으로 처리)
		Report latestReport = reportRepository.findFirstByMemberOrderByCreatedAtDesc(member)
			.orElse(null); // 최신 리포트가 없는 경우 null 처리

		ReportDto reportDto = null;
		if (latestReport != null) {
			// ReportDto 생성
			reportDto = ReportDto.builder()
				.acne(latestReport.getAcne())
				.wrinkle(latestReport.getWrinkle())
//				.blackhead(latestReport.getBlackhead())
				.age(latestReport.getAge())
				.skinType(latestReport.getSkinType())
				.faceShape(latestReport.getFaceShapeCode().getCodeName())
				.build();
		}

		ProfileResponseDto responseDto = ProfileResponseDto.builder()
			.member(member)
			.build();
		responseDto.setReport(reportDto);
		// ProfileResponseDto에 ReportDto 포함
		return responseDto;
	}

	public String uploadOrUpdateProfileImage(Long memberId, MultipartFile imgUrl) {
		Member member = memberRepository.findById(memberId)
			.orElseThrow(MemberNotFoundException::new);

		// 이미지 URL 업데이트 로직. 기존 이미지가 있다면 S3에서 삭제
		if (member.getImgUrl() != null && !member.getImgUrl().isEmpty()) {
			fileService.deleteFile(member.getImgUrl());
		}

		// 새 이미지 파일을 S3에 업로드하고, 새 URL 받아오기
		String newImageUrl = fileService.uploadFile(imgUrl);

		// 회원 정보에 새로운 이미지 URL 업데이트
		member.setImgUrl(newImageUrl);
		memberRepository.save(member); // 변경된 회원 정보 저장

		return newImageUrl; // 새로운 이미지 URL 반환
	}

	public void deleteProfileImage(Long memberId) {
		Member member = memberRepository.findById(memberId)
			.orElseThrow(MemberNotFoundException::new);

		if (member.getImgUrl() != null && !member.getImgUrl().isEmpty()) {
			// S3에서 이미지 파일 삭제
			fileService.deleteFile(member.getImgUrl());
			// 사용자 프로필에서 이미지 URL 제거
			member.setImgUrl(null);
			memberRepository.save(member);
		} else {
			throw new RuntimeException("삭제할 프로필 이미지가 없습니다.");
		}
	}

	public NicknameUpdateResponseDto updateNickname(String newNickname) {
		Long memberId = SecurityUtil.getCurrentMemberId();

		Member member = memberRepository.findById(memberId)
			.orElseThrow(MemberNotFoundException::new);

		member.setNickname(newNickname);
		memberRepository.save(member);

		return new NicknameUpdateResponseDto(member.getNickname());
	}

	public PrivacyResponseDto togglePrivacy() {
		Long memberId = SecurityUtil.getCurrentMemberId();

		Member member = memberRepository.findById(memberId)
			.orElseThrow(MemberNotFoundException::new);

		// privacy 값 변경
		member.setPrivacy(!member.isPrivacy());
		memberRepository.save(member);

		// 변경된 privacy 값을 PrivacyResponseDto 객체로 감싸 반환
		return new PrivacyResponseDto(member.isPrivacy());
	}

	public List<BoardResponseDto> getMyBoards() {
		Long memberId = SecurityUtil.getCurrentMemberId();

		// 사용자 ID를 기반으로 게시글 리스트 조회
		List<Board> boards = boardRepository.findByMemberIdOrderByCreatedAtDesc(memberId);

		// Board 엔티티 리스트를 BoardResponseDto 리스트로 변환 
		return boards.stream()
			.map(this::convertToBoardResponseDto)
			.collect(Collectors.toList());
	}

	public List<BoardResponseDto> getMemberBoards(Long memberId) {
		Member member = memberRepository.findById(memberId)
			.orElseThrow(MemberNotFoundException::new);

		List<BoardResponseDto> list = new ArrayList<>();
		// 멤버의 프라이버시가 true로 설정된 경우
		if (member.isPrivacy()) {
			list.add(BoardResponseDto.builder()
					.writer(getProfile(memberId))
					.board(new Board())
					.build());
			return list;
		}

		// 멤버의 프라이버시가 설정되지 않은 경우, 게시글 목록 반환
		List<Board> boards = boardRepository.findByMemberIdOrderByCreatedAtDesc(memberId);
		return boards.stream()
			.map(board -> convertToBoardResponseDto(board, memberId))
			.collect(Collectors.toList());
	}

	public List<BoardResponseDto> getScrapedBoards() {
		Long memberId = SecurityUtil.getCurrentMemberId();

		List<Scrap> scraps = scrapRepository.findByMemberId(memberId);

		return scraps.stream()
			.map(scrap -> convertToBoardResponseDto(scrap.getBoard(), scrap.getBoard().getMember().getId()))
			.collect(Collectors.toList());
	}

	private BoardResponseDto convertToBoardResponseDto(Board board) {
		return BoardResponseDto.builder()
			.board(board)
			.writer(getMyProfile())
			.boardImageDtoList(getBoardImagesDto(board))
			.build();
	}

	private BoardResponseDto convertToBoardResponseDto(Board board, Long memberId) {
		return BoardResponseDto.builder()
			.board(board)
			.writer(getProfileById(memberId))
			.boardImageDtoList(getBoardImagesDto(board))
			.build();
	}

	private List<BoardImageDto> getBoardImagesDto(Board board) {
		List<BoardImageDto> boardImageDtos = new ArrayList<>();
		if (board.getBoardImages() != null) {
			boardImageDtos = board.getBoardImages().stream()
				.map(boardImage -> BoardImageDto.builder()
					.boardImage(boardImage)
					.build())
				.collect(Collectors.toList());
		}
		return boardImageDtos;
	}

	public List<MyProductResponseDto> getMyProducts() {
		Long memberId = SecurityUtil.getCurrentMemberId();

		List<MyProduct> myProducts = myProductRepository.findByMemberId(memberId);
		return myProducts.stream()
			.map(myProduct -> {
				return MyProductResponseDto.builder()
					.id(myProduct.getId())
					.productId(myProduct.getProduct().getId())
					.name(myProduct.getProduct().getName())
					.imgUrl(myProduct.getProduct().getImgUrl())
					.brand(myProduct.getProduct().getBrand())
					.category(myProduct.getProduct().getCategory().getCodeName())
					.price(myProduct.getProduct().getPrice())
					.cnt(myProduct.getCnt())
					.rating(myProduct.getRating())
					.review(myProduct.getReview())
					.isActive(myProduct.isActive())
					.privacy(myProduct.getMember().isPrivacy())
					.build();
			})
			.collect(Collectors.toList());
	}

	public List<MyProductResponseDto> getMemberProducts(Long memberId) {
		Member member = memberRepository.findById(memberId)
			.orElseThrow(MemberNotFoundException::new);

		// 멤버의 프라이버시가 true로 설정된 경우
		if (member.isPrivacy()) {
			// 비공개 프로필의 게시글 접근 시도에 대해 프라이버시 설정만 포함한 응답을 반환
			MyProductResponseDto privacyNotice = MyProductResponseDto.builder()
				.privacy(true)
				.build();
			return List.of(privacyNotice);
		}

		List<MyProduct> myProducts = myProductRepository.findByMemberId(memberId);
		return myProducts.stream()
			.map(myProduct -> {
				return MyProductResponseDto.builder()
					.id(myProduct.getId())
					.productId(myProduct.getProduct().getId())
					.name(myProduct.getProduct().getName())
					.imgUrl(myProduct.getProduct().getImgUrl())
					.brand(myProduct.getProduct().getBrand())
					.category(myProduct.getProduct().getCategory().getCodeName())
					.price(myProduct.getProduct().getPrice())
					.cnt(myProduct.getCnt())
					.rating(myProduct.getRating())
					.review(myProduct.getReview())
					.isActive(myProduct.isActive())
					.privacy(myProduct.getMember().isPrivacy())
					.build();
			})
			.collect(Collectors.toList());
	}

	public MyProductResponseDto addMyProduct(MyProductRequestDto request) {
		Long memberId = SecurityUtil.getCurrentMemberId();

		Member member = memberRepository.findById(memberId)
			.orElseThrow(MemberNotFoundException::new);

		Product product = productRepository.findById(request.getProductId())
			.orElseThrow(ProductNotFoundException::new);

		MyProduct myProduct = MyProduct.builder()
			.member(member)
			.product(product)
			.cnt(request.getCnt())
			.rating(request.getRating())
			.review(request.getReview())
			.build();

		product.evaluate(0.0,request.getRating());

		myProductRepository.save(myProduct);

		return MyProductResponseDto.builder()
			.id(myProduct.getId())
			.productId(myProduct.getProduct().getId())
			.name(myProduct.getProduct().getName())
			.imgUrl(myProduct.getProduct().getImgUrl())
			.brand(myProduct.getProduct().getBrand())
			.category(myProduct.getProduct().getCategory().getCodeName())
			.price(myProduct.getProduct().getPrice())
			.cnt(myProduct.getCnt())
			.rating(myProduct.getRating())
			.review(myProduct.getReview())
			.isActive(myProduct.isActive())
			.privacy(myProduct.getMember().isPrivacy())
			.build();
	}

	public void deleteMyProduct(Long myProductId) {
		MyProduct myProduct = myProductRepository.findById(myProductId)
			.orElseThrow(ProductNotFoundException::new);
		myProduct.getProduct().cancleEvaluate(myProduct.getRating());

		myProductRepository.delete(myProduct);
	}

	public MyProductResponseDto evaluateMyProduct(MyProductRequestDto request) {
		MyProduct myProduct = myProductRepository.findById(request.getId())
			.orElseThrow(ProductNotFoundException::new);

		myProduct.getProduct().evaluate(myProduct.getRating(), request.getRating());
		// 평가 점수와 리뷰 업데이트
		myProduct.setRating(request.getRating());
		myProduct.setReview(request.getReview());

		myProductRepository.save(myProduct);

		return MyProductResponseDto.builder()
			.id(myProduct.getId())
			.productId(myProduct.getProduct().getId())
			.name(myProduct.getProduct().getName())
			.imgUrl(myProduct.getProduct().getImgUrl())
			.brand(myProduct.getProduct().getBrand())
			.category(myProduct.getProduct().getCategory().getCodeName())
			.price(myProduct.getProduct().getPrice())
			.cnt(myProduct.getCnt())
			.rating(myProduct.getRating())
			.review(myProduct.getReview())
			.privacy(myProduct.getMember().isPrivacy())
			.build();
	}

	public MyProductResponseDto toggleProductActiveStatus(Long myProductId) {
		MyProduct myProduct = myProductRepository.findById(myProductId)
			.orElseThrow(ProductNotFoundException::new);

		myProduct.setActive(!myProduct.isActive());
		myProductRepository.save(myProduct);

		return MyProductResponseDto.builder()
			.id(myProduct.getId())
			.productId(myProduct.getProduct().getId())
			.name(myProduct.getProduct().getName())
			.imgUrl(myProduct.getProduct().getImgUrl())
			.brand(myProduct.getProduct().getBrand())
			.category(myProduct.getProduct().getCategory().getCodeName())
			.price(myProduct.getProduct().getPrice())
			.cnt(myProduct.getCnt())
			.rating(myProduct.getRating())
			.review(myProduct.getReview())
			.isActive(myProduct.isActive())
			.privacy(myProduct.getMember().isPrivacy())
			.build();
	}

}

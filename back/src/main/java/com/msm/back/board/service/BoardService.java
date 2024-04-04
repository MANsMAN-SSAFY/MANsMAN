package com.msm.back.board.service;

import com.msm.back.board.dto.*;
import com.msm.back.comment.util.AlarmTypeEnum;
import com.msm.back.comment.util.AlarmUtil;
import com.msm.back.common.SecurityUtil;
import com.msm.back.db.entity.*;
import com.msm.back.db.repository.*;
import com.msm.back.exception.BoardNotFoundException;
import com.msm.back.exception.CustomAuthenticationException;
import com.msm.back.exception.MemberNotFoundException;
import com.msm.back.member.dto.ReportDto;
import com.msm.back.member.service.FileService;
import com.msm.back.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Slice;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BoardService {

	private final BoardRepository boardRepository;
	private final BoardLikeRepository boardLikeRepository;
	private final BoardImageRepository boardImageRepository;
	private final MemberRepository memberRepository;
	private final FileService fileService;
	private final MemberService memberService;
	private final ScrapRepository scrapRepository;
	private final ReportRepository reportRepository;
	private final AlarmUtil alarmUtil;
	private final CommentRepository commentRepository;

	private final RedisTemplate<String, Object> redisTemplate;

	@Transactional
	public BoardResponseDto createBoard(BoardRequestDto boardRequestDto) {
		List<MultipartFile> imageFiles = boardRequestDto.getImg();

		Member member = getMember();
		Board board = Board.builder()
			.title(boardRequestDto.getTitle())
			.content(boardRequestDto.getContent())
			.viewCnt(0L)
			.commentCnt(0L)
			.likeCnt(0L)
			.member(member)
			.build();

		Board savedBoard = boardRepository.save(board); // Save the board to generate ID

		List<BoardImageDto> boardImageDto = saveBoardImages(imageFiles, savedBoard);

		return convertToResponseDto(savedBoard, boardImageDto);
	}

	private List<BoardImageDto> saveBoardImages(List<MultipartFile> imageFiles, Board board) {
		List<BoardImageDto> boardImages = new ArrayList<>();
		if (imageFiles != null && !imageFiles.isEmpty()) {
			int order = 0; // 이미지 순서
			for (MultipartFile file : imageFiles) {
				String imageUrl = fileService.uploadFile(file);
				BoardImage boardImage = BoardImage.builder()
					.boardImgUrl(imageUrl)
					.displayOrder(order++)
					.board(board)  // Associate the board with the board image
					.build();

				BoardImage savedBoardImage = boardImageRepository.save(boardImage);
				boardImages.add(
					BoardImageDto.builder()
						.boardImage(savedBoardImage)
						.build()
				);

			}
		}
		return boardImages;
	}

	@Transactional
	public BoardResponseDto editBoard(BoardRequestDto boardRequestDto) {
		List<MultipartFile> imageFiles = boardRequestDto.getImg();

		Member member = getMember();
		Board board = getBoard(boardRequestDto.getId());

		if (!Objects.equals(board.getMember().getId(), member.getId())) {
			throw new CustomAuthenticationException("접근할 수 없는 게시글입니다.");
		}

		board.setTitle(boardRequestDto.getTitle());
		board.setContent(boardRequestDto.getContent());

		List<BoardImage> existingImages = board.getBoardImages();
		if (existingImages != null && !existingImages.isEmpty()) {
			for (BoardImage image : existingImages) {
				fileService.deleteFile(image.getBoardImgUrl());
				boardImageRepository.delete(image);
			}
			existingImages.clear(); // Clear the list
		}

		List<BoardImageDto> boardImages = new ArrayList<>();

		if (imageFiles != null && !imageFiles.isEmpty()) {
			int order = 0;
			for (MultipartFile file : imageFiles) {
				String imageUrl = fileService.uploadFile(file);
				BoardImage boardImage = BoardImage.builder()
					.boardImgUrl(imageUrl)
					.displayOrder(order++)
					.board(board)
					.build();

				BoardImage savedBoardImage = boardImageRepository.save(boardImage);
				boardImages.add(
					BoardImageDto.builder()
						.boardImage(savedBoardImage)
						.build()
				);
			}
		}

		Board updatedBoard = boardRepository.save(board);
		return convertToResponseDto(updatedBoard, boardImages);
	}

	@Transactional
	public void deleteBoard(Long id) {
		Member member = getMember();
		Board board = getBoard(id);

		if (!Objects.equals(board.getMember().getId(), member.getId())) {
			throw new CustomAuthenticationException("접근할 수 없는 게시글입니다.");
		}

		// 사진 지우기
		List<BoardImage> boardImages = board.getBoardImages();
		if (boardImages != null && !boardImages.isEmpty()) {
			for (BoardImage image : boardImages) {
				fileService.deleteFile(image.getBoardImgUrl());
			}
			boardImageRepository.deleteAll(boardImages);
		}
		commentRepository.deleteByBoardId(id);

		// Delete the board
		boardRepository.deleteById(id);
	}

	@Transactional(readOnly = true)
	public BoardListResponseDto getAllBoards(Long lastId, Integer pageSize, String searchWord) {
		Member member = getMember();
		System.out.println(member.getId());

		Slice<BoardDto> boards = boardRepository.findAll(lastId, pageSize, searchWord, member.getId());

		for (BoardDto board : boards) {
			Report latestReport = reportRepository.findFirstByMemberIdOrderByCreatedAtDesc(board.getWriter().getId())
				.orElse(null);

			ReportDto reportDto = null;
			if (latestReport != null) {
				// ReportDto 생성
				reportDto = ReportDto.builder()
					.acne(latestReport.getAcne())
					.wrinkle(latestReport.getWrinkle())
//					.blackhead(latestReport.getBlackhead())
					.age(latestReport.getAge())
					.skinType(latestReport.getSkinType())
					.faceShape(latestReport.getFaceShapeCode().getCodeName())
					.build();
			}

			board.getWriter().setReport(reportDto);
		}

		return new BoardListResponseDto(new ArrayList<>(boards.getContent()),
			boards.hasNext());
		// boards.stream()
		//     .map(board -> convertToResponseDto(board, getBoardImagesDto(board)))
		//     .collect(Collectors.toList());
	}

	//    @Transactional(readOnly = true)
	//    public List<BoardResponseDto> searchBoards(String keyword) {
	//        List<Board> boards = boardRepository.findByTitleContaining(keyword);
	//        return boards.stream()
	//                .map(board -> convertToResponseDto(board, getBoardImagesDto(board)))
	//                .collect(Collectors.toList());
	//    }

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

	@Transactional(readOnly = false)
	public BoardResponseDto getBoardResponseDtoById(Long id) {
		Member member = getMember();
		Board board = getBoard(id);

		String boardViewCountKey = "board:" + id + ":views";
		String userKey = "user:" + member.getId();
		boolean hasViewed = Boolean.TRUE.equals(redisTemplate.opsForSet().isMember(userKey, boardViewCountKey));
		if (!hasViewed) {
			redisTemplate.opsForHash().increment(boardViewCountKey, "count", 1L);
			redisTemplate.opsForSet().add(userKey, boardViewCountKey);

			board.addView();
			boardRepository.save(board);
		}
		return convertToResponseDto(board, getBoardImagesDto(board));
	}

	@Transactional
	public BoardLikeDto isLikeBoard(Long id) {
		Board board = getBoard(id);
		Member member = getMember();
		boolean existBoard = boardLikeRepository.existsByBoardAndMember(board, member);

		BoardLikeDto boardLikeDto;
		if (existBoard) {
			boardLikeDto = BoardLikeDto.builder().isLike(true).build();
		} else {
			boardLikeDto = BoardLikeDto.builder().isLike(false).build();
		}
		return boardLikeDto;
	}

	@Transactional
	public void likeBoard(Long id) {
		Board board = getBoard(id);
		Member member = getMember();

		boolean existBoard = boardLikeRepository.existsByBoardAndMember(board, member);

		if (!existBoard) {
			// 사용자가 이 게시물에 좋아요를 누른 적이 없으면 새로운 BoardLike 생성
			BoardLikeId boardLikeId = new BoardLikeId(board.getId(), member.getId());
			BoardLike boardLike = BoardLike.builder()
				.id(boardLikeId)
				.board(board)
				.member(member)
				.build();
			boardLikeRepository.save(boardLike);

			// 좋아요 개수 업데이트
			board.addLike();
			boardRepository.save(board);

			if(!board.getMember().getId().equals(member.getId())){
				// 알람 보내기
				Member fromMember = member;
				Member toMember = board.getMember();
				AlarmTypeEnum alarmTypeEnum = AlarmTypeEnum.LIKECOMMENT;

				alarmUtil.sendAlarm(fromMember, toMember, alarmTypeEnum, id);
			}

		}
	}

	@Transactional
	public void unlikeBoard(Long id) {
		Board board = getBoard(id);
		Member member = getMember();
		BoardLike boardLike = boardLikeRepository.findByBoardAndMember(board, member);

		if (boardLike != null) {
			boardLikeRepository.delete(boardLike);

			// 좋아요 개수 업데이트
			board.removeLike();
			boardRepository.save(board);
		}
	}

	@Transactional
	public void scrapBoard(Long id) {
		Board board = getBoard(id);
		Member member = getMember();

		boolean existScrap = scrapRepository.existsByBoardAndMember(board, member);

		if (!existScrap) {
			Scrap scrap = Scrap.builder()
				.board(board)
				.member(member)
				.build();
			scrapRepository.save(scrap);
		}
	}

	@Transactional
	public void unscrapBoard(Long id) {
		Board board = getBoard(id);
		Member member = getMember();
		Scrap scrap = scrapRepository.findByBoardAndMember(board, member);

		if (scrap != null) {
			scrapRepository.delete(scrap);
		}
	}

	private BoardResponseDto convertToResponseDto(Board board, List<BoardImageDto> boardImageDto) {
		Member member = getMember();

		boolean isLike = boardLikeRepository.existsByBoardAndMember(board, member);
		boolean isScrap = scrapRepository.existsByBoardAndMember(board, member);
		return BoardResponseDto.builder()
			.board(board)
			.writer(memberService.getProfile(board.getMember().getId()))
			.boardImageDtoList(boardImageDto != null ? boardImageDto : new ArrayList<>())
			.isLike(isLike)
			.isScrap(isScrap)
			.build();
	}

	private Member getMember() {
		return memberRepository.findById(SecurityUtil.getCurrentMemberId())
			.orElseThrow(MemberNotFoundException::new);
	}

	private Board getBoard(Long boardId) {
		return boardRepository.findById(boardId)
			.orElseThrow(BoardNotFoundException::new);
	}


}

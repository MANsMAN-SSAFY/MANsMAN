package com.msm.back.db.repository;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.stereotype.Repository;

import com.msm.back.board.dto.BoardDto;
import com.msm.back.board.dto.BoardImageDto;
import com.msm.back.db.entity.BoardImage;
import com.msm.back.db.entity.QBoard;
import com.msm.back.db.entity.QBoardImage;
import com.msm.back.db.entity.QBoardLike;
import com.msm.back.db.entity.QMember;
import com.msm.back.db.entity.QScrap;
import com.msm.back.member.dto.ProfileResponseDto;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class BoardCustomImpl implements BoardCustom {

	private final JPAQueryFactory query;
	private final QBoard board = QBoard.board;
	private final QMember member = QMember.member;
	private final QScrap scrap = QScrap.scrap;
	private final QBoardLike boardLike = QBoardLike.boardLike;
	private final QBoardImage boardImage = QBoardImage.boardImage;

	@Override
	public Slice<BoardDto> findAll(Long lastId, int pageSize, String searchWord, Long memberId) {
		Pageable pageable = PageRequest.of(1, pageSize);

		List<Tuple> results = query
			.select(board, board.member, boardLike.member.id, scrap.member.id)
			.from(board)
			.leftJoin(boardLike)
			.on(board.id.eq(boardLike.board.id).and(boardLike.member.id.eq(memberId)))
			.leftJoin(scrap)
			.on(board.id.eq(scrap.board.id).and(scrap.member.id.eq(memberId)))
			.where(ltBoardId(lastId))
			.where(hasSearchWord(searchWord))
			.orderBy(board.id.desc())
			.limit(pageSize + 1)
			.fetch();

		List<BoardDto> list = new ArrayList<>();
		for (Tuple result : results) {
			List<BoardImageDto> boardImageList = new ArrayList<>();
			Long boardId = result.get(board).getId();
			List<BoardImage> boardImages = query
				.select(boardImage)
				.from(boardImage)
				.where(boardImage.board.id.eq(boardId))
				.fetch();
			for (BoardImage image : boardImages) {
				boardImageList.add(BoardImageDto.builder()
					.boardImage(image)
					.build());
			}

			list.add(BoardDto.builder()
				.board(result.get(board))
				.writer(ProfileResponseDto.builder()
					.member(result.get(board.member))
					.build())
				.boardImageDtoList(boardImageList)
				.isLike(result.get(boardLike.member.id) != null)
				.isScrap(result.get(scrap.member.id) != null)
				.build());
		}
		return checkLastPage(pageable, list);
	}

	private BooleanExpression ltBoardId(Long boardId) {
		if (boardId == null) {
			return null;
		}
		return board.id.lt(boardId);
	}

	private BooleanExpression hasSearchWord(String searchWord) {
		if (searchWord == null) {
			return null;
		}
		return board.title.contains(searchWord).or(board.content.contains(searchWord));
	}

	private Slice<BoardDto> checkLastPage(Pageable pageable, List<BoardDto> results) {

		boolean hasNext = false;

		// 조회한 결과 개수가 요청한 페이지 사이즈보다 크면 뒤에 더 있음, next = true
		if (results.size() > pageable.getPageSize()) {
			hasNext = true;
			results.remove(pageable.getPageSize());
		}

		return new SliceImpl<>(results, pageable, hasNext);
	}
}

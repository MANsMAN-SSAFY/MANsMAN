package com.msm.back.comment.service;

import com.msm.back.comment.dto.CommentRequestDto;
import com.msm.back.comment.dto.CommentResponseDto;
import com.msm.back.comment.util.AlarmTypeEnum;
import com.msm.back.comment.util.AlarmUtil;
import com.msm.back.common.SecurityUtil;
import com.msm.back.db.entity.*;
import com.msm.back.db.repository.*;
import com.msm.back.exception.BoardNotFoundException;
import com.msm.back.exception.CommentNotFoundException;
import com.msm.back.exception.CustomAuthenticationException;
import com.msm.back.exception.MemberNotFoundException;
import com.msm.back.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CommentService {

	private final BoardRepository boardRepository;
	private final BoardLikeRepository boardLikeRepository;
	private final BoardImageRepository boardImageRepository;
	private final MemberRepository memberRepository;
	private final CommentRepository commentRepository;
	private final CommentLikeRepository commentLikeRepository;
	private final MemberService memberService;
	private final AlarmUtil alarmUtil;

	@Transactional
	public CommentResponseDto createComment(Long boardId, CommentResponseDto commentResponseDto) {
		Member member = getMember();
		Board board = getBoard(boardId);

		Comment comment = Comment.builder()
			.board(board)
			.member(member)
			.content(commentResponseDto.getContent())
			.likeCnt(0L)
			.build();

		Comment savedComment = commentRepository.save(comment);

		if (!board.getMember().getId().equals(member.getId())) {
			// 알람 보내기
			Member fromMember = member;
			Member toMember = board.getMember();
			AlarmTypeEnum alarmTypeEnum = AlarmTypeEnum.POSTCOMMENT;

			alarmUtil.sendAlarm(fromMember, toMember, alarmTypeEnum, boardId);
		}
		boolean isLike = false;

		// 댓글 개수 증가
		board.addComment();

		return convertToResponseDto(savedComment, isLike);
	}

	@Transactional
	public CommentResponseDto editComment(Long boardId, Long commentId, CommentRequestDto commentRequestDto) {
		Member member = getMember();
		Comment comment = getComment(commentId);

		// 잘못된 접근
		if (!Objects.equals(comment.getMember().getId(), member.getId())) {
			throw new CustomAuthenticationException("접근할 수 없는 댓글입니다.");
		}

		comment.setContent(commentRequestDto.getContent());
		Comment updatedComment = commentRepository.save(comment);
		boolean isLike = isLikeComment(comment, member);

		return convertToResponseDto(updatedComment, isLike);
	}

	@Transactional
	public void deleteComment(Long commentId) {
		Member member = getMember();
		Comment comment = getComment(commentId);
		Board board = comment.getBoard();

		// 잘못된 접근
		if (!Objects.equals(comment.getMember().getId(), member.getId())) {
			throw new CustomAuthenticationException("접근할 수 없는 댓글입니다.");
		}

		// 댓글 개수 감소
		board.removeComment();

		// Delete the board
		commentRepository.deleteById(commentId);
	}

	@Transactional(readOnly = true)
	public List<CommentResponseDto> getAllComments(Long boardId) {
		Member member = getMember();
		Board board = getBoard(boardId);

		List<Comment> comments = commentRepository.findAllByBoard(board);
		return comments.stream()
			.map(comment -> convertToResponseDto(comment, isLikeComment(comment, member)))
			.collect(Collectors.toList());
	}

	@Transactional
	public void likeComment(Long commentId) {
		Comment comment = getComment(commentId);
		Member member = getMember();

		CommentLike commentLike = commentLikeRepository.findByCommentAndMember(comment, member);

		if (commentLike == null) {
			CommentLikeId commentLikeId = new CommentLikeId(comment.getId(), member.getId());
			commentLike = CommentLike.builder()
				.id(commentLikeId)
				.comment(comment)
				.member(member)
				.build();
			commentLikeRepository.save(commentLike);
		}

		comment.addLike();
		commentRepository.save(comment);

		if (!commentLike.getMember().getId().equals(member.getId())) {
			Member fromMember = member;
			Member toMember = comment.getMember();
			AlarmTypeEnum alarmTypeEnum = AlarmTypeEnum.LIKECOMMENT;

			alarmUtil.sendAlarm(fromMember, toMember, alarmTypeEnum, comment.getBoard().getId());
		}
		// 알람 보내기

	}

	@Transactional
	public void unlikeBoard(Long commentId) {
		Comment comment = getComment(commentId);
		Member member = getMember();

		CommentLike commentLike = commentLikeRepository.findByCommentAndMember(comment, member);

		if (commentLike != null) {
			commentLikeRepository.delete(commentLike);

			// 좋아요 개수 업데이트
			comment.removeLike();
			commentRepository.save(comment);
		}
	}

	private CommentResponseDto convertToResponseDto(Comment comment, boolean isLike) {
		return CommentResponseDto.builder()
			.id(comment.getId())
			.content(comment.getContent())
			.writer(memberService.getProfile(comment.getMember().getId()))
			.likeCnt(comment.getLikeCnt())
			.isLike(isLike)
			.createdAt(comment.getCreatedAt())
			.updatedAt(comment.getUpdatedAt())
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

	private Comment getComment(Long commentId) {
		return commentRepository.findById(commentId)
			.orElseThrow(CommentNotFoundException::new);
	}

	public boolean isLikeComment(Comment comment, Member member) {
		CommentLike commentLike = commentLikeRepository.findByCommentAndMember(comment, member);
		return commentLike != null;
	}

}

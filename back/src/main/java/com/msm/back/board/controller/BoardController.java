package com.msm.back.board.controller;

import com.msm.back.board.dto.BoardLikeDto;
import com.msm.back.board.dto.BoardListResponseDto;
import com.msm.back.board.dto.BoardRequestDto;
import com.msm.back.board.dto.BoardResponseDto;
import com.msm.back.board.service.BoardService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/boards")
public class BoardController {
    private final BoardService boardService;


    @PostMapping("")
    @Operation(summary = "게시물 생성")
    public ResponseEntity<BoardResponseDto> createBoard(BoardRequestDto boardRequestDto) {
        BoardResponseDto createdBoard = boardService.createBoard(boardRequestDto);
        if (createdBoard != null) {
            return ResponseEntity.status(HttpStatus.CREATED).body(createdBoard);
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    @PutMapping("/{id}")
    @Operation(summary = "게시물 수정")
    public ResponseEntity<BoardResponseDto> editBoard(BoardRequestDto boardRequestDto) {
        BoardResponseDto editedBoard = boardService.editBoard(boardRequestDto);
        if (editedBoard != null) {
            return ResponseEntity.ok(editedBoard);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "게시물 삭제")
    public ResponseEntity<Void> deleteBoard(@PathVariable Long id) {
        boardService.deleteBoard(id);
        return ResponseEntity.noContent().build();
    }


    @GetMapping("")
    @Operation(summary = "게시물 리스트/검색")
    public ResponseEntity<BoardListResponseDto> getAllBoards(
           @RequestParam(value = "lastId",required = false) Long lastId,
           @RequestParam("pageSize") Integer pageSize,
           @RequestParam(value = "searchWord",required = false) String searchWord
    ) {
        BoardListResponseDto boards = boardService.getAllBoards(lastId, pageSize, searchWord);
        return ResponseEntity.ok(boards);
    }

//    @GetMapping("/search")
//    @Operation(summary = "게시물 검색결과")
//    public ResponseEntity<List<BoardResponseDto>> searchBoards(@RequestParam("keyword") String keyword) {
//        List<BoardResponseDto> boards = boardService.searchBoards(keyword);
//        return ResponseEntity.ok(boards);
//    }

    @GetMapping("/{id}")
    @Operation(summary = "게시물 상세조회")
    public ResponseEntity<BoardResponseDto> getBoardById(@PathVariable Long id) {
        BoardResponseDto board = boardService.getBoardResponseDtoById(id);
        if (board != null) {
            return ResponseEntity.ok(board);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/{id}/likes")
    @Operation(summary = "게시물 좋아요 조회")
    public ResponseEntity<BoardLikeDto> isLikeBoard(@PathVariable Long id) {
        BoardLikeDto boardLikeDto = boardService.isLikeBoard(id);
        return ResponseEntity.ok(boardLikeDto);
    }

    @PostMapping("/{id}/likes")
    @Operation(summary = "게시물 좋아요")
    public ResponseEntity<Void> likeBoard(@PathVariable Long id) {
        boardService.likeBoard(id);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{id}/likes")
    @Operation(summary = "게시물 좋아요 삭제")
    public ResponseEntity<Void> unlikeBoard(@PathVariable Long id) {
        boardService.unlikeBoard(id);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{id}/scraps")
    @Operation(summary = "게시물 스크랩")
    public ResponseEntity<Void> scrapBoard(@PathVariable Long id) {
        boardService.scrapBoard(id);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{id}/scraps")
    @Operation(summary = "게시물 스크랩 삭제")
    public ResponseEntity<Void> unscrapBoard(@PathVariable Long id) {
        boardService.unscrapBoard(id);
        return ResponseEntity.ok().build();
    }
}
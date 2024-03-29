package com.msm.back.db.repository;

import org.springframework.data.domain.Slice;

import com.msm.back.board.dto.BoardDto;

public interface BoardCustom {
	Slice<BoardDto> findAll(Long lastId, int pageSize, String searchWord);
}

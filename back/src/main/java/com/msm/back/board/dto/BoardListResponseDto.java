package com.msm.back.board.dto;

import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class BoardListResponseDto {

	private List<BoardDto> data;
	private boolean hasNext;
	private Long lastId;

	public BoardListResponseDto(List<BoardDto> data, boolean hasNext) {
		this.data = data;
		this.hasNext = hasNext;
		this.lastId = !data.isEmpty()?data.get(data.size()-1).getId():0;
	}
}

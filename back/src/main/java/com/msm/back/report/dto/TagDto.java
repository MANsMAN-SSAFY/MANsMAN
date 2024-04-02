package com.msm.back.report.dto;

import com.msm.back.db.entity.Tag;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class TagDto {
	private Long id;
	private String content;

	@Builder
	public TagDto(Tag tag) {
		this.id = tag.getId();
		this.content = tag.getContent();
	}
}

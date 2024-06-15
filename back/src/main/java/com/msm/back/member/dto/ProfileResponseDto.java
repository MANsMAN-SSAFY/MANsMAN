package com.msm.back.member.dto;

import com.msm.back.db.entity.Member;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class ProfileResponseDto {
	private Long id;
	private String email;
	private String nickname;
	private LocalDate birthday;
	private String imgUrl;
	private boolean privacy;
	private LocalDateTime createdAt;
	@Setter
	private ReportDto report;

	@Builder
	public ProfileResponseDto(Member member) {
		this.id = member.getId();
		this.email = member.getEmail();
		this.nickname = member.getNickname();
		this.birthday = member.getBirthday();
		this.imgUrl = member.getImgUrl();
		this.privacy = member.isPrivacy();
		this.createdAt = member.getCreatedAt();
	}

	public ProfileResponseDto() {
		this.privacy = false;
	}
}

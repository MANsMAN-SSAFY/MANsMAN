package com.msm.back.tag.service;

import com.msm.back.db.entity.Report;
import com.msm.back.db.entity.Tag;
import com.msm.back.db.repository.ReportRepository;
import com.msm.back.db.repository.TagRepository;
import com.msm.back.exception.ReportNotFoundException;
import com.msm.back.exception.TagNotFoundException;
import com.msm.back.tag.dto.TagRequestDto;
import com.msm.back.tag.dto.TagResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class TagService {

    private final TagRepository tagRepository;
    private final ReportRepository reportRepository;

    public TagResponseDto saveTag(TagRequestDto tagRequestDto) {
        Long reportId = tagRequestDto.getReportId();
        Report report = reportRepository.findById(reportId).orElseThrow(ReportNotFoundException::new);
        String content = tagRequestDto.getContent();
        String color = tagRequestDto.getColor();

        Tag tag = Tag.builder().report(report).content(content).build();
        Tag savedTag = tagRepository.save(tag);

        return savedTag.toTagResponseDto();
    }

    public void deleteTag(Long tagId) {
        Tag tag = tagRepository.findById(tagId).orElseThrow(TagNotFoundException::new);
        tagRepository.deleteById(tagId);
    }

}

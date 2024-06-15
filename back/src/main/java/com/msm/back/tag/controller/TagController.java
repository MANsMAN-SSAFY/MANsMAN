package com.msm.back.tag.controller;

import com.msm.back.tag.dto.TagRequestDto;
import com.msm.back.tag.dto.TagResponseDto;
import com.msm.back.tag.service.TagService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/tags")
public class TagController {

    private final TagService tagService;
    @PostMapping("")
    public ResponseEntity<TagResponseDto> saveTag(@RequestBody TagRequestDto tagRequestDto) {
        TagResponseDto tagResponseDto = tagService.saveTag(tagRequestDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(tagResponseDto);
    }

    @DeleteMapping("/{tagId}")
    public ResponseEntity<Void> deleteTag(@PathVariable Long tagId) {
        tagService.deleteTag(tagId);
        return ResponseEntity.ok().build();
    }
}

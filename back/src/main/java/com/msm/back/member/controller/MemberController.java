package com.msm.back.member.controller;

import com.msm.back.board.dto.BoardResponseDto;
import com.msm.back.member.dto.*;
import com.msm.back.member.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/members")
public class MemberController {
    private final MemberService memberService;

    // 내 프로필 조회
    @GetMapping("/profiles")
    @Operation(summary = "내 프로필 조회")
    public ResponseEntity<ProfileResponseDto> getMyProfile() {
        ProfileResponseDto profile = memberService.getMyProfile();
        return ResponseEntity.ok(profile);
    }

    // 타인 프로필 조회
    @GetMapping("/{memberId}/profiles")
    @Operation(summary = "타인 프로필 조회")
    public ResponseEntity<ProfileResponseDto> getProfileById(@PathVariable Long memberId) {
        ProfileResponseDto profile = memberService.getProfileById(memberId);
        return ResponseEntity.ok(profile);
    }

    // 프로필 사진 등록 및 수정
    @PostMapping("/images")
    @Operation(summary = "프로필 사진 등록 및 수정")
    public ResponseEntity<ImgResponseDto> uploadOrUpdateProfileImage(@RequestParam("imgUrl") MultipartFile imgUrl) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long memberId = Long.parseLong(authentication.getName());

        return ResponseEntity.ok(new ImgResponseDto(memberService.uploadOrUpdateProfileImage(memberId, imgUrl)));
    }

    // 프로필 사진 삭제
    @DeleteMapping("/images")
    @Operation(summary = "프로필 사진 삭제")
    public ResponseEntity<Void> deleteProfileImage() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long memberId = Long.parseLong(authentication.getName());

        memberService.deleteProfileImage(memberId);
        return ResponseEntity.ok().build();
    }

    // 닉네임 추가 및 수정
    @PatchMapping("/nicknames")
    @Operation(summary = "닉네임 추가 및 수정")
    public ResponseEntity<NicknameUpdateResponseDto> updateNickname(@RequestBody NicknameUpdateRequestDto requestDto) {
        if (requestDto.getNickname() == null || requestDto.getNickname().trim().isEmpty()) {
            return ResponseEntity.badRequest().build(); // 적절한 닉네임이 제공되지 않은 경우, 요청을 거부합니다.
        }

        NicknameUpdateResponseDto responseDto = memberService.updateNickname(requestDto.getNickname());
        return ResponseEntity.ok(responseDto); // 변경된 닉네임을 포함하는 응답 반환
    }

    // 회원 정보 공개/비공개 여부 변경
    @PatchMapping("/privacies")
    @Operation(summary = "회원 정보 공개/비공개 여부 변경")
    public ResponseEntity<PrivacyResponseDto> togglePrivacy() {
        PrivacyResponseDto responseDto = memberService.togglePrivacy();
        return ResponseEntity.ok(responseDto);
    }

    // 내가 작성한 글 리스트 조회
    @GetMapping("/boards")
    @Operation(summary = "내가 작성한 글 리스트 조회")
    public ResponseEntity<List<BoardResponseDto>> getMyBoards() {
        List<BoardResponseDto> myBoards = memberService.getMyBoards();
        return ResponseEntity.ok(myBoards);
    }

    // 타인이 작성한 글 리스트 조회
    @GetMapping("/{memberId}/boards")
    @Operation(summary = "타인이 작성한 글 리스트 조회")
    public ResponseEntity<List<BoardResponseDto>> getMemberBoards(@PathVariable Long memberId) {
        List<BoardResponseDto> boards = memberService.getMemberBoards(memberId);
        return ResponseEntity.ok(boards);
    }

    // 스크랩 리스트 조회
    @GetMapping("/scraps")
    @Operation(summary = "스크랩 리스트 조회")
    public ResponseEntity<List<BoardResponseDto>> getScrapedBoards() {
        List<BoardResponseDto> scrapedBoards = memberService.getScrapedBoards();
        return ResponseEntity.ok(scrapedBoards);
    }

    // 내가 사용 중인 상품 조회
    @GetMapping("/my-products")
    @Operation(summary = "내가 사용 중인 상품 조회")
    public ResponseEntity<List<MyProductResponseDto>> getMyProducts() {
        List<MyProductResponseDto> myProducts = memberService.getMyProducts();
        return ResponseEntity.ok(myProducts);
    }

    // 타인이 사용 중인 상품 조회
    @GetMapping("/{memberId}/my-products")
    @Operation(summary = "타인이 사용 중인 상품 조회")
    public ResponseEntity<List<MyProductResponseDto>> getMemberProducts(@PathVariable Long memberId) {
        List<MyProductResponseDto> memberProducts = memberService.getMemberProducts(memberId);
        return ResponseEntity.ok(memberProducts);
    }

    // 사용 중인 상품 등록
    @PostMapping("/my-products")
    @Operation(summary = "사용 중인 상품 등록")
    public ResponseEntity<MyProductResponseDto> addMyProduct(@RequestBody MyProductRequestDto myProductRequestDto) {
        MyProductResponseDto myProductResponseDto = memberService.addMyProduct(myProductRequestDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(myProductResponseDto);
    }

    // 사용 중인 상품 삭제
    @DeleteMapping("/{myProductId}/my-products")
    @Operation(summary = "사용 중인 상품 삭제")
    public ResponseEntity<Void> deleteMyProduct(@PathVariable Long myProductId) {
        memberService.deleteMyProduct(myProductId);
        return ResponseEntity.ok().build();
    }

    // 사용 중인 상품 평가
    @PatchMapping("/my-products")
    @Operation(summary = "사용 중인 상품 평가")
    public ResponseEntity<MyProductResponseDto> evaluateMyProduct(@RequestBody MyProductRequestDto myProductRequestDto) {
        MyProductResponseDto myProductResponseDto = memberService.evaluateMyProduct(myProductRequestDto);
        return ResponseEntity.ok(myProductResponseDto);
    }

    // 사용 중인 상품의 활성화 상태 변경
    @PatchMapping("/my-products/{myProductId}/toggle-active")
    @Operation(summary = "사용 중인 상품의 활성화 상태 변경")
    public ResponseEntity<MyProductResponseDto> toggleProductActiveStatus(@PathVariable Long myProductId) {
        MyProductResponseDto responseDto = memberService.toggleProductActiveStatus(myProductId);
        return ResponseEntity.ok(responseDto);
    }
}

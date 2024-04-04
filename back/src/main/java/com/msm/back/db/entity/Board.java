package com.msm.back.db.entity;

import com.msm.back.common.BaseEntity;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Board extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member;

    @Column(length = 30, nullable = false)
    private String title;

    @Column(nullable = false, columnDefinition = "text")
    private String content;

    @Column(nullable = false)
    private Long viewCnt;

    @Column(nullable = false)
    private Long likeCnt;

    @Column(nullable = false)
    private Long commentCnt;

    @OneToMany(mappedBy = "board", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<BoardImage> boardImages = new ArrayList<>();

    @OneToMany(mappedBy = "board", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<Comment> commentList = new ArrayList<>();

    @OneToMany(mappedBy = "board", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<BoardLike> likeList = new ArrayList<>();

    @OneToMany(mappedBy = "board", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<Scrap> ScrapList = new ArrayList<>();

    public void addView() {
        this.viewCnt++;
    }

    public void addLike() {
        this.likeCnt++;
    }

    public void removeLike() {
        if (this.likeCnt > 0) {
            this.likeCnt--;
        }
    }

    public void addComment() {
        this.commentCnt++;
    }

    public void removeComment() {
        if (this.commentCnt > 0) {
            this.commentCnt--;
        }
    }
}
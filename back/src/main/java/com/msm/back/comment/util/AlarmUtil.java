package com.msm.back.comment.util;

import com.google.firebase.messaging.AndroidConfig;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.msm.back.db.entity.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class AlarmUtil {

    private final FirebaseMessaging firebaseMessaging;
    public void sendAlarm(Member fromMember, Member toMember, AlarmTypeEnum alarmTypeEnum, Long boardId) {
        String notificationToken = toMember.getNotificationToken();
        String fromNickname = fromMember.getNickname();
        String currentTime = LocalDateTime.now().toString();

        Map<String, String> data = new HashMap<>();
        data.put("id", boardId.toString());
        data.put("type", "community");
        data.put("time", currentTime);
        data.put("token", notificationToken);

        String title = "";
        String body = "";

        if (alarmTypeEnum.name().equals("POSTCOMMENT")) {
            title = "댓글 알림";
            body = fromNickname + "님이 게시글에 댓글을 남겼습니다";
        } else if (alarmTypeEnum.name().equals("LIKECOMMENT")) {
            title = "댓글 알림";
            body = fromNickname + "님이 댓글을 좋아합니다";
        } else if (alarmTypeEnum.name().equals("LIKEBOARD")) {
            title = "게시글 알림";
            body = fromNickname + "님이 게시글을 좋아합니다";
        }

        Message message = Message.builder()
                .setToken(notificationToken)
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(body)
                        .build())
                .putAllData(data)
                .setAndroidConfig(AndroidConfig.builder().setPriority(AndroidConfig.Priority.HIGH).build()) // 안드로이드 우선순위 설정
                .build();

        try {
            // FCM 메시지 전송
            String response = firebaseMessaging.send(message);
            System.out.println("메세지를 성공적으로 보냈습니다" + response);
        } catch (Exception e) {
            System.out.println("메세지를 보내지 못했습니다 " + e.getMessage());
        }
    }
}

package com.msm.back.remindAlarm;

import com.google.firebase.messaging.AndroidConfig;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.msm.back.remindAlarm.service.RemindAlarmService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
@Slf4j
public class RemindAlarmScheduler {

    private final FirebaseMessaging firebaseMessaging;
    private final RemindAlarmService remindAlarmService;
    // 매일 오후 9시마다 실행되도록 스케줄링
    @Scheduled(cron = "0 0 21 * * *")
//    @Scheduled(fixedRate = 1000)
    public void sendScheduledNotification() {
        List<String> notificationTokens = remindAlarmService.getNotificationTokens();

        for (String notificationToken: notificationTokens) {
            String currentTime = LocalDateTime.now().toString();

            Map<String, String> data = new HashMap<>();
            data.put("id", "0");
            data.put("type", "camera");
            data.put("time", currentTime);
            data.put("token", notificationToken);

            Message message = Message.builder()
                    .setToken(notificationToken)
                    .setNotification(Notification.builder()
                            .setTitle("피부 분석 리포트 리마인드")
                            .setBody("오늘 사진 촬영해서 피부 분석 리포트를 만들어주세요!")
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
}

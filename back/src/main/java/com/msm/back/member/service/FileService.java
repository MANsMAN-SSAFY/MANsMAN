package com.msm.back.member.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FileService {

    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucketName}")
    private String bucketName;

    public String uploadFile(MultipartFile multipartFile) {
        String fileUrl = "";
        try {
            // 파일을 임시 디렉토리에 저장한다
            File file = convertMultiPartToFile(multipartFile);
            String fileName = generateFileName(multipartFile);
            fileUrl = "https://" + "s3." + amazonS3.getRegionName() + ".amazonaws.com/" + bucketName + "/" + fileName;
            // S3 버킷에 파일을 업로드한다
            uploadFileToS3bucket(fileName, file);
            file.delete(); // 임시로 생성된 파일을 삭제한다
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fileUrl;
    }

    private File convertMultiPartToFile(MultipartFile file) throws IOException {
        File convertedFile = new File(file.getOriginalFilename());
        try (FileOutputStream fos = new FileOutputStream(convertedFile)) {
            fos.write(file.getBytes());
        }
        return convertedFile;
    }

    private String generateFileName(MultipartFile multiPart) {
        return UUID.randomUUID().toString() + "-" + multiPart.getOriginalFilename().replace(" ", "_");
    }

    private void uploadFileToS3bucket(String fileName, File file) {
        amazonS3.putObject(new PutObjectRequest(bucketName, fileName, file));
    }

    public void deleteFile(String fileUrl) {
        // URL에서 파일 이름 추출
        String fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
        // S3 버킷에서 파일 삭제
        amazonS3.deleteObject(new DeleteObjectRequest(bucketName, fileName));
    }
}
package com.dev.cotemate.domain.auth.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.Map;


@Tag(name = "Auth", description = "인증/인가 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/auth")
public class AuthController {

    @Operation(
            summary = "서버 Health Check API",
            description = "# [v1.0 (2025-12-03)](https://clumsy-seeder-416.notion.site/Health-Check-2be1197c19ed80579d53c6071794643e?source=copy_link)\n" +
                    "- 서버의 기본 상태를 확인하기 위한 API입니다.\n" +
                    "애플리케이션 정상 동작 여부, 버전 정보, 서버 시간을 반환합니다."
    )
    @GetMapping("/health")
    public Map<String, Object> health() {
        return Map.of(
                "status", "UP",
                "version", "1.0.0",
                "serverTime", LocalDateTime.now().toString()
        );
    }
}

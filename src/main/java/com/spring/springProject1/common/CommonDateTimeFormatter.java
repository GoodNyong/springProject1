package com.spring.springProject1.common;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class CommonDateTimeFormatter {
	//공용클래스(util)의 역할이기 때문에 public static을 씀. 실무에서도.
	public static String FormatDateTimeOne(LocalDateTime originaltime) {
		LocalDateTime now = LocalDateTime.now();
		
		long hours = Duration.between(originaltime, now).toHours();
		long days = ChronoUnit.DAYS.between(originaltime.toLocalDate(), now.toLocalDate());
		//소수점 버리는 거라 1시간50분 됐으면 "1시간 전"으로 처리됨
		//LocalDate는 시/분/초 가 없어서 Duration 연산 불가능 => "UnsupportedTemporalTypeException: Unsupported unit: Seconds" 예외 발생
		//ChronoUnit도 시/분/초 아예 고려 안하는 거라 2일+23시간+59분+59초까지 "2일전"으로 뜸
		
		if(hours < 1) return "방금 전";
		else if (hours < 24) return hours + "시간 전";
		else if (days <= 3) return days + "일 전";
		else {
			if(originaltime.getYear() == now.getYear()) {
				return originaltime.format(DateTimeFormatter.ofPattern("MM-dd"));
				//DateTimeFormatter.ofPattern("MM-dd")는 포맷팅 방법을 만드는 함수
				//created_at.format(...)은 그 포맷 방법을 실제로 적용하는 함수
				//즉, DateTimeFormatter f = DateTimeFormatter.ofPattern("MM-dd");
				//String result = created_at.format(f); 이런 뜻임
				//created_at은 LocalDateTime 객체지, DateTimeFormatter 클래스가 아님
				//그러니까 그 안에 .DateTimeFormatter라는 건 존재할 수가 없음
			} else {
				return originaltime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
			}
		}
	}
	
	public static String FormatDateTimeTwo(LocalDateTime originaltime) {
    LocalDate today = LocalDate.now();
    if (originaltime.toLocalDate().isEqual(today)) {
        return originaltime.format(DateTimeFormatter.ofPattern("HH:mm"));
    } else {
        return originaltime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }
	}
	
	public static String FormatDateTimeThree(LocalDateTime originaltime) {
			return originaltime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
	}
}

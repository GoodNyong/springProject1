package com.spring.springProject1.common;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateTimeAgoFormatter {
	//공용클래스(util)의 역할이기 때문에 public static을 씀. 실무에서도.
	public static String FormatDateTimeAgo(LocalDateTime created_at) {
		LocalDateTime now = LocalDateTime.now();
		
		long hours = Duration.between(created_at, now).toHours();
		long days = Duration.between(created_at.toLocalDate(), now.toLocalDate()).toDays();
		//소수점 버리는 거라 1시간50분 됐으면 "1시간 전"으로 처리됨
		
		if(hours < 1) return "방금 전";
		else if (hours < 24) return hours + "시간 전";
		else if (days <= 3) return days + "일 전";
		else {
			if(created_at.getYear() == now.getYear()) {
				return created_at.format(DateTimeFormatter.ofPattern("MM-dd"));
				//DateTimeFormatter.ofPattern("MM-dd")는 포맷팅 방법을 만드는 함수
				//created_at.format(...)은 그 포맷 방법을 실제로 적용하는 함수
				//즉, DateTimeFormatter f = DateTimeFormatter.ofPattern("MM-dd");
				//String result = created_at.format(f); 이런 뜻임
				//created_at은 LocalDateTime 객체지, DateTimeFormatter 클래스가 아님
				//그러니까 그 안에 .DateTimeFormatter라는 건 존재할 수가 없음
			} else {
				return created_at.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
			}
		}
	}
}

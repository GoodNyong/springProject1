package com.spring.springProject1.common;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageConfig;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

@Service
public class ProjectProvide {

	// 파일 저장하는 메소드 (업로드파일명, 저장파일명, 저장경로)
	public void writeFile(MultipartFile fName, String sFileName, String urlPath) throws IOException {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+urlPath+"/");
		
		FileOutputStream fos = new FileOutputStream(realPath + sFileName);
		
		if(fName.getBytes().length != -1) {
			fos.write(fName.getBytes());
		}
		fos.flush();
		fos.close();
	}

	// 파일 삭제처리
	public void deleteFile(String photo, String urlPath) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+urlPath+"/");
		
		File file = new File(realPath + photo);
		if(file.exists()) file.delete();
	}

	// 파일명 중복방지를 위한 처리1
	public String saveFileName(String oFileName) {
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
		return sdf.format(date) + "_" + oFileName;
	}
	
	// 파일명 중복방지를 위한 처리2
	public String newNameCreate(int len) {
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmm");
		String newName = sdf.format(date);
		newName += RandomStringUtils.randomAlphanumeric(len) + "_";
		return newName;
	}

	// QR Code 생성하기
	public void qrCodeCreate(String qrCodeName, String qrCodeImage, String urlPath) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+urlPath+"/");
		
		try {
			qrCodeImage = new String(qrCodeImage.getBytes("UTF-8"), "ISO-8859-1");
			
			QRCodeWriter qrCodeWriter = new QRCodeWriter();
			BitMatrix bitMatrix = qrCodeWriter.encode(qrCodeImage, BarcodeFormat.QR_CODE, 200, 200);
			
			int qrCodeColor = 0xFF000000;
			int qrCodeBackColor = 0xFFFFFFFF;
			
			MatrixToImageConfig matrixToImageConfig = new MatrixToImageConfig(qrCodeColor, qrCodeBackColor);
			BufferedImage bufferedImage = MatrixToImageWriter.toBufferedImage(bitMatrix, matrixToImageConfig);
			
			ImageIO.write(bufferedImage, "png", new File(realPath + qrCodeName + ".png"));
		} catch (IOException e) {
			e.printStackTrace();
		} catch (WriterException e) {
			e.printStackTrace();
		}
	}

	
}

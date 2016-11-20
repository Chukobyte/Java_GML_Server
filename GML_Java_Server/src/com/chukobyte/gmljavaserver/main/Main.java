package com.chukobyte.gmljavaserver.main;

import java.io.IOException;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

public class Main {
	public static final int PORT = 6510;
	public static final Logger logger = LogManager.getLogger(Main.class); 
	public static void main(String[] args) {
		Server server = new Server(PORT);
		System.out.println("Starting server...");
		
		try {
			server.launch();
			System.out.println("Server launched");
			logger.info("Server launched log4j");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}

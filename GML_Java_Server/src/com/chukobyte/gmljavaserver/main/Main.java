package com.chukobyte.gmljavaserver.main;

import java.io.IOException;

public class Main {
	public static final int PORT = 6510;
	public static void main(String[] args) {
		Server server = new Server(PORT);
		System.out.println("Starting server...");
		
		try {
			server.launch();
			System.out.println("Server launched");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}

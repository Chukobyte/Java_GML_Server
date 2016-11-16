package com.chukobyte.gmljavaserver.main;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;

public class Server implements Runnable {
	private ServerSocket serverSocket;
	//private static GameBoard gameBoard;
	private static int playerNumber = 0;
	private static HashMap<String, Player> players = new HashMap<String, Player>();
	private boolean running = false;
	private int port;
	private Thread thread;
	private static GameBoard gameBoard = null;

	public Server(int port) {
		this.port = port;
	}

	// Launch the server.
	public void launch() throws IOException {
		serverSocket = new ServerSocket(port);
		gameBoard = new GameBoard();
		running = true;
		thread = new Thread(this);
		thread.start();
	}

	public void run() {
		while (running) {
			try {
				Socket socket = serverSocket.accept();
				String playerUserId = "Player" + playerNumber++;
				Player newPlayer = new Player(playerUserId); //assigns player and increment player number
				ClientHandler clientHandler = new ClientHandler(socket, newPlayer, gameBoard);
				clientHandler.launch();
				players.put(playerUserId, newPlayer);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	// Shutdown the server.
	public void shutdown() throws IOException {
		running = false;
		serverSocket.close();
	}

	// Return true if the server is running.
	public boolean isRunning() {
		return running;
	}

}

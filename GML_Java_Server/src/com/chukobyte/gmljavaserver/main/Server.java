package com.chukobyte.gmljavaserver.main;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Server implements Runnable {
	private ServerSocket serverSocket;
	private static int playerNumber = 0;
	//private static HashMap<String, Player> players = new HashMap<String, Player>();
	private static HashMap<String, ClientHandler> clients = new HashMap<String, ClientHandler>();
	private String[] chatLog = null;
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
				clients.put(playerUserId, clientHandler); //playerUserId is assigned to client handler key
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	//Static methods to access Server object for now
	public static void updateChatLog() {
		Iterator it = clients.entrySet().iterator();
		while(it.hasNext()) {
			Map.Entry pair = (Map.Entry)it.next();
			System.out.println(pair.getKey() + "=" + pair.getValue());
		}
	}
	
	public static String printLoggedInClients() {
		JSONObject json = new JSONObject();
		JSONArray jsArray = new JSONArray();
		Iterator it = clients.entrySet().iterator();
		try{
		while(it.hasNext()) {
			JSONObject jo = new JSONObject();
			Map.Entry pair = (Map.Entry)it.next();
			ClientHandler client  = (ClientHandler) pair.getValue();
			String mapKey = (String) pair.getKey();
			String mapValue = client.getPlayer().getName();			
			String mapText = mapKey + "=" + mapValue;
			System.out.println(mapText);
			jo.put("user_id", mapKey);
			jo.put("player_name", mapValue);
			jsArray.put(jo);
		}
		json.put("clients", jsArray);
		System.out.println(json.toString());
		} catch(JSONException je) {
			je.printStackTrace();
		}
		return json.toString();
	}
	
	public static void removeClientHandler(String userId) {
		clients.remove(userId);
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

package com.chukobyte.gmljavaserver.main;

import java.awt.List;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.omg.PortableInterceptor.USER_EXCEPTION;

public class Server implements Runnable {
	private ServerSocket serverSocket;
	private static int playerNumber = 0;
	// private static HashMap<String, Player> players = new HashMap<String,
	// Player>();
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
				Player newPlayer = new Player(playerUserId); // assigns player
																// and increment
																// player number
				ClientHandler clientHandler = new ClientHandler(socket, newPlayer, gameBoard);
				clientHandler.launch();
				clients.put(playerUserId, clientHandler); // playerUserId is
															// assigned to
															// client handler
															// key
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public static void updateGameClients() throws IOException, JSONException {
		Iterator it = clients.entrySet().iterator();
		String jsonText = gameBoard.getGameBoardJson();
		while (it.hasNext()) {
			Map.Entry<String, ClientHandler> pair = (Map.Entry<String, ClientHandler>) it.next();
			ClientHandler currentClient = pair.getValue();
			GMLOutputStream out = currentClient.getGMLOutStream();

			out.writeS16(MessageConstants.MAGIC_NUMBER);
			JSONObject json = new JSONObject();
			json.put("message_id", MessageConstants.UPDATE_RESPONSE);
			//out.writeS8(MessageConstants.UPDATE_RESPONSE);
			JSONObject contentJson = new JSONObject(jsonText);
			json.put("content", contentJson);
			out.writeString(jsonText);
			out.flush();
		}
	}

	public static void createUser(String userId, String playerName, short row, short col, ClientHandler clientToExclude)
			throws IOException, JSONException {
		Iterator it = clients.entrySet().iterator();
		JSONObject contentJson = new JSONObject();
		try {
			contentJson.put("user_id", userId);
			contentJson.put("player_name", playerNumber);
			contentJson.put("row", row);
			contentJson.put("col", col);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		while (it.hasNext()) {
			Map.Entry<String, ClientHandler> pair = (Map.Entry<String, ClientHandler>) it.next();
			ClientHandler currentClient = pair.getValue();
			if (!currentClient.equals(clientToExclude)) {
				GMLOutputStream out = currentClient.getGMLOutStream();
				out.writeS16(MessageConstants.MAGIC_NUMBER);
				JSONObject json = new JSONObject();
				json.put("message_id", MessageConstants.CREATE_USER_RESPONSE);
				json.put("content", contentJson);
				out.writeString(json.toString());
				//out.writeS8(MessageConstants.CREATE_USER_RESPONSE);
				//out.writeString(json.toString());
				// out.writeString(userId);
				out.flush();
			}
		}
	}

	public static void deleteUserAll(String userId) throws IOException, JSONException {
		Iterator it = clients.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry<String, ClientHandler> pair = (Map.Entry<String, ClientHandler>) it.next();
			ClientHandler currentClient = pair.getValue();
			GMLOutputStream out = currentClient.getGMLOutStream();

			out.writeS16(MessageConstants.MAGIC_NUMBER);
			JSONObject json = new JSONObject();
			json.put("message_id", MessageConstants.DELETE_USER_RESPONSE);
			JSONObject contentJson = new JSONObject();
			contentJson.put("user_id", userId);
			json.put("content", contentJson);
			out.writeString(json.toString());
			out.flush();
		}
	}

	public static ArrayList<ClientHandler> getServerClients() {
		Iterator it = clients.entrySet().iterator();
		ArrayList<ClientHandler> clientList = new ArrayList<ClientHandler>();
		while (it.hasNext()) {
			Map.Entry pair = (Map.Entry) it.next();
			System.out.println("key: " + pair.getKey().toString()); // debug
			ClientHandler client = (ClientHandler) pair.getValue();
			clientList.add(client);
			try {
				RequestHandler.handleRequest(client, client.getGMLInStream(), client.getGMLOutStream());
			} catch (JSONException je) {
				je.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return clientList;
	}

	// Static methods to access Server object for now
	public static void updateChatLog() {
		Iterator it = clients.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry pair = (Map.Entry) it.next();
			System.out.println(pair.getKey() + "=" + pair.getValue());
		}
	}

	public static String printLoggedInClients() {
		JSONObject json = new JSONObject();
		JSONArray jsArray = new JSONArray();
		Iterator it = clients.entrySet().iterator();
		try {
			while (it.hasNext()) {
				JSONObject jo = new JSONObject();
				Map.Entry pair = (Map.Entry) it.next();
				ClientHandler client = (ClientHandler) pair.getValue();
				String mapKey = (String) pair.getKey();
				String mapValue = client.getPlayer().getName();
				String mapText = mapKey + "=" + mapValue;
				System.out.println(mapText);
				jo.put("user_id", mapKey);
				jo.put("player_name", mapValue);
				jo.put("panel_row", client.getPlayer().getPanelRow());
				jo.put("panel_col", client.getPlayer().getPanelCol());
				jsArray.put(jo);
			}
			json.put("clients", jsArray);
			System.out.println(json.toString());
		} catch (JSONException je) {
			je.printStackTrace();
		}
		return json.toString();
	}

	public static void removeClientHandler(String userId) {
		try {
			removePlayerFromCurrentPanel(userId);
			clients.remove(userId);
			deleteUserAll(userId);
		} catch (JSONException je) {
			je.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void removePlayerFromCurrentPanel(String userId) {
		try {
			System.out.println("Board before: \n" + gameBoard.getGameBoardJson()); // debug
			// removes player ref from gameboard
			ClientHandler client = clients.get(userId);
			short row = client.getPlayer().getPanelRow();
			short col = client.getPlayer().getPanelCol();

			JSONObject panelObj = new JSONObject(gameBoard.getGameBoard()[row][col]);
			panelObj.put("player", "");
			gameBoard.setGameBoardPanel(row, col, panelObj.toString());
			System.out.println("Board after: \n" + gameBoard.getGameBoardJson()); // debug
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void addPlayerToPanel(String userId, short newRow, short newCol) {
		try {
			// removes player ref from gameboard
			ClientHandler client = clients.get(userId);
			short currentRow = client.getPlayer().getPanelRow();
			short currentCol = client.getPlayer().getPanelCol();

			removePlayerFromCurrentPanel(userId); // Remove from current panel
													// first
			JSONObject panelObj = new JSONObject(gameBoard.getGameBoard()[newRow][newCol]);
			panelObj.put("player", userId);
			client.getPlayer().setPanelRowCol(newRow, newCol);
			gameBoard.setGameBoardPanel(newRow, newCol, panelObj.toString());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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

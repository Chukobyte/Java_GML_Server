package com.chukobyte.gmljavaserver.main;

import java.awt.List;
import java.io.IOException;
import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

public class RequestHandler {
		
	public static void handleRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		short request = in.readS8();
		boolean flushOut = true;
		System.out.println("Request = " + request);
		switch (request) {
			case MessageConstants.UPDATE_REQUEST: handleUpdateRequest(client, in, out); flushOut = false; break;
			case MessageConstants.USER_ID_REQUEST: handleUserIdRequest(client, in, out); break;
			case MessageConstants.USER_NAME_SEND_REQUEST: handleUserNameSendRequest(client, in, out); break;
			case MessageConstants.SHUFFLE_GAME_BOARD_REQUEST: handleShuffleGameBoardRequest(client, in, out); break;
			case MessageConstants.USER_MOVE_REQUEST: handleUserMoveRequest(client, in, out); break;
			case MessageConstants.CHAT_LOG_SEND_REQUEST: handleChatLogSendRequest(client, in, out); break;
			case MessageConstants.GET_USERS_ONLINE_REQUEST: handleGetUsersOnlineRequest(client, in, out); break;
			default: System.out.println("Unknown request"); break;
		}
		if(flushOut) {
			out.flush();
		}
	}
	
	
	private static void prepareResponse(GMLOutputStream out, byte messageId) throws IOException {
		out.writeS16(MessageConstants.MAGIC_NUMBER);
		out.writeS8(messageId);
	}
	
	private static void handleGetUsersOnlineRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		String jsonText = Server.printLoggedInClients();
		prepareResponse(out, MessageConstants.GET_USERS_ONLINE_RESPONSE);
		out.writeString(jsonText);
	}
	
	private static void handleChatLogSendRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		String chatLog = in.readString();
		System.out.println(client.getPlayer().getName() + ": " + chatLog);
		prepareResponse(out, MessageConstants.CHAT_LOG_SEND_RESPONSE);
	}
	
	private static void handleUserMoveRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		String direction = in.readString();
		prepareResponse(out, MessageConstants.USER_MOVE_RESPONSE);
		short newRow = -1;
		short newCol = -1;
		switch(direction) {
			case "left":
				newRow = client.getPlayer().getPanelRow();
				newCol = (short) (client.getPlayer().getPanelCol() - 1);
				Server.addPlayerToPanel(client.getPlayer().getUserId(), newRow, newCol);
				break;
			case "right":
				newRow = client.getPlayer().getPanelRow();
				newCol = (short) (client.getPlayer().getPanelCol() + 1);
				Server.addPlayerToPanel(client.getPlayer().getUserId(), newRow, newCol);
				break;
			case "up":
				newRow = (short) (client.getPlayer().getPanelRow() - 1);
				newCol = client.getPlayer().getPanelCol();
				Server.addPlayerToPanel(client.getPlayer().getUserId(), newRow, newCol);
				break;
			case "down":
				newRow = (short) (client.getPlayer().getPanelRow() + 1);
				newCol = client.getPlayer().getPanelCol();
				Server.addPlayerToPanel(client.getPlayer().getUserId(), newRow, newCol);
				break;
			default:
				break;
		}
		String response = client.getPlayer().getUserId() + " moved " + direction + "!";
		System.out.println(response);
		out.writeString(response);
		out.writeS16(newRow);
		out.writeS16(newCol);
	}
	
	private static void handleShuffleGameBoardRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		prepareResponse(out, MessageConstants.SHUFFLE_GAME_BOARD_RESPONSE);
		client.getGameBoard().shuffleGameBoard(); //shuffle game board
		System.out.println(client.getPlayer().getUserId() + " Shuffled Board!");
		out.writeString("Sucess");
	}
	
	private static void handleUserIdRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		prepareResponse(out, MessageConstants.USER_ID_RESPONSE);
		out.writeString(client.getPlayer().getUserId());
		
		//Assigns a player to an empty Panel
		String[][] panelArray = client.getGameBoard().getGameBoard();
		boolean playerFound = false;
		//Need to send empty panel coords
		for(short i = 0; i < client.getGameBoard().getGameBoard().length; i++) {
			for(short j = 0; j < client.getGameBoard().getGameBoard().length; j++) {
				try {
					JSONObject boardJson = new JSONObject(panelArray[i][j]);
					System.out.println(boardJson.toString());
					String playerSlot = boardJson.getString("player");
					if(playerSlot.equals("") && !playerFound) {
						System.out.println("row: " + i + " | col: " + j);
						out.writeS16(i); //row
						out.writeS16(j); //col
						client.getPlayer().setPanelRowCol(i, j);
						boardJson.put("player", client.getPlayer().getUserId());
						client.getGameBoard().setGameBoardPanel(i, j, boardJson.toString());
						System.out.println("New Panel Json:\n" + panelArray[i][j]);
						playerFound = true;
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
	}
	
	private static void handleUserNameSendRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		String name = in.readString();
		client.getPlayer().setName(name);
		System.out.println("Name : " + name);
		prepareResponse(out, MessageConstants.USER_NAME_SEND_RESPONSE);
		out.writeString("Sucess");
	}
	
	private static void handleUpdateRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		System.out.println("Initial Update requested from " + client.getPlayer().getUserId());
		Server.updateGameClients(); //loops through game clients in Server class for now
	}
	
	
}

package com.chukobyte.gmljavaserver.main;

import java.io.IOException;

public class RequestHandler {
		
	public static void handleRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		short request = in.readS8();
		System.out.println("Request = " + request);
		switch (request) {
			case MessageConstants.UPDATE_REQUEST: handleUpdateRequest(client, in, out); break;
			case MessageConstants.USER_ID_REQUEST: handleUserIdRequest(client, in, out); break;
			case MessageConstants.USER_NAME_SEND_REQUEST: handleUserNameSendRequest(client, in, out); break;
			case MessageConstants.SHUFFLE_GAME_BOARD_REQUEST: handleShuffleGameBoardRequest(client, in, out); break;
			case MessageConstants.USER_MOVE_REQUEST: handleUserMoveRequest(client, in, out); break;
			case MessageConstants.CHAT_LOG_SEND_REQUEST: handleChatLogSendRequest(client, in, out); break;
			case MessageConstants.GET_USERS_ONLINE_REQUEST: handleGetUsersOnlineRequest(client, in, out); break;
			default: System.out.println("Unknown request"); break;
		}
		out.flush();
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
		System.out.println("chat log: " + chatLog);
		prepareResponse(out, MessageConstants.CHAT_LOG_SEND_RESPONSE);
	}
	
	private static void handleUserMoveRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		String direction = in.readString();
		prepareResponse(out, MessageConstants.USER_MOVE_RESPONSE);
		String response = client.getPlayer().getUserId() + " moved " + direction + "!";
		System.out.println(response);
		out.writeString(response);
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
	}
	
	private static void handleUserNameSendRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		String name = in.readString();
		client.getPlayer().setName(name);
		System.out.println("Name : " + name);
		prepareResponse(out, MessageConstants.USER_NAME_SEND_RESPONSE);
		out.writeString("Sucess");
	}
	
	private static void handleUpdateRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		System.out.println("Update requested");
		prepareResponse(out, MessageConstants.UPDATE_RESPONSE);
		String jsonText = client.getGameBoard().getGameBoardJson();
		System.out.println(jsonText);
		out.writeString(jsonText);
	}
}

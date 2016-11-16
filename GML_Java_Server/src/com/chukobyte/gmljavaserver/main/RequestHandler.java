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
			default: System.out.println("Unknown request"); break;
		}
		out.flush();
	}
	
	//public static void handleRequest(GMLInputStream in, GMLOutputStream out) throws IOException {
	//	handleRequest((short) 0, in, out);
	//}
	
	
	private static void prepareResponse(GMLOutputStream out, short size) throws IOException {
		out.writeS32(MessageConstants.MAGIC_NUMBER);
		out.writeS16(size);
	}
	
	private static void handleUserMoveRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		String direction = in.readString();
		out.writeS16(MessageConstants.MAGIC_NUMBER);
		out.writeS8(MessageConstants.USER_MOVE_RESPONSE);
		String response = client.getPlayer().getUserId() + " moved " + direction + "!";
		System.out.println(response);
		out.writeString(response);
	}
	
	private static void handleShuffleGameBoardRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		out.writeS16(MessageConstants.MAGIC_NUMBER);
		out.writeS8(MessageConstants.SHUFFLE_GAME_BOARD_RESPONSE);
		client.getGameBoard().shuffleGameBoard(); //shuffle game board
		System.out.println(client.getPlayer().getUserId() + " Shuffled Board!");
		out.writeString("Sucess");
	}
	
	private static void handleUserIdRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		//Need to bind userId to Player Object
		out.writeS16(MessageConstants.MAGIC_NUMBER);
		out.writeS8(MessageConstants.USER_ID_RESPONSE);
		out.writeString(client.getPlayer().getUserId());
	}
	
	private static void handleUserNameSendRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		String name = in.readString();
		client.getPlayer().setName(name);
		System.out.println("Name : " + name);
		out.writeS16(MessageConstants.MAGIC_NUMBER);
		out.writeS8(MessageConstants.USER_NAME_SEND_RESPONSE);
		out.writeString("Sucess");
	}
	
	private static void handleUpdateRequest(ClientHandler client, GMLInputStream in, GMLOutputStream out) throws IOException {
		System.out.println("Update requested");
		out.writeS16(MessageConstants.MAGIC_NUMBER);
		out.writeS8(MessageConstants.UPDATE_RESPONSE); //message id
		String jsonText = client.getGameBoard().getGameBoardJson();
		System.out.println(jsonText);
		out.writeString(jsonText);
	}
}

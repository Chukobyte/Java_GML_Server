package com.chukobyte.gmljavaserver.main;

public class MessageConstants {
	//REQUEST = n, RESPONSE = In * 2
	//message ids
	public static final short DEFAULT = 0;
	public static final short UPDATE_ALL_REQUEST = -122; //Internal Request to update all clients
	public static final byte USER_ID_RESPONSE = 6;
	public static final short USER_ID_REQUEST = 3;
	public static final short UPDATE_REQUEST = 8;
	public static final byte USER_NAME_SEND_RESPONSE = 22;
	public static final short USER_NAME_SEND_REQUEST = 11;
	public static final byte CHAT_LOG_SEND_RESPONSE = 88;
	public static final short CHAT_LOG_SEND_REQUEST = 44;
	public static final byte UPDATE_RESPONSE = 16;
	public static final byte SHUFFLE_GAME_BOARD_RESPONSE = 24;
	public static final short SHUFFLE_GAME_BOARD_REQUEST = 12;
	public static final byte USER_MOVE_RESPONSE = 64;
	public static final short USER_MOVE_REQUEST = 32;
	public static final byte GET_USERS_ONLINE_RESPONSE = 66;
	public static final short GET_USERS_ONLINE_REQUEST = 33;
	public static final short MAGIC_NUMBER = 12313;
}
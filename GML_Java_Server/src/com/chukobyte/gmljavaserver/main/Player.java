package com.chukobyte.gmljavaserver.main;

public class Player {
	private String name = null;
	private String userId = null;
	
	public Player(String userId) {
		this.userId = userId;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
	public String getUserId() {
		return userId;
	}
	
}

package com.chukobyte.gmljavaserver.main;

public class Player {
	private String name = null;
	private String userId = null;
	private short panelRow = -4;
	private short panelCol = -4;
	
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
	
	public short getPanelRow() {
		return panelRow;
	}
	
	public short getPanelCol() {
		return panelCol;
	}
	
	public void setPanelRowCol(short row, short col) {
		panelRow = row;
		panelCol = col;
	}
	
}

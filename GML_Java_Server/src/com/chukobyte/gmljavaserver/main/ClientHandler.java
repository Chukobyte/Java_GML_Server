package com.chukobyte.gmljavaserver.main;

import java.io.EOFException;
import java.io.IOException;
import java.net.Socket;
import java.net.SocketException;

public class ClientHandler implements Runnable{

	private Socket socket;
	private GMLInputStream in;
	private GMLOutputStream out;
	private Thread thread;
	private boolean running = false;
	private Player player = null;
	private GameBoard gameBoard = null;
	
	public ClientHandler(Socket socket, Player player, GameBoard gameBoard) throws SocketException {
		thread = new Thread(this);
		this.socket = socket;
		this.socket.setTcpNoDelay(true);
		this.player = player;
		this.gameBoard = gameBoard;
	}
	
	public void launch() throws IOException {
		in = new GMLInputStream(socket.getInputStream());
		out = new GMLOutputStream(socket.getOutputStream());
		running = true;
		thread.start();
	}
	
	public void printOutDebug() {
		String text = "";
		System.out.println(text);
	}
	
	public Player getPlayer() {
		return player;
	}
	
	public GameBoard getGameBoard() {
		return gameBoard;
	}
	
	@Override
	public void run() {
		while (running) {
			try {
				int other = in.readS8(); //reads -34
				in.skipPassHeader();
				int magicNumber = in.readS16();
				if (magicNumber != MessageConstants.MAGIC_NUMBER) {
					throw new Exception("Message did not start with the magic number, but: " + magicNumber + ".");
				}
				RequestHandler.handleRequest(this, in, out);
			} catch(SocketException se) {
				//se.printStackTrace();
				System.out.println(player.getName() + " has disconnected (SE)");
				running = false;
				Server.removeClientHandler(getPlayer().getUserId());
			} catch(EOFException eof)  {
				//eof.printStackTrace();
				System.out.println(player.getName() + " has disconnected (EOF)");
				running = false;
				Server.removeClientHandler(getPlayer().getUserId());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

}

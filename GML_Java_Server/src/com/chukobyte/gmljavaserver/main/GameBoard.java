package com.chukobyte.gmljavaserver.main;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Random;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class GameBoard {

	private static String[][] boardArray = null;
	
	public String[][] getGameBoard() {
		return boardArray;
	}

	public GameBoard() {
		String str = readJsonFile("C:\\temp\\array_test.json");
		JSONObject json;
		try {
			json = new JSONObject(str);
			JSONArray gridArray = (JSONArray) json.get("grid_array");
			int gridSqu = (int) Math.sqrt(gridArray.length());
			//System.out.println(gridSqu);
			boardArray = new String[gridSqu][gridSqu];
			// loop through array to define two dimensionsal array
			for (int i = 0; i < gridArray.length(); i++) {
				JSONObject jsonArr = (JSONObject) gridArray.get(i);
				int row = jsonArr.getInt("row");
				int col = jsonArr.getInt("col");
				String val = jsonArr.getString("val");
				boardArray[row][col] = val;
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void shuffleGameBoard() {
		for(int i = 0; i < 3; i++) {
			for(int j = 0; j < 3; j++) {
				boardArray[i][j] = getRandomColor();
			}
		}
	}
	
	private static String getRandomColor() {
		String colorString = "";
		Random random = new Random();
		int index = random.nextInt(4);
		
		switch(index) {
			case 0:
				colorString = "c_red";
				break;
			case 1:
				colorString = "c_white";
				break;
			case 2:
				colorString = "c_blue";
				break;
			case 3:
				colorString = "c_purple";
				break;
			default:
				break;
		}
		
		return colorString;
	}
	
	public void printGameBoardArray() {
		for (int i = 0; i < 3; i++) {
			for(int j = 0; j < 3; j++) {
				System.out.println("[" + i + "][" + j + "] = " + boardArray[i][j]);
			}	
		}
	}
	
	public String getGameBoardJson() {
		String jsonText = "";
		try {
			JSONObject json = new JSONObject();
			JSONArray jsonArray;
			jsonArray = new JSONArray(getGameBoard());
			int arrayIndex = 0;
			
			// Creates JSON object then converts to string
			for(int i = 0; i < 3; i++) {
				for(int j = 0; j < 3; j++) {
					JSONObject jo = new JSONObject();
					jo.put("row", i);
					jo.put("col", j);
					jo.put("val", boardArray[i][j]);
					jsonArray.put(arrayIndex, jo);
					arrayIndex++;
				}
			}
			json.put("grid_array", jsonArray);
			jsonText = json.toString();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return jsonText;
	}
	
	private String readJsonFile(String fileLocation) {
		String jsonText = "";
		BufferedReader br = null;

		try {

			String sCurrentLine;

			br = new BufferedReader(new FileReader(fileLocation));

			while ((sCurrentLine = br.readLine()) != null) {
				jsonText += sCurrentLine + "\n";
			}
			// System.out.println(jsonText);

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (br != null)
					br.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}

		return jsonText;
	}

}

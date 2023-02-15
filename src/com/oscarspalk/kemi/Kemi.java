package com.oscarspalk.kemi;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

public class Kemi {
	static List<Element> elements = new ArrayList<>();

	public static String load(String path) {
		try {
			byte[] data = Files.readAllBytes(Paths.get(path));
			String content = new String(data);
			JSONObject jsonElements = new JSONObject(content);
			JSONArray elsJson = jsonElements.getJSONArray("elements");
			for (int i = 0; i < elsJson.length(); i++) {
				JSONObject element = elsJson.getJSONObject(i);
				elements.add(new Element(element.getString("name"), element.getString("symbol"),
						element.getDouble("atomic_mass")));
			}
			return "Success";
		} catch (Exception e) {
			return e.getMessage();
		}
	}

	public static List<String> seperateElements(String element) {
		List<String> elementsSplitted = new ArrayList<>();
		int strLength = element.length();
		boolean containsDouble = false;
		int backtrack = 0;

		for (int i = 0; i < strLength; i++) {
			if ((i + 1 < strLength) && element.charAt(i + 1) == '_') {
				String rest = element.substring(i - backtrack, strLength);
				elementsSplitted.add(rest);
				return elementsSplitted;
			}
			if ((i + 1 < strLength) && Character.isUpperCase(element.charAt(i + 1)) || i + 1 == strLength) {
				StringBuilder whatToAdd = new StringBuilder();
				for (int j = 0; j < backtrack + 1; j++) {
					whatToAdd.insert(0, element.charAt(i - j));
				}
				elementsSplitted.add(whatToAdd.toString());
				containsDouble = true;
				backtrack = 0;
			} else {
				backtrack++;
			}

		}
		if (!containsDouble) {
			elementsSplitted.add(element);
			return elementsSplitted;
		}
		return elementsSplitted;

	}

	public static ElementWithAmount extractElement(String str) {
		String[] elementsAndAmounts = str.split("__");
		int amount = 0;
		String symbol = "";
		if (elementsAndAmounts.length == 1) {
			symbol = str;
			amount = 1;
		} else {
			symbol = elementsAndAmounts[0];
			String[] potensSplitted = elementsAndAmounts[1].split("\\^");
			if (potensSplitted.length == 1) {
				amount = Integer.parseInt(potensSplitted[0]);
			} else {
				int normalAmount = Integer.parseInt(potensSplitted[0]);
				int multiplier = Integer.parseInt(potensSplitted[1]);
				amount = normalAmount * multiplier;
			}
		}

		for (Element element : elements) {
			if (element.symbol.equals(symbol)) {
				return new ElementWithAmount(element, amount);
			}
		}
		return null;
	}

	public static Molecule extractMolecule(String input) {
		List<ElementWithAmount> buildElements = new ArrayList<>();
		String[] differentElements = input.split("\\*");
		for (String element : differentElements) {
			List<String> subElements = seperateElements(element);
			for (String subString : subElements) {
				buildElements.add(extractElement(subString));
			}
		}
		return new Molecule(buildElements);
	}

	public static String afstem(String leftSide, String rightSide, int depth) {
		Reaction reaction = new Reaction(leftSide, rightSide);
		return reaction.balance(depth);
	}

	public static double M(String molecule) {
		double totalMass = 0.0;
		Molecule builtOfElements = extractMolecule(molecule);
		for (ElementWithAmount elementWithAmount : builtOfElements.getElements()) {
			totalMass += elementWithAmount.amount * elementWithAmount.atomic_mass;
		}
		return totalMass;
	}
	
	public static double m(double mol, String molecule) {
		return mol*M(molecule);
	}
	
	public static double n(double gram, String molecule) {
		return gram/M(molecule);
	}
}

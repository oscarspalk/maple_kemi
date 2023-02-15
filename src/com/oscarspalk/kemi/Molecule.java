package com.oscarspalk.kemi;

import java.util.ArrayList;
import java.util.List;

public class Molecule {
	List<ElementWithAmount> elements;

	public Molecule(List<ElementWithAmount> elements) {
		this.elements = elements;
	}

	public Molecule() {
		this.elements = new ArrayList<>();
	}

	public void addElement(ElementWithAmount element) {
		this.elements.add(element);
	}

	public List<ElementWithAmount> getElements() {
		return this.elements;
	}

	public String toString() {
		StringBuilder molecule = new StringBuilder();
		int len = this.elements.size();
		for (int i = 0; i < len; i++) {
			ElementWithAmount element = this.elements.get(i);
			if (element.amount == 1) {
				molecule.append(element.symbol);
			} else {
				if (i+1 < len) {
					molecule.append(element.symbol).append("__").append(element.amount).append("*");
				} else {
					molecule.append(element.symbol).append("__").append(element.amount);
				}
			}
		}
		return molecule.toString();
	}
}

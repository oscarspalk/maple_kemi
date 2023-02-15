package com.oscarspalk.kemi;

public class ElementWithAmount extends Element {
	final int amount;
	public ElementWithAmount(Element element, int amount) {
		super(element.name,element.symbol , element.atomic_mass);
		this.amount = amount;
	}
}

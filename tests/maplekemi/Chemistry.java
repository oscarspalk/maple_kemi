package maplekemi;

import com.oscarspalk.kemi.Kemi;
import com.oscarspalk.kemi.Molecule;
import com.oscarspalk.kemi.Reaction;

import static junit.framework.Assert.assertEquals;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

public class Chemistry {
	final String path = "C:/Users/knudi/eclipse-workspace/maplekemi/elements.json";

	@Test
	public void testLoad() {
		Kemi.load(path);
	}

	@Test
	public void testM() {
		Kemi.load(path);
		assertEquals(180.156000000000006, Kemi.M("C__6*H__12*O__6"));
		assertEquals(2678.00717199999963, Kemi.M("U__4*Ag__16"));
		assertEquals(45.0170000000000030, Kemi.M("COOH"));
	}

	@Test
	public void testm() {
		Kemi.load(path);
		assertEquals(180.156000000000006, Kemi.m(1.0, "C__6*H__12*O__6"));
		assertEquals(180.156000000000006 * 2, Kemi.m(2.0, "C__6*H__12*O__6"));
		assertEquals(180.156000000000006 * 0.157, Kemi.m(0.157, "C__6*H__12*O__6"));
	}

	@Test
	public void testn() {
		Kemi.load(path);
		assertEquals(1.0, Kemi.n(180.156000000000006, "C__6*H__12*O__6"));
		assertEquals(1.0 * 2, Kemi.n(180.156000000000006 * 2, "C__6*H__12*O__6"));
		assertEquals(0.0157, Kemi.n(180.156000000000006 * 0.0157, "C__6*H__12*O__6"));
	}
	
	@Test
	public void testReactionCountSymbols() {
		Kemi.load(path);
		Molecule molecule = Kemi.extractMolecule("H__2*O__2");
		Map<String, Integer> symbols = new HashMap<>();
		symbols.put("H", 2);
		symbols.put("O", 2);
		assertEquals(symbols, Reaction.countSymbolsInMolecule(molecule));
	}
	
	@Test
	public void testBalance() {
		Kemi.load(path);
		Reaction reaction = new Reaction("C__6*H__12*O__6+O__2", "CO__2+H__2*O");
		Reaction reaction2 = new Reaction("C__8*H__7*N+O__2", "H__2*O+CO__2+NO");
		assertEquals("C__6*H__12*O__6+6*O__2=6*CO__2+6*H__2*O", reaction.balance(50));
		assertEquals("4*C__8*H__7*N+41*O__2=14*H__2*O+32*CO__2+4*NO", reaction2.balance(50));
	}
}

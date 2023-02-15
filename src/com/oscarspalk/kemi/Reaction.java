package com.oscarspalk.kemi;

import java.util.*;
import java.util.Map.Entry;
import java.util.function.Function;

public class Reaction {
    List<Molecule> leftSide;
    List<Molecule> rightSide;

    public Reaction(String leftSide, String rightSide) {
        this.leftSide = new ArrayList<>();
        this.rightSide = new ArrayList<>();
        for (String string : leftSide.split("\\+")) {
            this.leftSide.add(Kemi.extractMolecule(string));
        }
        for (String string : rightSide.split("\\+")) {
            this.rightSide.add(Kemi.extractMolecule(string));
        }
    }

    public static Map<String, Integer> countSymbolsInMolecule(Molecule molecule) {
        Map<String, Integer> symbols = new HashMap<>();
        for (ElementWithAmount element : molecule.elements) {
            if (symbols.containsKey(element.symbol)) {
                int startAmount = symbols.get(element.symbol);
                symbols.put(element.symbol, startAmount + element.amount);
            } else {
                symbols.put(element.symbol, element.amount);
            }
        }
        return symbols;
    }

    public static Map<String, Integer> joinMaps(List<Map<String, Integer>> maps, List<Integer> multipliers){
        Map<String, Integer> total = new HashMap<>();
        int len = maps.size();
        for(int i = 0; i < len; i++){
            int multiplier = multipliers.get(i);
            maps.get(i).forEach((key, amount) -> {
                int actualAmount = amount*multiplier;
                if (total.containsKey(key)) {
                    total.put(key, actualAmount + total.get(key));
                } else {
                    total.put(key, actualAmount);
                }
            });
        }
        return total;
    }

    public static String toStringWithMultipliers(List<Molecule> molecules, List<Integer> multipliers) {
        StringBuilder output = new StringBuilder();
        for (int i = 0; i < molecules.size(); i++) {
            if (i != 0) {
                output.append("+");
            }
            output.append(multipliers.get(i) == 1 ? "" : multipliers.get(i) + "*").append(molecules.get(i).toString());
        }
        return output.toString();
    }
    public String balance(int depth) {
        int leftMoleculesLen = this.leftSide.size();
        int rightMoleculesLen = this.rightSide.size();
        List<Map<String, Integer>> leftSideMoleculesInSymbols = new ArrayList<>();
        for(Molecule molecule : this.leftSide){
            leftSideMoleculesInSymbols.add(countSymbolsInMolecule(molecule));
        }
        List<Map<String, Integer>> rightSideMoleculesInSymbols = new ArrayList<>();
        for(Molecule molecule : this.rightSide){
            rightSideMoleculesInSymbols.add(countSymbolsInMolecule(molecule));
        }
        List<List<Integer>> possibleMultipliers = new ArrayList<>();
        generateCombos(new ArrayList<>(), depth, leftMoleculesLen + rightMoleculesLen, possibleMultipliers, allMultipliers -> {
            Map<String, Integer> leftSideCounts = joinMaps(leftSideMoleculesInSymbols,
                    allMultipliers.subList(0, leftMoleculesLen));
            Map<String, Integer> rightSideCounts = joinMaps(rightSideMoleculesInSymbols,
                    allMultipliers.subList(leftMoleculesLen, allMultipliers.size()));

            if (leftSideCounts.equals(rightSideCounts)) {
                return true;
            }
            return false;
        });
        if(possibleMultipliers.size() > 0){
            List<Integer> fit = possibleMultipliers.get(0);
            return toStringWithMultipliers(leftSide, fit.subList(0, leftMoleculesLen)) + "="
                    + toStringWithMultipliers(rightSide,
                   fit.subList(leftMoleculesLen, fit.size()));
        }

        return "No Match";
    }

    public static void generateCombos(List<Integer> currentList, int limit, int length, List<List<Integer>> listToAppend, Function<List<Integer>, Boolean> compare) {
        if(listToAppend.size() > 0){
            return;
        }
        if (length == 0) {
            if (compare.apply(currentList)) {
                listToAppend.add(currentList);
            }
            return;
        }
        for (int i = 1; i < limit + 1; i++) {
            List<Integer> copy = new ArrayList<>(currentList);
            copy.add(i);
            generateCombos(copy, limit, length - 1, listToAppend, compare);
        }
    }
}

##MODULE Kemi
##
##DESCRIPTION
##- A package containing commands for testing the randomness of
## binary sequences.

$define RANDINFO ':-Kemi'

Kemi := module()
description "Smarte kemi redskaber.";
option package;

$include "C:\Users\knudi\Desktop\maple_kemi\automatik.mm"

export M, load, mol, gram, MM;

local elements, extractElement, seperateElements, i, e, extractMolecule, v, dllM;


gram := proc(mol, formelEnhed)
    local molecule := M(formelEnhed);
    return mol*molecule;
end proc;

mol := proc(grams, formelEnhed)
    local molecule := M(formelEnhed);
    return grams/molecule;
end proc;

extractElement := proc(val)
    local thisMass := 0;
    local countUnderscores := StringTools[Search]("__", val);
    local amount := 0;
    local element := "";
    if countUnderscores = 0 then
        element := val;
        amount := 1;
    else:
        local thisElement := StringTools[RegSplit]("__", val);
        element := thisElement[1];
        local nOfPotens := StringTools[Search]("^", thisElement[2]);
        if nOfPotens = 0 then
            amount := parse(thisElement[2]);
        else:
            local numberAndAmount := StringTools[RegSplit]("\\^", thisElement[2]);
            local normalizedAmount := parse(numberAndAmount[1]);
            local multiplier := parse(numberAndAmount[2]);
            amount := parse(numberAndAmount[1]) * parse(numberAndAmount[2]);
        end if;
    end if;
    local ind2, el;
    for ind2, el in elements do:
        if el:-symbol = element then return Record('element'=el, 'amount'=amount) end if;
    end do;
end proc;

seperateElements := proc(input)
    local newList := Array([]);
    local lengthOfInput := length(input);
    local containsWeird := false;
    local c, indc;
    local stillPart := 0;
    for indc, c in input do:
        if (indc-1) < lengthOfInput and input[indc+1] = "_" then
            local lastFormelEnhed := StringTools[SubString](input,(indc-stillPart)..length(input));
            ArrayTools[Append](newList, lastFormelEnhed);
            return newList;
        end if;
        if (indc-1) < lengthOfInput and StringTools[IsUpper](input[indc+1]) then
            local whatToAdd := "";
            for i from 0 by 1 to stillPart do:
                whatToAdd := cat( input[indc-i], whatToAdd);
            end do;
            ArrayTools[Append](newList, whatToAdd);
            containsWeird := true;
            stillPart := 0;
        else:
            stillPart := stillPart + 1;
        end if;
    end do;
    if not(containsWeird) then
        return Array([input])
    end if;
    return newList;
end proc;

extractMolecule := proc(molecule)
    local elementList := Array([]);
    local itemsList := Array([]);
    local input := String(molecule);
    local countDots := StringTools[Search]("*", input);
    if countDots = 0 then
        local runThrough := seperateElements(input);
        for i, e in runThrough do:
            ArrayTools[Append](elementList, e);
        end do;
    else:
        local inputAsList := StringTools[RegSplit]("\\*", input);
        local value;
        for value in inputAsList do:
            local runThrough := seperateElements(value);
            for i, e in runThrough do:
                ArrayTools[Append](elementList, e);
            end do;
        end do;
    end if;
    local ind, val;
    for ind, val in elementList do:
        ArrayTools[Append](itemsList, extractElement(val));
    end do;
    return itemsList;
end proc;

M := proc(formelEnhed::algebraic)
    description "Den molære masse for en angiven formelenhed.";
    local totalMass := 0;
    local ments := extractMolecule(formelEnhed);
    for i,v in ments do:
        totalMass := totalMass + (v[element][atomic_mass]*v[amount]);
    end do;
    return totalMass;
end proc;

MM := proc(formelEnhed)
    return dllM(String(formelEnhed));
end proc;

load := proc()
    dllM := define_external('M', 'input'::string, 'RETURN'::string, 'LIB' = "C:/Users/knudi/source/repos/kemilib/x64/Debug/test.dll");
    local fil := "https://raw.githubusercontent.com/Bowserinator/Periodic-Table-JSON/master/PeriodicTableJSON.json";
    local data := JSON:-ParseFile(fil, output=record);
    elements := data:-elements;
    return;
end proc;

local
    Runs,
    ModuleLoad,
    ModuleUnload;
    ModuleLoad := proc()
        load()
    end proc;

    ModuleUnload := proc()
    end proc;

end module;
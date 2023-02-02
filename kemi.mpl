##MODULE Kemi
##
##DESCRIPTION
##- A package containing commands for testing the randomness of
## binary sequences.

$define RANDINFO ':-Kemi'

Kemi := module()
option package;

export m, load, mol, gram;

local elements, extractElement, seperateElements, i, e;

gram := proc(mol, formelEnhed)
    local molecule := m(formelEnhed);
    return mol*molecule;
end proc;

mol := proc(grams, formelEnhed)
    local molecule := m(formelEnhed);
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
        amount := parse(thisElement[2]);
    end if;
    local ind2, el;
    for ind2, el in elements do:
        if el:-symbol = element then thisMass := thisMass + el:-atomic_mass*amount end if;
    end do;
    return thisMass;
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

m := proc(formelEnhed)
    local totalMass := 0;
    local elementList := Array([]);
    local input := String(formelEnhed);
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
        totalMass := totalMass + extractElement(val)
    end do;
    return totalMass;
end proc;

load := proc()
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
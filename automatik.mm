export afstem;
local extractReaction, countElements;

extractReaction := proc(reaction) 
    local countPlussesLeft := StringTools[Search]("+", reaction);
    local leftMolecules := Array([]);
    if countPlussesLeft = 0 then
        ArrayTools[Append](leftMolecules,extractMolecule(reaction));
    else:
        local arrLeft := StringTools[RegSplit]("\\+", reaction);
        for i,v in arrLeft do:
            ArrayTools[Append](leftMolecules, extractMolecule(v));
        end do;
    end if;

    return leftMolecules;
end proc;

countElements := proc(list)
    local countHolderAlpha := Array([]);
    local countHolderNumeric := Array([]);
    for i,v in list do:
        for j,e in v do:
            local elSymbol := e[element][symbol];
            countHolder[elSymbol] := amount;
        end do; 
    end do;
    return countHolder;
end proc;

afstem := proc(left, right)
    local strLeft := String(left);
    local strRight := String(right);
    local arrLeft := extractReaction(strLeft);
    local arrRight := extractReaction(strRight);
    local count := countElements(arrLeft);
    print(count);
    return strLeft, strRight;
end proc;

Kemi := module()
description "Smarte kemi redskaber.";
option package;

local dllM, dllAfstem;

export M, m,n, load, afstem;

M := proc(formelEnhed)
    return dllM(String(formelEnhed));
end proc;

m := proc(mol, formelEnhed)
    return M(formelEnhed) * mol;
end proc;

n := proc(gram, formelEnhed)
    return gram/M(formelEnhed);
end proc;

afstem := proc(input, input2)
    local buf := "";
    return dllAfstem(String(input), String(input2), buf);
end proc;

load := proc()
    local mapleBasePath := kernelopts(mapledir);
    local dllPath := cat(mapleBasePath,"/data/kemi/kemilib.dll");
    local dllLoad := define_external('initlib', 'datapath'::string,'LIB' = dllPath);
    dllLoad(mapleBasePath);
    dllM := define_external('M', 'input'::string, 'RETURN'::float[8], 'LIB' = dllPath);
    dllAfstem := define_external('afstem', 'input'::string,'input2'::string, 'buf'::string, 'RETURN'::string, 'LIB' = dllPath);
    return;
end proc;

local ModuleLoad, ModuleUnload;
    ModuleLoad := proc()
        load()
    end proc;
    ModuleUnload := proc()
    end proc;

end module;
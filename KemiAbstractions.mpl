Kemi := module()
description "Smarte kemi redskaber.";
option package;

local dllM;

export M, load;

M := proc(formelEnhed)
    return dllM(String(formelEnhed));
end proc;

load := proc()
    local mapleBasePath := kernelopts(mapledir);
    local dllPath := cat(mapleBasePath,"/data/kemi/kemilib.dll");
    print(mapleBasePath);
    dllM := define_external('M', 'input'::string, 'RETURN'::float[8], 'LIB' = dllPath);
    local dllLoad := define_external('initlib', 'datapath'::string,'LIB' = dllPath);
    dllLoad(mapleBasePath);
    return;
end proc;

local ModuleLoad, ModuleUnload;
    ModuleLoad := proc()
        load()
    end proc;
    ModuleUnload := proc()
    end proc;

end module;
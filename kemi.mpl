Kemi := module()
description "For kemi.";
option package;
export load, M, afstem, tabular;

local libLoad, classPath, elementsPath, libM, libAfstem;

afstem := proc(leftSide, rightSide, depth:=50)
	local side1 := String(leftSide);
	local side2 := String(rightSide);
	local result := libAfstem(side1, side2, depth);
	return parse(result)
end proc;

M := proc(input)
	return libM(String(input))
end proc;

load := proc()
    local mapleBasePath := kernelopts(mapledir);
    local libPath := cat(mapleBasePath,"/data/kemi/kemi.jar");
    libM := define_external('M', CLASS = "com.oscarspalk.kemi.Kemi", CLASSPATH = libPath, JAVA, 'molecule'::string, 'RETURN'::double);
    libLoad := define_external('load', CLASS = "com.oscarspalk.kemi.Kemi", CLASSPATH = libPath, JAVA, 'path'::string, 'RETURN'::string);
    libAfstem := define_external('afstem', CLASS = "com.oscarspalk.kemi.Kemi", CLASSPATH = libPath, JAVA, 'leftSide'::string,'rightSide'::string, 'depth'::integer[4], 'RETURN'::string);
    elementsPath := cat(mapleBasePath, "/data/kemi/elements.json");
	libLoad(elementsPath);
	return;
end proc;

local ModuleLoad, ModuleUnload;
    ModuleLoad := proc()
        load()
    end proc;
    ModuleUnload := proc()
    end proc;

end module;
Kemi := module()
description "For kemi.";
option package;
export load, M, afstem, tabular;

local libLoad, classPath, elementsPath, libM, libAfstem;

classPath := "C:/Users/knudi/eclipse-workspace/maplekemi/build/jar/kemi.jar";

elementsPath := "C:/Users/knudi/eclipse-workspace/maplekemi/elements.json";

libM := define_external('M', CLASS = "com.oscarspalk.kemi.Kemi", CLASSPATH = classPath, JAVA, 'molecule'::string, 'RETURN'::double);
libLoad := define_external('load', CLASS = "com.oscarspalk.kemi.Kemi", CLASSPATH = classPath, JAVA, 'path'::string, 'RETURN'::string);
libAfstem := define_external('afstem', CLASS = "com.oscarspalk.kemi.Kemi", CLASSPATH = classPath, JAVA, 'leftSide'::string,'rightSide'::string, 'depth'::integer[4], 'RETURN'::string);

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
	return libLoad(elementsPath);
end proc;

end module;
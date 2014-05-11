@set XALAN_HOME=/ws/private/libs/xalan-j_2_4_1/bin

@set XERCES_HOME=%XALAN_HOME%
@set XALAN_LIBS=%XALAN_HOME%/xalan.jar;%XERCES_HOME%/xml-apis.jar;%XERCES_HOME%/xercesImpl.jar
@set XSL_CMD="%JAVA_HOME%\bin\java" -Xbootclasspath/p:%XALAN_LIBS% org.apache.xalan.xslt.Process

set XML_FILE=resume.xml
set XSL_FILE=resume.xsl
set OUT_FILE=resume.html

%XSL_CMD% -in %XML_FILE% -xsl %XSL_FILE% >%OUT_FILE%
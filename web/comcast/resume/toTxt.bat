@set XALAN_HOME=/ws/private/libs/xalan-j_2_4_1/bin

@set XERCES_HOME=%XALAN_HOME%
@set XALAN_LIBS=%XALAN_HOME%/xalan.jar;%XERCES_HOME%/xml-apis.jar;%XERCES_HOME%/xercesImpl.jar
@set XSL_CMD="%JAVA_HOME%\bin\java" -Xbootclasspath/p:%XALAN_LIBS% org.apache.xalan.xslt.Process

%XSL_CMD% -in resume.xml -xsl resume.txt.xsl >resume.txt
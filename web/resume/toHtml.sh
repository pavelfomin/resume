set -x
XALAN_HOME=~/dev/libs/xalan-j_2_4_1/bin

XERCES_HOME=$XALAN_HOME
XALAN_LIBS=$XALAN_HOME/xalan.jar:$XERCES_HOME/xml-apis.jar:$XERCES_HOME/xercesImpl.jar
XSL_CMD="java -Xbootclasspath/p:$XALAN_LIBS org.apache.xalan.xslt.Process"

XML_FILE=resume.xml
XSL_FILE=resume.xsl
OUT_FILE=resume.html

$XSL_CMD -in $XML_FILE -xsl $XSL_FILE >$OUT_FILE

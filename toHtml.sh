set -x
XSL_CMD="java -jar $(ls $XSLT_PROCESSOR_HOME/target/xslt-processor-*.jar)"

XML_FILE=resume.xml
XSL_FILE=resume.xsl
OUT_FILE=resume.html

$XSL_CMD -in $XML_FILE -xsl $XSL_FILE >$OUT_FILE

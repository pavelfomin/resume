<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="../browserSupport.xsl" /> 
<xsl:output method="html" indent="yes" />

<!-- key for finding distinct actors -->
<xsl:key name="kDistinctActor" match="film" use="@actor"/>

<xsl:template match="jbfilms">
<html>
  <head>
    <link rel="stylesheet" href="../main.css" type="text/css" />
    <title>James Bond Films</title>
  </head>
  <body>
    <h2>James Bond Films</h2>
    <table border="1" frame="border" rules="rows">
     <thead>
      <tr>
        <th>#</th>
        <th>Name</th>
        <th>Year</th>
        <th>Bond</th>
        <th>Budget, $</th>
        <th>Comments</th>
      </tr>
     </thead>
     <tbody>
<!--
  <xsl:apply-templates select="film">
    <xsl:sort select="@actorId"/>
  </xsl:apply-templates>
-->
  <xsl:apply-templates select="film[generate-id() = generate-id(key('kDistinctActor', @actor))]/@actor">
    <xsl:sort select="@actorId"/>
  </xsl:apply-templates>

     </tbody>
    </table>

  <xsl:call-template name="browserSupport" />

  </body>
</html>
</xsl:template>

<!-- template for films -->
<xsl:template match="film">
  <tr>
   <td><xsl:value-of select="@id"/></td>
   <td><xsl:value-of select="@name"/></td>
   <td><xsl:value-of select="@year"/></td>
   <td><xsl:value-of select="@actor"/></td>
   <td><xsl:value-of select="@budget"/></td>

   <xsl:apply-templates select="comment"/>
  </tr>
</xsl:template>

<!-- template for comments -->
<xsl:template match="comment">
<td>
  <xsl:call-template name="showComment">
    <xsl:with-param name="comment"><xsl:value-of select="."/></xsl:with-param>
    <xsl:with-param name="source"><xsl:value-of select="@src"/></xsl:with-param>
  </xsl:call-template>
</td>
</xsl:template>

<!-- template to show comment -->
<xsl:template name="showComment">
  <xsl:param name="comment"/>
  <xsl:param name="source"/>
  <div class="small">
    <xsl:value-of select="position()"/>
    From <a href="{$source}" target="_blank">
    <xsl:value-of select="$source"/></a>.
    <xsl:value-of select="$comment"/>
    <a href="{$source}" target="_blank">More...</a>
  </div>
</xsl:template>

<!-- template for actors -->
<xsl:template match="@actor">
  <xsl:apply-templates select="key('kDistinctActor',.)">
    <xsl:sort select="@year"/>
  </xsl:apply-templates>
  <tr>
    <th colspan="2"><xsl:value-of select="."/></th>
    <th> 
      <xsl:value-of select="count(key('kDistinctActor',.))"/>
    </th>
  </tr>
</xsl:template>

</xsl:stylesheet>

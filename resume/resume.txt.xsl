<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:strip-space elements="*" />
<xsl:output method="text" />

<xsl:template match="resume">
  <xsl:apply-templates select="@name"/>
  <xsl:apply-templates select="@title"/>
  <xsl:apply-templates select="contact-list"/>
  <xsl:apply-templates select="profile"/>
  <xsl:apply-templates select="skill-list"/>
  <xsl:apply-templates select="work-history"/>
  <xsl:apply-templates select="education"/>

</xsl:template>

<!-- template for name -->
<xsl:template match="@name">
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="."/>
  <xsl:text>&#10;</xsl:text><!-- new line -->
</xsl:template>

<!-- template for title -->
<xsl:template match="@title">
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="."/>
  <xsl:text>&#10;</xsl:text><!-- new line -->
</xsl:template>

<!-- template for contact-list -->
<xsl:template match="contact-list">
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:apply-templates select="contact"/>
  <xsl:text>&#10;</xsl:text><!-- new line -->
</xsl:template>

<!-- template for contact -->
<xsl:template match="contact">
  <xsl:value-of select="concat(@type, ': ')"/>
  <xsl:value-of select="@value"/>
  <xsl:text>&#10;</xsl:text><!-- new line -->
</xsl:template>

<!-- template for profile -->
<xsl:template match="profile">
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:text>Profile</xsl:text>
  <xsl:text>&#10;</xsl:text><!-- new line -->

  <xsl:apply-templates select="entry">
    <xsl:with-param name="tab">
      <xsl:text>&#09;</xsl:text><!-- tab -->
    </xsl:with-param>
  </xsl:apply-templates>
</xsl:template>

<!-- template for profile entry -->
<xsl:template match="entry">
  <xsl:param name="tab"/>

  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="concat($tab, '- ')"/>
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<!-- template for skill-list -->
<xsl:template match="skill-list">
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:text>Skills Summary</xsl:text>
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:apply-templates select="skill">
    <xsl:with-param name="tab">
      <xsl:text>&#09;</xsl:text><!-- tab -->
    </xsl:with-param>
  </xsl:apply-templates>
</xsl:template>

<!-- template for skill -->
<xsl:template match="skill">
  <xsl:param name="tab"/>

  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="$tab"/>
  <xsl:value-of select="concat(normalize-space(type), ': ')"/>

  <xsl:apply-templates select="value">
    <xsl:with-param name="tab">
      <xsl:value-of select="$tab"/>
    </xsl:with-param>
  </xsl:apply-templates>
</xsl:template>

<!-- template for skill value -->
<xsl:template match="value">
  <xsl:param name="tab"/>

  <xsl:apply-templates select="@description">
    <xsl:with-param name="tab">
      <xsl:value-of select="concat($tab, $tab)"/>
    </xsl:with-param>
  </xsl:apply-templates>

  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<!-- template for skill value description -->
<xsl:template match="@description">
  <xsl:param name="tab"/>

  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="$tab"/>
  <xsl:value-of select="concat(., ': ')"/>
</xsl:template>

<!-- template for work history -->
<xsl:template match="work-history">
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:text>Work History</xsl:text>

  <xsl:apply-templates select="company">
    <xsl:with-param name="tab">
      <xsl:text>&#09;</xsl:text><!-- tab -->
    </xsl:with-param>
  </xsl:apply-templates>
</xsl:template>

<!-- template for company -->
<xsl:template match="company">
  <xsl:param name="tab"/>

  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="@name"/>
  <xsl:apply-templates select="@department"/>

  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="@position"/>

  <xsl:value-of select="concat($tab, $tab, $tab)"/>
  <xsl:value-of select="concat(@startDate, ' - ', @endDate)"/>

  <xsl:apply-templates select="assignment">
    <xsl:with-param name="tab">
      <xsl:value-of select="$tab"/>
    </xsl:with-param>
  </xsl:apply-templates>
</xsl:template>

<!-- template for assignment -->
<xsl:template match="assignment">
  <xsl:param name="tab"/>

  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="$tab"/>
  <xsl:value-of select="@name"/>
  <xsl:apply-templates select="@department"/>

  <xsl:apply-templates select="assignment-environment">
    <xsl:with-param name="tab">
      <xsl:value-of select="$tab"/>
    </xsl:with-param>
  </xsl:apply-templates>

  <xsl:apply-templates select="assignment-tools">
    <xsl:with-param name="tab">
      <xsl:value-of select="$tab"/>
    </xsl:with-param>
  </xsl:apply-templates>

  <xsl:apply-templates select="assignment-description">
    <xsl:with-param name="tab">
      <xsl:value-of select="concat($tab, $tab)"/>
    </xsl:with-param>
  </xsl:apply-templates>

<!--
  <xsl:apply-templates select="assignment-details"/>
-->
</xsl:template>

<!-- template for department -->
<xsl:template match="@department">
  <xsl:call-template name="addNotNull">
    <xsl:with-param name="prefix">
      <xsl:value-of select="', '"/>
    </xsl:with-param>
    <xsl:with-param name="value">
      <xsl:value-of select="."/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- template for assignment environment -->
<xsl:template match="assignment-environment">
  <xsl:param name="tab"/>

  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="$tab"/>
  <xsl:text>Environment: </xsl:text>
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<!-- template for assignment tools -->
<xsl:template match="assignment-tools">
  <xsl:param name="tab"/>

  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="$tab"/>
  <xsl:text>Tools: </xsl:text>
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<!-- template for assignment description -->
<xsl:template match="assignment-description">
  <xsl:param name="tab"/>

  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="$tab"/>
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<!-- template for assignment details -->
<xsl:template match="assignment-details">

  <xsl:apply-templates select="detail"/>
</xsl:template>

<!-- template for assignment detail -->
<xsl:template match="detail">
  <xsl:value-of select="."/>
</xsl:template>

<!-- template for education -->
<xsl:template match="education">
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:text>Education</xsl:text>
  <xsl:apply-templates select="degree"/>
</xsl:template>

<!-- template for education degree-->
<xsl:template match="degree">
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="@school"/>

  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="concat(@award, ', ', @year)"/>

  <xsl:text>&#10;</xsl:text><!-- new line -->
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<!-- template for adding prefix, suffix to the not null value only -->
<!-- nothing is printed if value is null -->
<xsl:template name="addNotNull">
  <xsl:param name="prefix"/>
  <xsl:param name="value"/>
  <xsl:param name="suffix"/>

  <xsl:choose>
    <xsl:when test="boolean(string($value))">
      <xsl:value-of select="concat($prefix, $value, $suffix)"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- template for URL: add a protocol prefix if one doesn't exist -->
<xsl:template name="formatURL">
  <xsl:param name="url"/>
  <xsl:param name="name"/>
  <xsl:param name="protocol"/>

  <xsl:variable name="notNullName">
    <xsl:choose>
      <xsl:when test="boolean(string($name))">
        <xsl:value-of select="$name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable> 

  <xsl:choose>
    <xsl:when test="boolean(string($url))">
      <xsl:choose>
        <xsl:when test="starts-with($url, $protocol)">
          <a href="{$url}"><xsl:value-of select="$notNullName"/></a>
        </xsl:when>
        <xsl:otherwise>
          <a href="{concat($protocol, $url)}"><xsl:value-of select="$notNullName"/></a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$notNullName"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- back reference template -->
<xsl:template name="back-reference">
  <xsl:param name="id"/>
  <xsl:param name="label"/>

<!--todo: uncomment if table of content is added
  <a href="#_{$id}" class="bref"></a>
  <a name="{$id}"><xsl:value-of select="$label"/></a>
-->
<!--w/out table of content -->
  <xsl:value-of select="$label"/>
</xsl:template>

</xsl:stylesheet>

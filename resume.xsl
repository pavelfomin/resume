<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes" />

<xsl:template match="resume">
<html>
  <head>
    <META name="robots" content="noarchive" />
    <title>
      <xsl:value-of select="concat(@name, ', ', @title)"/>
    </title>
    <link rel="stylesheet" href="css/main.css" type="text/css" />
    <script language="JavaScript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <script language="JavaScript" src="js/resume.js"></script>
  </head>
  <body>
    <center>
      <xsl:apply-templates select="@name"/>
      <xsl:apply-templates select="@title"/>
      <xsl:apply-templates select="contact-list"/>
    </center>

    <xsl:apply-templates select="profile"/>
    <xsl:apply-templates select="skill-list"/>
    <xsl:apply-templates select="work-history"/>
    <xsl:apply-templates select="work-history-more"/>
    <xsl:apply-templates select="education"/>

    <xsl:call-template name="footer">
      <xsl:with-param name="email">
        <xsl:value-of select="concat(@email, '@', @domain)"/>
      </xsl:with-param>
      <xsl:with-param name="updated">
        <xsl:value-of select="@updated"/>
      </xsl:with-param>
    </xsl:call-template>

  </body>
</html>
</xsl:template>

<!-- template for name -->
<xsl:template match="@name">
<div>
  <h1><xsl:value-of select="."/></h1>
</div>
</xsl:template>

<!-- template for title -->
<xsl:template match="@title">
<div>
  <h2><xsl:value-of select="."/></h2>
</div>
</xsl:template>

<!-- template for contact-list -->
<xsl:template match="contact-list">
  <div>
    
    <!-- process all contact types -->
    <xsl:apply-templates select="contact"/>

    <!-- add email address as a contact info -->
    <xsl:choose>
      <xsl:when test="../@email">
    	<b>Email: </b>
    	<span class="email" data-user="{../@email}" data-domain="{../@domain}"/>
      </xsl:when>
    </xsl:choose>
  
  </div>
</xsl:template>

<!-- template for contact -->
<xsl:template match="contact">
  <xsl:call-template name="render-contact">
    <xsl:with-param name="type">
      <xsl:value-of select="@type"/>
    </xsl:with-param>
    <xsl:with-param name="value">
      <xsl:value-of select="@value"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- template for rendering a contact -->
<xsl:template name="render-contact">
  <xsl:param name="type"/>
  <xsl:param name="value"/>

  <b><xsl:value-of select="$type"/>: </b>

  <xsl:choose>
    <xsl:when test="contains($value, 'http')">
        <xsl:call-template name="formatURL">
          <xsl:with-param name="url">
            <xsl:value-of select="$value"/>
          </xsl:with-param>
          <xsl:with-param name="protocol">
            <xsl:value-of select="'http://'"/>
          </xsl:with-param>
        </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$value"/>
    </xsl:otherwise>
  </xsl:choose>

  <br/>
</xsl:template>

<!-- template for profile -->
<xsl:template match="profile">
<div>
  <h2>
    <xsl:call-template name="back-reference">
      <xsl:with-param name="id">
        <xsl:value-of select="'profile'"/>
      </xsl:with-param>
      <xsl:with-param name="label">
        <xsl:value-of select="'Profile'"/>
      </xsl:with-param>
    </xsl:call-template>
  </h2>
  <ul class="client">
    <xsl:apply-templates select="entry"/>
  </ul>
</div>
</xsl:template>

<!-- template for profile entry -->
<xsl:template match="entry">
<li>
  <xsl:value-of select="."/>
</li>
</xsl:template>

<!-- template for skill-list -->
<xsl:template match="skill-list">
<div>
  <h2>
    <xsl:call-template name="back-reference">
      <xsl:with-param name="id">
        <xsl:value-of select="'skills'"/>
      </xsl:with-param>
      <xsl:with-param name="label">
        <xsl:value-of select="'Skills Summary'"/>
      </xsl:with-param>
    </xsl:call-template>
  </h2>

  <div class="level1">
    <table border="0">
      <xsl:apply-templates select="skill"/>
    </table>
  </div>

</div>
</xsl:template>

<!-- template for skill -->
<xsl:template match="skill">
<tr>
  <td width="150" valign="top" nowrap="1">
    <xsl:call-template name="back-reference">
      <xsl:with-param name="id">
        <xsl:value-of select="concat('skill_', @id)"/>
      </xsl:with-param>
    </xsl:call-template>
    <b><xsl:value-of select="type"/></b>
  </td>
  <td valign="top">
    <xsl:apply-templates select="value"/>
    <xsl:apply-templates select="skill-details"/>
  </td>
</tr>
</xsl:template>

<!-- template for skill details -->
<xsl:template match="skill-details">
  <xsl:param name="showDetailsLink" select="'notnull'"/>

  <xsl:apply-templates select="main-detail"/>

  <xsl:choose>
    <xsl:when test="boolean($showDetailsLink)">
      <a href="#" class="action-show {../@id}-details" data-element-id="{../@id}-details">More details</a>
    </xsl:when>
  </xsl:choose>

  <span id="{../@id}-details" class="{../@id}-details" style="display: none;">
    <xsl:apply-templates select="value"/>
    <a href="#" class="action-hide" data-element-id="{../@id}-details">Hide details</a>
  </span>
</xsl:template>

<!-- template for skill value -->
<xsl:template match="value|main-detail">
  <xsl:apply-templates select="@description"/>

  <!--allow the embedded html tags to be processed-->
  <xsl:apply-templates /><br/>
</xsl:template>

<!-- template for skill value description -->
<xsl:template match="@description">
  <b><xsl:value-of select="concat(., ':')"/></b>
</xsl:template>

<!-- template for work history -->
<xsl:template match="work-history">
<div>
  <h2>
    <xsl:call-template name="back-reference">
      <xsl:with-param name="id">
        <xsl:value-of select="'work_history'"/>
      </xsl:with-param>
      <xsl:with-param name="label">
        <xsl:value-of select="'Work History'"/>
      </xsl:with-param>
    </xsl:call-template>
  </h2>
  <xsl:apply-templates select="company"/>
</div>
</xsl:template>

<!-- template for additional work history -->
<xsl:template match="work-history-more">
  <xsl:param name="showDetailsLink" select="'notnull'"/>

  <xsl:choose>
    <xsl:when test="boolean($showDetailsLink)">
      <h2>
          <a href="#" class="action-show work-history-more" data-element-id="work-history-more">More work history</a>
      </h2>
    </xsl:when>
  </xsl:choose>

<div id="work-history-more" class="work-history-more" style="display: none;">
  <xsl:apply-templates select="company"/>
  <h2>
	  <a href="#" class="action-hide" data-element-id="work-history-more">Less work history</a>
  </h2>
</div>
</xsl:template>

<!-- template for company -->
<xsl:template match="company">
<div class="level1">
  <table width="95%" cellspacing="0" cellpadding="0">
    <tr>
      <td class="position">
        <xsl:call-template name="back-reference">
          <xsl:with-param name="id">
            <xsl:value-of select="concat('work_history_', @id)"/>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="formatURL">
          <xsl:with-param name="url">
            <xsl:value-of select="@url"/>
          </xsl:with-param>
          <xsl:with-param name="name">
            <xsl:value-of select="@name"/>
          </xsl:with-param>
          <xsl:with-param name="protocol">
            <xsl:value-of select="'http://'"/>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:apply-templates select="@department"/>
      </td>
    </tr>
    <tr>
      <td class="position">
        <xsl:value-of select="@position"/>
      </td>
      <td align="right" class="position">
        <xsl:value-of select="concat(@startDate, ' - ', @endDate)"/>
      </td>
    </tr>
  </table>
  <xsl:apply-templates select="assignment"/>
</div>
</xsl:template>

<!-- template for assignment -->
<xsl:template match="assignment">
<div class="level2">
  <font class="client">
    <xsl:call-template name="back-reference">
      <xsl:with-param name="id">
        <xsl:value-of select="concat('work_history_', ../@id, '_', @id)"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="formatURL">
      <xsl:with-param name="url">
        <xsl:value-of select="@url"/>
      </xsl:with-param>
      <xsl:with-param name="name">
        <xsl:value-of select="@name"/>
      </xsl:with-param>
      <xsl:with-param name="protocol">
        <xsl:value-of select="'http://'"/>
      </xsl:with-param>
    </xsl:call-template>
    
    <xsl:apply-templates select="@department"/>
  </font>

  <table cellspacing="0" cellpadding="0">
    <xsl:apply-templates select="assignment-environment"/>
    <xsl:apply-templates select="assignment-tools"/>
  </table>

  <xsl:apply-templates select="assignment-description"/>
  <xsl:apply-templates select="assignment-details"/>

</div>
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
<tr>
  <td align="right" valign="top">
    <b>Environment:</b>
    <xsl:text>&#160;</xsl:text>
  </td>
  <td align="left" valign="top"><xsl:value-of select="."/></td>
</tr>
</xsl:template>

<!-- template for assignment tools -->
<xsl:template match="assignment-tools">
<tr>
  <td align="right" valign="top">
    <b>Tools:</b>
    <xsl:text>&#160;</xsl:text>
  </td>
  <td align="left" valign="top"><xsl:value-of select="."/></td>
</tr>
</xsl:template>

<!-- template for assignment description -->
<xsl:template match="assignment-description">
  <xsl:param name="showDetailsLink" select="'notnull'"/>

<div class="level3">
  <!--allow the embedded html tags to be processed-->
  <xsl:apply-templates />

  <xsl:choose>
    <xsl:when test="boolean($showDetailsLink) 
                    and boolean(../assignment-details)">
      <a href="#" class="action-show {../@id}-details" data-element-id="{../@id}-details">More details</a>
    </xsl:when>
  </xsl:choose>
</div>
</xsl:template>

<!-- template for assignment details -->
<xsl:template match="assignment-details">

<div id="{../@id}-details" class="{../@id}-details" style="display: none;">
  <xsl:apply-templates select="detail"/>
  <div class="level3">
	  <a href="#" class="action-hide" data-element-id="{../@id}-details">Hide details</a>
  </div>
</div>
</xsl:template>

<!-- template for assignment detail -->
<xsl:template match="detail">
<div class="level3">
  <!--allow the embedded html tags to be processed-->
  <xsl:apply-templates />
</div>
</xsl:template>

<!-- template for education -->
<xsl:template match="education">
<div id="education">
  <h2>
    <xsl:call-template name="back-reference">
      <xsl:with-param name="id">
        <xsl:value-of select="'edu'"/>
      </xsl:with-param>
      <xsl:with-param name="label">
        <xsl:value-of select="'Education'"/>
      </xsl:with-param>
    </xsl:call-template>
  </h2>
  <xsl:apply-templates select="degree"/>
</div>
</xsl:template>

<!-- template for education degree-->
<xsl:template match="degree">
<div class="level1">

  <xsl:call-template name="formatURL">
    <xsl:with-param name="url">
      <xsl:value-of select="@url"/>
    </xsl:with-param>
    <xsl:with-param name="name">
      <xsl:value-of select="@school"/>
    </xsl:with-param>
    <xsl:with-param name="protocol">
      <xsl:value-of select="'http://'"/>
    </xsl:with-param>
  </xsl:call-template>

  <br/>
  	<b>
		<xsl:value-of select="@award"/>
		<xsl:choose>
			<xsl:when test="@year">
				<xsl:value-of select="concat(', ', @year)" />
			</xsl:when>
		</xsl:choose>
  	</b>
  <br/><xsl:value-of select="."/>
</div>
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

<!-- footer's template -->
<xsl:template name="footer">
  <xsl:param name="updated"/>

  <hr/>

  <div id="footer" class="footer">
    <!-- remove CVS keyword from date -->
    Last modified: <xsl:value-of select="substring-before(substring-after($updated, ':'), '$')"/>
    <xsl:text>  </xsl:text>

  </div>
</xsl:template>
  
<!-- html anchor tag template -->
<xsl:template match="a">
  <a href="{@href}" class="tool" target="_blank">
    <xsl:value-of select="text()"/>
  </a>
</xsl:template>

</xsl:stylesheet>

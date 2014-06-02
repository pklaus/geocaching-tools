<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
  == loc2gp.xsl
  ==
  == Converts Geocaching .LOC files into gpspoint format files
  ==
  == Sample usage:
  ==    Xalan -o results.gp locdata.xml loc2gp.xsl
  ==    gpspoint -uw -if results.gp -of /dev/gps
  ==
  == This stylesheet is hereby granted to the public domain.
  ==
  == Release 1.  Beej Jorgensen, August 2003.  beej@beej.us
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                                                                                
<xsl:output method="text"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/loc">
	<xsl:text>type="waypointlist"&#x0A;</xsl:text>
	<xsl:apply-templates select="waypoint"/>
	<xsl:text>type="waypointlistend"&#x0A;</xsl:text>
</xsl:template>

<xsl:template match="waypoint">
	<xsl:text>type="waypoint"</xsl:text>
	<xsl:apply-templates/>
	<xsl:text> symbol="geocache" display_option="symbol+name"&#x0A;</xsl:text>
</xsl:template>

<xsl:template match="waypoint/name">
	<xsl:text> name="</xsl:text>
	<xsl:value-of select="./@id"/>
	<xsl:text>" comment="</xsl:text>
	<xsl:call-template name="change-quotes">
		<xsl:with-param name="string" select="."/>
	</xsl:call-template>
	<xsl:text>"</xsl:text>
</xsl:template>

<xsl:template match="waypoint/coord">
	<xsl:text> latitude="</xsl:text>
	<xsl:value-of select="./@lat"/>
	<xsl:text>" longitude="</xsl:text>
	<xsl:value-of select="./@lon"/>
	<xsl:text>"</xsl:text>
</xsl:template>

<xsl:template match="waypoint/elev">
	<xsl:text> altitude="</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>"</xsl:text>
</xsl:template>

<xsl:template match="waypoint/type"></xsl:template>
<xsl:template match="waypoint/link"></xsl:template>

<xsl:template name="change-quotes">
    <xsl:param name="string"/>
	<xsl:variable name="singlequote"><xsl:text>'</xsl:text></xsl:variable>
	<xsl:value-of select="translate($string, '&quot;', $singlequote)"/>
</xsl:template>

</xsl:stylesheet>

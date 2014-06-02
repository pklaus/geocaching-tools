<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
  == nc2gp.xsl
  ==
  == Converts Navicache XML files into gpspoint format files
  ==
  == Sample usage:
  ==    Xalan -o results.gp ncdata.xml nc2gp.xsl
  ==    gpspoint -uw -if results.gp -of /dev/gps
  ==
  == This stylesheet is hereby granted to the public domain.
  ==
  == Release 1.  Beej Jorgensen, August 2003.  beej@beej.us
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                                                                                
<xsl:output method="text"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/CACHEDATA">
	<xsl:text>type="waypointlist"&#x0A;</xsl:text>
	<xsl:apply-templates select="CacheDetails"/>
	<xsl:text>type="waypointlistend"&#x0A;</xsl:text>
</xsl:template>

<xsl:template match="CacheDetails">
	<xsl:if test="./@retired != 'yes'">
		<xsl:text>type="waypoint"</xsl:text>  <!-- waypoint -->

		<xsl:text> name="N</xsl:text>  <!-- name -->
		<xsl:variable name="hexid">
			<xsl:call-template name="decimal-to-hex">
				<xsl:with-param name="num" select="./@cache_id"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="zero-pad">
			<xsl:with-param name="num" select="$hexid"/>
		</xsl:call-template>

		<xsl:text>" comment="</xsl:text>  <!-- comment -->
		<xsl:call-template name="change-quotes">
			<xsl:with-param name="string" select="./@name"/>
		</xsl:call-template>

		<xsl:text>" latitude="</xsl:text>  <!-- latitude -->
		<xsl:value-of select="./@latitude"/>

		<xsl:text>" longitude="</xsl:text>  <!-- longitude -->
		<xsl:value-of select="./@longitude"/>

		<xsl:text>" altitude="0" symbol="geocache"</xsl:text>  <!-- misc -->
		<xsl:text> display_option="symbol+name"&#x0A;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template name="change-quotes">
    <xsl:param name="string"/>
	<xsl:variable name="singlequote"><xsl:text>'</xsl:text></xsl:variable>
	<xsl:value-of select="translate($string, '&quot;', $singlequote)"/>
</xsl:template>

<xsl:template name="decimal-to-hex">
    <xsl:param name="num"/>

	<xsl:variable name="newnum" select="floor($num div 16)"/>

	<xsl:if test="$newnum &gt; 0">
		<xsl:call-template name="decimal-to-hex">
			<xsl:with-param name="num" select="$newnum"/>
		</xsl:call-template>
	</xsl:if>

	<xsl:variable name="digit" select="$num mod 16"/>
	<xsl:variable name="hexdigits" select="'0123456789ABCDEF'"/>
	<xsl:value-of select="substring($hexdigits, $digit + 1, 1)"/>

</xsl:template>

<xsl:template name="zero-pad">
	<xsl:param name="num"/>
	<xsl:choose>
		<xsl:when test="string-length($num) &lt; 5">
            <xsl:call-template name="zero-pad">
				<xsl:with-param name="num" select="concat(&quot;0&quot;, $num)"/>
            </xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
            <xsl:value-of select="$num"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
  == gpx2gp.xsl
  ==
  == Converts Geocaching GPX files into gpspoint format files
  ==
  == Sample usage:
  ==    Xalan -o results.gp gpxdata.xml gpx2gp.xsl
  ==    Xalan -p extendedwp 1 -o results.gp gpxdata.xml gpx2gp.xsl
  ==
  ==    gpspoint -uw -if results.gp
  ==
  == Extended 10-character waypoint names:
  ==
  ==    GCABCD TMB
  ==           |||
  ==           ||+=== TravelBug=(B)ug, or empty
  ==           |+==== Size=(M)icro,(S)mall,(R)egular,(L)arge,(O)ther,
  ==                       (V)irtual,(N)ot chosen, or empty
  ==           +===== Type=(T)raditional,(M)ulti,(E)vent,m(Y)stery,
  ==                       (L)etterbox,(W)ebcam,(V)irtual,
  ==                       (R)everse/locationless,(U)nknown
  ==                       (X)archived or unavailable
  ==
  ==    gpx/wpt/name  GCXXXX
  ==
  ==    gpx/wpt/sym   "Geocache" or "Geocache Found"
  ==
  ==    gpx/wpt/groundspeak:type        Traditional Cache
  ==                                    Multicache
  ==                                    Event/CITO Cache
  ==                                    Mystery Cache
  ==                                    Letterbox
  ==                                    Webcam Cache
  ==                                    Virtual Cache
  ==
  ==    gpx/wpt/groundspeak:container   Micro, Small, Regular, Large
  ==
  ==    gpx/wpt/groundspeak:travelbugs/groundspeak:travelbug
  ==
  == This stylesheet is hereby granted to the public domain.
  ==
  == Release 2.  Beej Jorgensen, June 2005.  beej@beej.us
-->

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:gpx="http://www.topografix.com/GPX/1/0"
xmlns:groundspeak="http://www.groundspeak.com/cache/1/0">

<!-- set param extendedwp to 1 to get the 10-char waypoint annotations -->
<xsl:param name="extendedwp" select="0"/>

<xsl:output method="text"/>

<xsl:strip-space elements="*"/>

<!-- root node -->
<xsl:template match="/gpx:gpx">
	<xsl:text>type="waypointlist"&#x0A;</xsl:text>
	<xsl:apply-templates select="./gpx:wpt"/>
	<xsl:text>type="waypointlistend"&#x0A;</xsl:text>
</xsl:template>

<!-- waypoint node -->
<xsl:template match="/gpx:gpx/gpx:wpt">
	<xsl:text>type="waypoint"</xsl:text>
	<xsl:text> latitude="</xsl:text>
	<xsl:value-of select="./@lat"/>		<!-- lat -->
	<xsl:text>" longitude="</xsl:text>
	<xsl:value-of select="./@lon"/>		<!-- lon -->
	<xsl:text>"</xsl:text>
	<xsl:apply-templates select="./gpx:name"/>
	<xsl:text> comment="</xsl:text>		<!-- comment (description) -->
	<xsl:call-template name="change-quotes">
		<xsl:with-param name="string" select="./gpx:desc"/>
	</xsl:call-template>
	<xsl:text>"</xsl:text>
	<xsl:text> symbol="</xsl:text>		<!-- symbol -->
	<xsl:variable name="symbol">
		<xsl:value-of select="./gpx:sym"/>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$symbol='Geocache'">
			<xsl:text>geocache</xsl:text>
		</xsl:when>
		<xsl:when test="$symbol='Geocache Found'">
			<xsl:text>geocache_found</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>wpt_dot</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>" display_option="symbol+name"&#x0A;</xsl:text> <!-- misc -->
</xsl:template>

<!-- name node; also do extended waypoint names here -->
<xsl:template match="/gpx:gpx/gpx:wpt/gpx:name">
	<xsl:text> name="</xsl:text>

	<xsl:if test="$extendedwp = 0">
		<xsl:value-of select="."/>
	</xsl:if>

	<xsl:if test="$extendedwp = 1">
		<xsl:value-of select="."/>
		<xsl:text> </xsl:text>

		<xsl:variable name="type">
			<xsl:value-of select="../groundspeak:cache/groundspeak:type"/>
		</xsl:variable>
		<xsl:variable name="size">
			<xsl:value-of select="../groundspeak:cache/groundspeak:container"/>
		</xsl:variable>
		<xsl:variable name="travelbug">
			<xsl:value-of select="../groundspeak:cache/groundspeak:travelbugs/groundspeak:travelbug/@id"/>
		</xsl:variable>

		<xsl:variable name="archived">
			<xsl:value-of select="../groundspeak:cache/@archived"/>
		</xsl:variable>
		<xsl:variable name="available">
			<xsl:value-of select="../groundspeak:cache/@available"/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$archived='True' or $available='False'">
				<xsl:text>X</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$type='Traditional Cache'">
						<xsl:text>T</xsl:text>
					</xsl:when>
					<xsl:when test="$type='Multi-cache'">
						<xsl:text>M</xsl:text>
					</xsl:when>
					<xsl:when test="$type='Event/CITO Cache'">
						<xsl:text>E</xsl:text>
					</xsl:when>
					<xsl:when test="$type='Mystery Cache'">
						<xsl:text>Y</xsl:text>
					</xsl:when>
					<xsl:when test="$type='Letterbox Hybrid'">
						<xsl:text>L</xsl:text>
					</xsl:when>
					<xsl:when test="$type='Webcam Cache'">
						<xsl:text>W</xsl:text>
					</xsl:when>
					<xsl:when test="$type='Unknown Cache'">
						<xsl:text>U</xsl:text>
					</xsl:when>
					<xsl:when test="$type='Virtual Cache'">
						<xsl:text>V</xsl:text>
					</xsl:when>
					<xsl:when test="$type='Locationless (Reverse) Cache'">
						<xsl:text>R</xsl:text>
					</xsl:when>
					<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="$size='Micro'">
				<xsl:text>M</xsl:text>
			</xsl:when>
			<xsl:when test="$size='Small'">
				<xsl:text>S</xsl:text>
			</xsl:when>
			<xsl:when test="$size='Regular'">
				<xsl:text>R</xsl:text>
			</xsl:when>
			<xsl:when test="$size='Large'">
				<xsl:text>L</xsl:text>
			</xsl:when>
			<xsl:when test="$size='Other'">
				<xsl:text>O</xsl:text>
			</xsl:when>
			<xsl:when test="$size='Virtual'">
				<xsl:text>V</xsl:text>
			</xsl:when>
			<xsl:when test="$size='Not chosen'">
				<xsl:text>N</xsl:text>
			</xsl:when>
			<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
		</xsl:choose>

		<xsl:if test="$travelbug!=''"><xsl:text>B</xsl:text></xsl:if>

	</xsl:if>

	<xsl:text>"</xsl:text>
</xsl:template>

<!-- convert quotes to single-quotes -->
<xsl:template name="change-quotes">
	<xsl:param name="string"/>
	<xsl:variable name="singlequote"><xsl:text>'</xsl:text></xsl:variable>
	<xsl:value-of select="translate($string, '&quot;', $singlequote)"/>
</xsl:template>

</xsl:stylesheet>

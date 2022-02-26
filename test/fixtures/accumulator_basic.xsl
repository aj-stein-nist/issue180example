<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:mode use-accumulators="#all"/>
    
    <xsl:accumulator name="total-items" as="map(xs:string, xs:integer)" initial-value="map{}" streamable="no">
        <xsl:accumulator-rule match="/example/*">
            <xsl:variable name="key" select="(@name,.) => string-join(':')"/>
            <xsl:choose>
                <xsl:when test="map:contains($value, $key)">
                    <xsl:sequence select="map:put($value, string($key), $value($key)+1)"></xsl:sequence>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="map:put($value, string($key), 1)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:accumulator-rule>
    </xsl:accumulator>
    
    <xsl:template match="/">
        <xsl:variable name="total-items-count" select="accumulator-after('total-items')"/>
        <query type="sums">
            <xsl:for-each select="map:keys($total-items-count)">
                <sum key="{.}" count="{ map:get($total-items-count, .) }"/>
            </xsl:for-each>
        </query>
    </xsl:template>
</xsl:stylesheet>
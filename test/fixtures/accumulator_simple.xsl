<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:iterate select="/example/*">
            <xsl:param name="totals" as="map(xs:string, xs:integer)" select="map{}"/>
            <xsl:on-completion>
                <query type="sums">
                    <xsl:for-each select="map:keys($totals)">
                        <sum key="{.}" count="{ map:get($totals, .) }"/>
                    </xsl:for-each>
                </query>
            </xsl:on-completion>
            <xsl:variable name="key" select="(@name,.) => string-join(':')"/>
            <xsl:variable name="new-totals" as="map(xs:string, xs:integer)" select="
                if (map:contains($totals, $key))
                then
                map:put($totals, string($key), $totals($key)+1)
                else
                map:put($totals, string($key), 1)"/>
            <xsl:next-iteration>
                <xsl:with-param name="totals" select="$new-totals"/>
            </xsl:next-iteration>
        </xsl:iterate>
    </xsl:template>
</xsl:stylesheet>
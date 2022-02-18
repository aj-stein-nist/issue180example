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
    
    <xsl:accumulator name="total-items" as="xs:integer" initial-value="0" streamable="no">
        <xsl:accumulator-rule match="//type1" select="$value + 1"/>
    </xsl:accumulator>
    
    <xsl:variable name="total-items-count" select="accumulator-after('total-items')"/>
    
    <xsl:template match="/">
        <query type="sums">
            <sum key="type1" count="{ $total-items-count }"/>
        </query>
    </xsl:template>
</xsl:stylesheet>
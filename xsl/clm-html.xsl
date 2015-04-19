<?xml version='1.0'?> <!-- As XML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Thin layer on MathBook XML -->
<xsl:import href="/Users/alexjordan/mathbook/xsl/mathbook-html.xsl" />

<!-- Common thin layer                                                      -->
<xsl:import href="clm-common.xsl" />


<!-- description lists -->
<xsl:template match="dl">
    <xsl:element name="ul">
        <xsl:attribute name="style">
            <xsl:text>list-style-type: </xsl:text>
            <xsl:choose>
                <xsl:when test="@label">
                    <xsl:apply-templates select="." mode="html-unordered-list-label" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="html-unordered-list-label-default" />
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>;</xsl:text>
        </xsl:attribute>
        <xsl:choose>
            <xsl:when test="@cols">
                <xsl:apply-templates select="li" mode="variable-width">
                    <xsl:with-param name="percent-width" select="90 div @cols" />
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="li" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:element>
    <xsl:if test="@cols">
        <div style="clear:both;"></div>
    </xsl:if>
</xsl:template>
<xsl:template match="dl/li" mode="variable-width">
    <xsl:param name="percent-width" />
    <xsl:element name="li">
        <xsl:attribute name="style">
            <xsl:text>width:</xsl:text><xsl:value-of select="$percent-width" /><xsl:text>%; float:left;</xsl:text>
            <xsl:if test="(position() mod ../@cols) = 1">
                <xsl:text>clear: left;</xsl:text>
            </xsl:if>
        </xsl:attribute>
       <xsl:apply-templates />
    </xsl:element>
</xsl:template>
<xsl:template match="dl/li/title">
    <xsl:apply-templates />
    <br />
</xsl:template>

<xsl:template name="type-name">
    <xsl:param name="string-id" />
    <xsl:variable name="translation">
        <xsl:for-each select="document('../../mathbook/xsl/mathbook-localization.xsl')">
            <xsl:value-of select="key('localization-key', concat($document-language,$string-id) )"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="$string-id='chapter'">Lab</xsl:when>
        <xsl:when test="$string-id='section'">Activity</xsl:when>
        <xsl:when test="$translation!=''"><xsl:value-of select="$translation" /></xsl:when>
        <xsl:otherwise>
            <xsl:text>[</xsl:text>
            <xsl:value-of select="$string-id" />
            <xsl:text>]&#xa;</xsl:text>
            <xsl:message>MBX:WARNING: could not translate string with id "<xsl:value-of select="$string-id" />" into language for code "<xsl:value-of select="$document-language" />"</xsl:message>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- For tables, move caption above                -->
<!-- MBX "table" is a displayed, captioned, numbered object      -->
<!-- Implemented as an HTML figure, but caption will say "Table" -->
<!-- Numbered in sequence with real figures and other tables     -->
<!-- Contents should always be a "tabular" element               -->
<xsl:template match="table">
    <xsl:element name="figure">
        <xsl:variable name="ident">
          <xsl:apply-templates select="." mode="internal-id" />
        </xsl:variable>
        <xsl:attribute name="id"><xsl:value-of select="$ident"/></xsl:attribute>
        <!-- side by side figures can accept additional attributes -->
        <xsl:if test="ancestor::sidebyside">
            <xsl:call-template name="sidebysideCSS" select="."/>
        </xsl:if>
        <xsl:apply-templates select="caption" />
        <table class="center">
            <xsl:apply-templates select="*[not(self::caption)]" />
        </table>
    </xsl:element>
    <xsl:if test="ancestor::sidebyside">
       <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
</xsl:template>

<!-- Center captions  -->
<!-- Caption of a figure or table                  -->
<!-- All the relevant information is in the parent -->
<xsl:template match="caption">
    <figcaption style="text-align:center;">
        <!-- subfigure/subtable captions don't have 'Figure'/'Table' in the caption -->
        <xsl:if test="not(ancestor::sidebyside[count(caption)>0]) or local-name(..)='sidebyside'">
          <!-- regular figures, e.g Figure 1.3 or global captions for a collection of subfigures/subtables-->
            <span class="heading">
                <xsl:apply-templates select=".." mode="type-name"/>
            </span>
        </xsl:if>
        <span class="codenumber">
            <xsl:apply-templates select=".." mode="number"/>
        </span>
        <xsl:apply-templates />
    </figcaption>
</xsl:template>

<!-- For prefaces, skip codenumber                         --> 
<!-- Both environments and sections have a "type,"         -->
<!-- a "codenumber," and a "title."  We format these       -->
<!-- consistently here with a modal template.  We can hide -->
<!-- components with classes on the enclosing "heading"    -->
<xsl:template match="*" mode="header-content">
    <span class="type">
        <xsl:apply-templates select="." mode="type-name" />
    </span>
    <xsl:if test="not(*[parent::preface])">
        <span class="codenumber">
            <xsl:apply-templates select="." mode="number" />
        </span>
    </xsl:if>
    <span class="title">
        <xsl:apply-templates select="." mode="title-full" />
    </span>
</xsl:template>



<!-- Give (null) meaning to \tikzmark in math mode, used in PDF -->
<!-- LaTeX Macros -->
<!-- In a hidden div, for near the top of the page -->
<xsl:template name="latex-macros">
    <xsl:if test="/mathbook/docinfo/macros">
        <div style="display:none;">
        <xsl:text>\(</xsl:text>
        <xsl:value-of select="/mathbook/docinfo/macros" />
        <xsl:text>\newcommand{\tikzmark}[1]{}</xsl:text>
        <xsl:text>\)</xsl:text>
        </div>
    </xsl:if>
</xsl:template>

<!-- annotate, only defined for latex, not html; to be used after a math mode with \tikzmark in it -->
<!-- contents should use the \Annotate command, defined in image macros                            -->
<xsl:template match="annotate" />

<!-- change default size of figures -->
<!-- Figures and their captions -->
<!-- TODO: class="wrap" is possible -->
<xsl:template match="figure">
    <xsl:element name="figure">
        <xsl:variable name="ident">
          <xsl:apply-templates select="." mode="internal-id" />
        </xsl:variable>
        <xsl:attribute name="id"><xsl:value-of select="$ident"/></xsl:attribute>
        <xsl:attribute name="style">width:50%;</xsl:attribute>
        <!-- side by side figures can accept additional attributes -->
        <xsl:if test="ancestor::sidebyside">
            <xsl:call-template name="sidebysideCSS" select="."/>
        </xsl:if>
        <!-- regular figure, no subfigures -->
        <xsl:apply-templates select="*[not(self::caption)]"/>
        <xsl:apply-templates select="caption"/>
    </xsl:element>
    <xsl:if test="ancestor::sidebyside">
       <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:if>
</xsl:template>


</xsl:stylesheet>

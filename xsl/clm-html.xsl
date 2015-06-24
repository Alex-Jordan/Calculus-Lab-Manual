<?xml version='1.0'?> <!-- As XML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Thin layer on MathBook XML -->
<xsl:import href="/Users/alexjordan/mathbook/xsl/mathbook-html.xsl" />

<!-- Common thin layer                                                      -->
<xsl:import href="clm-common.xsl" />

<xsl:param name="exercise.backmatter.answer" select="'no'" />
<xsl:param name="exercise.backmatter.solution" select="'yes'" />
<xsl:param name="html.css.extra"  select="'../style/css/clm.css'" />


<!-- GeoGebra HTML5-->
<xsl:template match="geogebra-html5">
    <xsl:text>This GeoGebra applet requires an internet connection.</xsl:text>
    <xsl:element name="iframe">
        <xsl:attribute name="scrolling">
            <xsl:text>no</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="style">
            <xsl:text>border:0px;</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="src">
            <xsl:value-of select="@src"/>
        </xsl:attribute>
        <xsl:attribute name="width">
            <xsl:value-of select="@width"/>
        </xsl:attribute>
        <xsl:attribute name="height">
            <xsl:value-of select="@height"/>
        </xsl:attribute>
    </xsl:element>
</xsl:template>


<!-- webwork -->
<xsl:template match="webwork">
<!--    <xsl:element name="script">
        <xsl:attribute name="src">
            <xsl:text>http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js</xsl:text>
        </xsl:attribute>
    </xsl:element>
    <xsl:element name="script">
        <xsl:text>$(document).ready(function(){&#xa;</xsl:text>
        <xsl:text>$( ".clickme" ).click(function() {&#xa;</xsl:text>
        <xsl:text>  $( this).next().slideToggle( "slow", function() {&#xa;</xsl:text>
        <xsl:text>        // Animation complete.&#xa;</xsl:text>
        <xsl:text>      });&#xa;</xsl:text>
        <xsl:text>    });&#xa;</xsl:text>
        <xsl:text>});</xsl:text>
    </xsl:element>
    <xsl:element name="style">
        <xsl:text>.clickme {background-color: #ccccFF ;}</xsl:text>
    </xsl:element>
    <xsl:element name="div">
        <xsl:attribute name="class">
            <xsl:text>clickme</xsl:text>
        </xsl:attribute>
        <xsl:text>Click here to reveal problem</xsl:text>
    </xsl:element>
-->    <xsl:element name="br"/>
    <xsl:element name="div">
        <xsl:attribute name="class">
            <xsl:text>wwproblem</xsl:text>
        </xsl:attribute>
<!--        <xsl:attribute name="style">
            <xsl:text>display: none;</xsl:text>
        </xsl:attribute>
-->    <xsl:element name="iframe">
        <xsl:attribute name="style">
            <xsl:text>height:600px; width:100%;</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="name">
            <xsl:text>Stack</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="src">
            <xsl:text>https://hosted2.webwork.rochester.edu/webwork2/html2xml?</xsl:text>
            <xsl:text>&amp;answersSubmitted=0</xsl:text>
            <xsl:text>&amp;sourceFilePath=</xsl:text>
            <xsl:value-of select="@src"/>
            <xsl:text>&amp;problemSeed=112358</xsl:text>
            <xsl:text>&amp;courseID=2014_07_UR_demo</xsl:text>
            <xsl:text>&amp;userID=daemon</xsl:text>
            <xsl:text>&amp;password=daemon</xsl:text>
            <xsl:text>&amp;outputformat=simple</xsl:text>
        </xsl:attribute>
    </xsl:element>
    </xsl:element>
</xsl:template>

        

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
    <xsl:if test="not(*[parent::preface]) and not(*[parent::acknowledgement]) and not(*[parent::colophon])">
        <span class="codenumber">
            <xsl:apply-templates select="." mode="number" />
        </span>
    </xsl:if>
    <span class="title">
        <xsl:apply-templates select="." mode="title-full" />
    </span>
</xsl:template>




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

<xsl:template match="exercise" mode="backmatter">
    <xsl:if test="hint or answer or solution">
        <!-- Lead with the problem number and some space -->
        <xsl:variable name="xref">
            <xsl:apply-templates select="." mode="internal-id" />
        </xsl:variable>
        <article class="exercise-like" id="{$xref}">
            <xsl:if test="$exercise.backmatter.statement='yes'">
                <!-- TODO: not a "backmatter" template - make one possibly? Or not necessary -->
                <xsl:apply-templates select="statement" />
            </xsl:if>
            <xsl:if test="hint and $exercise.backmatter.hint='yes'">
                <xsl:apply-templates select="hint" mode="backmatter" />
            </xsl:if>
            <xsl:if test="answer and $exercise.backmatter.answer='yes'">
                <xsl:apply-templates select="answer" mode="backmatter" />
            </xsl:if>
            <xsl:if test="solution and $exercise.backmatter.solution='yes'">
                <xsl:apply-templates select="solution" mode="backmatter" />
            </xsl:if>
        </article>
    </xsl:if>
</xsl:template>

<!-- an answer-only list -->
<xsl:template match="answer-list">
    <xsl:apply-templates select="//exercises" mode="answerlist" />
</xsl:template>
<xsl:template match="exercises" mode="answerlist">
    <xsl:variable name="nonempty" select="(.//hint and $exercise.backmatter.hint='yes') or
                                          (.//answer and $exercise.backmatter.answer='yes') or
                                          (.//solution and $exercise.backmatter.solution='yes')" />
    <xsl:if test="$nonempty='true'">
        <section class="exercises" id="">
            <h1 class="heading">
                <span class="type">Exercises</span>
                <span class="codenumber"><xsl:apply-templates select="." mode="number" /></span>
                <span class="title"><xsl:apply-templates select="title-full" /></span>
            </h1>
            <xsl:apply-templates select="*[not(self::title)]" mode="answerlist" />
        </section>
    </xsl:if>
</xsl:template>
<xsl:template match="exercises//introduction|exercises//conclusion" mode="answerlist" />
<xsl:template match="exercise" mode="answerlist">
    <xsl:if test="hint or answer or solution">
        <!-- Lead with the problem number and some space -->
        <xsl:variable name="xref">
            <xsl:apply-templates select="." mode="internal-id" />
        </xsl:variable>
        <article class="exercise-like" id="{$xref}">
            <xsl:if test="answer">
                <xsl:apply-templates select="answer" mode="backmatter" />
            </xsl:if>
        </article>
    </xsl:if>
</xsl:template>


<xsl:template match="alert">
    <span class="alert">
    <xsl:apply-templates />
    </span>
</xsl:template>


</xsl:stylesheet>

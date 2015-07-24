<?xml version='1.0'?> <!-- As XML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Thin layer on MathBook XML -->
<xsl:import href="/Users/alexjordan/mathbook/xsl/mathbook-html.xsl" />

<!-- Common thin layer                                                      -->
<xsl:import href="clm-common.xsl" />

<xsl:param name="exercise.backmatter.hint" select="'no'" />
<xsl:param name="exercise.backmatter.answer" select="'no'" />
<xsl:param name="exercise.backmatter.solution" select="'yes'" />
<xsl:param name="exercise.text.hint" select="'yes'" />
<xsl:param name="exercise.text.answer" select="'no'" />
<xsl:param name="exercise.text.solution" select="'no'" />
<xsl:param name="html.css.extra"  select="'../style/css/clm.css'" />
<xsl:param name="html.knowl.example" select="'no'" />

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


<!-- For tables, move caption above                -->
<xsl:template match="table" mode="body">
    <xsl:apply-templates select="caption"/>
    <xsl:apply-templates select="*[not(self::caption)]"/>
</xsl:template>


<!-- Center captions  -->
<!-- Caption of a numbered figure or table         -->
<!-- All the relevant information is in the parent -->
<xsl:template match="caption">
    <figcaption style="text-align:center">
        <span class="heading">
            <xsl:apply-templates select="parent::*" mode="type-name"/>
        </span>
        <span class="codenumber">
            <xsl:apply-templates select="parent::*" mode="number"/>
        </span>
        <xsl:apply-templates />
    </figcaption>
</xsl:template>
<!-- Caption'ed sidebyside indicate subfigures and subtables are subsidiary -->
<!-- so we number with just their serial number, a formatted (a), (b), (c), -->
<xsl:template match="sidebyside[caption]/figure/caption|sidebyside[caption]/table/caption">
    <figcaption style="text-align:center">
        <span class="codenumber">
            <xsl:apply-templates select="parent::*" mode="serial-number"/>
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

<!-- Adjust image widths depending on surrounding figures and sidebysides-->
<!-- A wrapper for SVG images w/ optional fallback -->
<!-- object element seems fine for HTML            -->
<!-- but SageMathCloud prefers img element         -->
<xsl:template match="*" mode="svg-wrapper">
    <xsl:param name="png-fallback" />
    <xsl:element name="object">
        <xsl:attribute name="type">image/svg+xml</xsl:attribute>
        <xsl:choose>
            <xsl:when test="ancestor::figure and not(ancestor::sidebyside)">
                <xsl:attribute name="style">width:48%; margin:auto;</xsl:attribute>
            </xsl:when>
            <xsl:when test="not(ancestor::figure) and ancestor::sidebyside">
                <xsl:attribute name="style">width:48%; margin:auto;</xsl:attribute>
            </xsl:when>
            <xsl:when test="ancestor::figure and ancestor::sidebyside">
                <xsl:attribute name="style">width:90%; margin:auto;</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="style">width:48%; margin:auto;</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:attribute name="data">
            <xsl:value-of select="$directory.images" />
            <xsl:text>/</xsl:text>
            <xsl:apply-templates select=".." mode="internal-id" />
            <xsl:text>.svg</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates select="../description" />
        <xsl:choose>
            <xsl:when test="$png-fallback = 'yes'">
                <xsl:element name="img">
                    <xsl:attribute name="src">
                        <xsl:value-of select="$directory.images" />
                        <xsl:text>/</xsl:text>
                        <xsl:apply-templates select=".." mode="internal-id" />
                        <xsl:text>.png</xsl:text>
                    </xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <p style="margin:auto">&lt;&lt;Your browser is unable to render this SVG image&gt;&gt;</p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:element>
</xsl:template>

<!--Put magnitudes in math mode -->
<!-- Magnitude                                      -->
<xsl:template match="mag">
    <xsl:if test="not(parent::quantity)">
        <xsl:message>MBX:WARNING: mag element should have parent quantity element</xsl:message>
    </xsl:if>
    <xsl:text>\(</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\)</xsl:text>
</xsl:template>


<xsl:template match="alert">
    <span class="alert">
    <xsl:apply-templates />
    </span>
</xsl:template>

<xsl:template match="centerline">
    <xsl:apply-templates />
</xsl:template>

<xsl:template match="exercises//exercise" mode="xref-number">
    <xsl:apply-templates select="." mode="serial-number" />
</xsl:template>

</xsl:stylesheet>

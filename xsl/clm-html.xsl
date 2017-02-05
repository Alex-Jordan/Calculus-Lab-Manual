<?xml version='1.0'?> <!-- As XML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Thin layer on MathBook XML -->
<xsl:import href="/Users/alex.jordan/mathbook/xsl/mathbook-html.xsl" />

<!-- Common thin layer                                                      -->
<xsl:import href="clm-common.xsl" />

<xsl:param name="html.css.file" select="'mathbook-6.css'" />

<xsl:param name="exercise.backmatter.hint" select="'no'" />
<xsl:param name="exercise.backmatter.answer" select="'no'" />
<xsl:param name="exercise.backmatter.solution" select="'yes'" />
<xsl:param name="exercise.text.hint" select="'yes'" />
<xsl:param name="exercise.text.answer" select="'no'" />
<xsl:param name="exercise.text.solution" select="'no'" />
<xsl:param name="html.css.extra"  select="'css/clm.css'" />
<xsl:param name="html.knowl.example" select="'no'" />



<!-- GeoGebra HTML5-->
<xsl:template match="geogebra-html5">
    <xsl:text>This GeoGebra applet requires an internet connection.</xsl:text>
    <xsl:element name="iframe">
        <xsl:attribute name="scrolling">
            <xsl:text>no</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="class">
            <xsl:text>geogebra</xsl:text>
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


<!-- For tables, move caption above                    -->
<!-- would only affect captions on tables not in a sbs -->
<!--
<xsl:template match="table" mode="body">
    <xsl:apply-templates select="caption"/>
    <xsl:apply-templates select="*[not(self::caption)]"/>
</xsl:template>
-->


<!-- Create alternate image format links -->
<!-- A named template creates the infrastructure for an SVG image -->
<!-- Parameters                                 -->
<!-- svg-filename: required, full relative path -->
<!-- png-fallback-filename: optional            -->
<!-- image-width: required                      -->
<!-- image-description: optional                -->
<xsl:template name="svg-wrapper">
    <xsl:param name="svg-filename" />
    <xsl:param name="png-fallback-filename" select="''" />
    <xsl:param name="image-width" />
    <xsl:param name="image-description" select="''" />
    <xsl:element name="div">
        <xsl:attribute name="class">
            <xsl:text>svg-and-links</xsl:text>
        </xsl:attribute>
        <xsl:element name="object">
            <!-- type attribute for object element -->
            <xsl:attribute name="type">image/svg+xml</xsl:attribute>
            <!-- style attribute, should be class + CSS -->
            <xsl:attribute name="style">
                <xsl:text>width:</xsl:text>
                <xsl:value-of select="$image-width" />
                <xsl:text>; </xsl:text>
                <xsl:text>margin:auto; display:block;</xsl:text>
            </xsl:attribute>
            <!-- data attribute for object element, the SVG image -->
            <xsl:attribute name="data">
                <xsl:value-of select="$svg-filename" />
            </xsl:attribute>
            <!-- alt attribute for accessibility -->
            <xsl:attribute name="alt">
                <xsl:value-of select="$image-description" />
            </xsl:attribute>
            <!-- content is PNG fallback, if available, else message -->
            <xsl:choose>
                <xsl:when test="$png-fallback-filename = ''">
                    <p style="margin:auto">&lt;&lt;SVG image is unavailable, or your browser cannot render it&gt;&gt;</p>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="img">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$png-fallback-filename" />
                       </xsl:attribute>
                        <xsl:attribute name="width">
                            <xsl:value-of select="$image-width" />
                        </xsl:attribute>
                        <!-- alt attribute for accessibility -->
                        <xsl:attribute name="alt">
                            <xsl:value-of select="$image-description" />
                        </xsl:attribute>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>

        <xsl:element name="div">
            <xsl:attribute name="class">
                <xsl:text>image-links</xsl:text>
            </xsl:attribute>
            <xsl:element name="ul">
                <xsl:attribute name="class">
                    <xsl:text>image-link-list</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>width:100%</xsl:text>
                </xsl:attribute>
                <xsl:element name="li">
                    <xsl:attribute name="class">image-link-item</xsl:attribute>
                        <xsl:element name="a">
                        <xsl:attribute name="class">image-link</xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$directory.images" />
                            <xsl:text>/</xsl:text>
                            <xsl:apply-templates select="." mode="internal-id" />
                            <xsl:text>.png</xsl:text>
                        </xsl:attribute>
    
                        <!-- Leave PNG so that a tab opens -->
                        <!-- <xsl:attribute name="download">
                            <xsl:apply-templates select="." mode="internal-id" />
                            <xsl:text>.png</xsl:text>
                        </xsl:attribute> -->
    
                        <xsl:attribute name="target">
                            <xsl:text>_blank</xsl:text>
                        </xsl:attribute>
                        <xsl:text>png</xsl:text>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="li">
                    <xsl:attribute name="class">image-link-item</xsl:attribute>
                        <xsl:element name="a">
                        <xsl:attribute name="class">image-link</xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$directory.images" />
                            <xsl:text>/</xsl:text>
                            <xsl:apply-templates select="." mode="internal-id" />
                            <xsl:text>.eps</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="download">
                            <xsl:apply-templates select="." mode="internal-id" />
                            <xsl:text>.eps</xsl:text>
                        </xsl:attribute>
                        <xsl:text>eps</xsl:text>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="li">
                    <xsl:attribute name="class">image-link-item</xsl:attribute>
                        <xsl:element name="a">
                        <xsl:attribute name="class">image-link</xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$directory.images" />
                            <xsl:text>/</xsl:text>
                            <xsl:apply-templates select="." mode="internal-id" />
                            <xsl:text>.svg</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="download">
                            <xsl:apply-templates select="." mode="internal-id" />
                            <xsl:text>.svg</xsl:text>
                        </xsl:attribute>
                        <xsl:text>svg</xsl:text>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="li">
                    <xsl:attribute name="class">image-link-item</xsl:attribute>
                        <xsl:element name="a">
                        <xsl:attribute name="class">image-link</xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$directory.images" />
                            <xsl:text>/</xsl:text>
                            <xsl:apply-templates select="." mode="internal-id" />
                            <xsl:text>.pdf</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="download">
                            <xsl:apply-templates select="." mode="internal-id" />
                            <xsl:text>.pdf</xsl:text>
                        </xsl:attribute>
                        <xsl:text>pdf</xsl:text>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="li">
                    <xsl:attribute name="class">image-link-item</xsl:attribute>
                        <xsl:element name="a">
                        <xsl:attribute name="class">image-link</xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$directory.images" />
                            <xsl:text>/</xsl:text>
                            <xsl:apply-templates select="." mode="internal-id" />
                            <xsl:text>.tex</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="download">
                            <xsl:apply-templates select="." mode="internal-id" />
                            <xsl:text>.tex</xsl:text>
                        </xsl:attribute>
                        <xsl:text>tex</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:element>
</xsl:template>

<!--Put magnitudes entirely in math mode -->
<!-- Magnitude                                      -->
<xsl:template match="mag">
    <xsl:text>\(</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\)</xsl:text>
</xsl:template>

<xsl:template match="shortlicense">
    <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
</xsl:template>

</xsl:stylesheet>

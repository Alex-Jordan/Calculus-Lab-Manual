<?xml version='1.0'?> <!-- As XML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Thin layer on MathBook XML -->
<xsl:import href="/Users/alexjordan/mathbook/xsl/mathbook-html.xsl" />

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


<!-- Suppress "Lab .1" from the backmatter solutions chapter -->
<xsl:template match="backmatter/chapter" mode="header-content">
    <span class="title">
        <xsl:apply-templates select="." mode="title-full" />
    </span>
    <xsl:apply-templates select="." mode="permalink" />
</xsl:template>
<xsl:template match="backmatter/chapter" mode="summary-nav">
        <xsl:variable name="url"><xsl:apply-templates select="." mode="url" /></xsl:variable>
        <a href="{$url}">
            <span class="title">
                <xsl:apply-templates select="." mode="title-simple" />
            </span>
        </a>
</xsl:template>



<!-- Suppress "Activity ..1" from the frontmatter prefaces' sections -->
<xsl:template match="frontmatter//section" mode="header-content">
    <span class="title">
        <xsl:apply-templates select="." mode="title-full" />
    </span>
    <xsl:apply-templates select="." mode="permalink" />
</xsl:template>


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


<!-- For tables, move caption above                -->
<!--
<xsl:template match="table" mode="body">
    <xsl:apply-templates select="caption"/>
    <xsl:apply-templates select="*[not(self::caption)]"/>
</xsl:template>
-->


<!-- For prefaces, skip codenumber                         --> 
<!-- Both environments and sections have a "type,"         -->
<!-- a "codenumber," and a "title."  We format these       -->
<!-- consistently here with a modal template.  We can hide -->
<!-- components with classes on the enclosing "heading"    -->
<!--
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
-->


<!-- Add a min-width attribute in pixels for side by side panels -->
<!-- Also, kill space between and handle with CSS -->
<!-- TODO: study "image" template and consolidate -->
<!-- TODO: convert to a match="" template and break up conditionals -->
<!--
<xsl:template name="sidebysideCSS">
-->
  <!-- paragraphs have their own class -->
<!--  <xsl:if test="not(self::paragraphs)">
    <xsl:choose>
-->
        <!-- first child is class="left" -->
<!--        <xsl:when test="not(preceding-sibling::figure or preceding-sibling::image or preceding-sibling::paragraphs or preceding-sibling::p or preceding-sibling::table or preceding-sibling::tabular)">
          <xsl:attribute name="class">left</xsl:attribute>
        </xsl:when>
-->
        <!-- last child is class="right" -->
<!--        <xsl:when test="not(following-sibling::figure or following-sibling::image or following-sibling::paragraphs or following-sibling::p or following-sibling::table or following-sibling::tabular)">
          <xsl:attribute name="class">right</xsl:attribute>
        </xsl:when>
-->
        <!-- middle children are class="middle" -->
<!--        <xsl:otherwise>
          <xsl:attribute name="class">middle</xsl:attribute>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:attribute name="style">
  <xsl:text>width:</xsl:text>
-->
  <!-- if width is defined, then use it -->
<!--  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="@width">
          <xsl:value-of select="substring-before(@width,'%')"/>
      </xsl:when>
      <xsl:otherwise>
-->
          <!-- calculate widths that have been specified
             and auto-print a remaining width -->
<!--               <xsl:call-template name="printWidth" select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
-->
  <!-- Allow for 2% CSS padding between each pair -->
<!--  <xsl:value-of select="$width - 2"/>
  <xsl:text>%</xsl:text>
  <xsl:text>;</xsl:text>
-->
  <!-- add min-width -->
<!--  <xsl:text>min-width:</xsl:text>
  <xsl:value-of select="floor(($width)*0.01*470)"/>
  <xsl:text>px</xsl:text>
  <xsl:text>;</xsl:text>
-->
  <!-- vertical alignment option -->
<!--  <xsl:text>vertical-align:</xsl:text>
  <xsl:choose>
    <xsl:when test="@valign">
      <xsl:value-of select="@valign"/>
    </xsl:when>
-->
    <!-- default -->
<!--    <xsl:otherwise>
      <xsl:text>bottom</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>;</xsl:text>
-->
  <!-- horizontal alignment option -->
<!--  <xsl:text>text-align:</xsl:text>
  <xsl:choose>
    <xsl:when test="@halign">
      <xsl:value-of select="@halign"/>
    </xsl:when>
-->
    <!-- default -->
<!--    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="not(self::paragraphs or self::p)">
            <xsl:text>center</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>left</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>;</xsl:text>
  </xsl:attribute>
</xsl:template>
-->

<!-- Adjust image widths depending on surrounding figures and sidebysides-->
<!-- Also, create PNG and EPS links                                      -->
<!-- A wrapper for SVG images w/ optional fallback -->
<!-- object element seems fine for HTML            -->
<!-- but SageMathCloud prefers img element         -->
<!--<xsl:template match="*" mode="svg-wrapper">
    <xsl:param name="png-fallback" />
-->
    <!-- div to contain svg and links -->
<!--    <xsl:element name="div">
        <xsl:attribute name="class">
            <xsl:text>svg-and-links</xsl:text>
        </xsl:attribute>

        <xsl:element name="object">
            <xsl:attribute name="type">image/svg+xml</xsl:attribute>
            <xsl:attribute name="style">
                <xsl:text>width: 100%;</xsl:text>
            </xsl:attribute>
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
                        <xsl:apply-templates select=".." mode="internal-id" />
                        <xsl:text>.png</xsl:text>
                    </xsl:attribute>
-->
                    <!-- Leave PNG so that a tab opens -->
                    <!-- <xsl:attribute name="download">
                        <xsl:apply-templates select=".." mode="internal-id" />
                        <xsl:text>.png</xsl:text>
                    </xsl:attribute> -->
<!--
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
                        <xsl:apply-templates select=".." mode="internal-id" />
                        <xsl:text>.eps</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="download">
                        <xsl:apply-templates select=".." mode="internal-id" />
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
                        <xsl:apply-templates select=".." mode="internal-id" />
                        <xsl:text>.svg</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="download">
                        <xsl:apply-templates select=".." mode="internal-id" />
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
                        <xsl:apply-templates select=".." mode="internal-id" />
                        <xsl:text>.pdf</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="download">
                        <xsl:apply-templates select=".." mode="internal-id" />
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
                        <xsl:apply-templates select=".." mode="internal-id" />
                        <xsl:text>.tex</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="download">
                        <xsl:apply-templates select=".." mode="internal-id" />
                        <xsl:text>.tex</xsl:text>
                    </xsl:attribute>
                    <xsl:text>tex</xsl:text>
                </xsl:element>
            </xsl:element>
        </xsl:element>
        </xsl:element>

    </xsl:element>
</xsl:template>
-->


<!--Put magnitudes in math mode -->
<!-- Magnitude                                      -->
<!--
<xsl:template match="mag">
    <xsl:if test="not(parent::quantity)">
        <xsl:message>MBX:WARNING: mag element should have parent quantity element</xsl:message>
    </xsl:if>
    <xsl:text>\(</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\)</xsl:text>
</xsl:template>
-->

<!--
<xsl:template match="centerline">
    <xsl:apply-templates />
</xsl:template>
-->

<!--
<xsl:template match="exercises//exercise" mode="xref-number">
    <xsl:apply-templates select="." mode="serial-number" />
</xsl:template>
-->

<!--
<xsl:template match="shortlicense">
    <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
</xsl:template>
-->

</xsl:stylesheet>

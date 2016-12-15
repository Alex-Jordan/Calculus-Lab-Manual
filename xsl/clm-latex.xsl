<?xml version='1.0'?> <!-- As XML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Thin layer on MathBook XML -->
<xsl:import href="/Users/alex.jordan/mathbook/xsl/mathbook-latex.xsl" />

<!-- Common thin layer                                                      -->
<xsl:import href="clm-common.xsl" />

<!-- Intend output for rendering by pdflatex -->
<xsl:output method="text" />

<!-- Templates added not existing in mathbook-latex.xsl -->
<!--                                                    -->


<!-- A list of short answers -->
<!--
<xsl:template match="answer-list">
    <xsl:text>\begin{multicols}{2}&#xa;</xsl:text>
    <xsl:apply-templates select="//exercises" mode="answerlist" />
    <xsl:text>\end{multicols}&#xa;</xsl:text>
</xsl:template>
<xsl:template match="exercises" mode="answerlist">
    <xsl:variable name="nonempty" select="(.//answer and $exercise.backmatter.answer='no')" />
    <xsl:if test="$nonempty='true'">
        <xsl:text>\</xsl:text>
        <xsl:apply-templates select="." mode="subdivision-name" />
        <xsl:text>*{</xsl:text>
        <xsl:apply-templates select="." mode="number" />
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="title" />
        <xsl:text>}&#xa;</xsl:text>
        <xsl:apply-templates select="*[not(self::title)]" mode="answerlist" />
    </xsl:if>
</xsl:template>
<xsl:template match="exercises//introduction|exercises//conclusion" mode="answerlist" />
<xsl:template match="exercise" mode="answerlist">
    <xsl:if test="answer">
-->        <!-- Lead with the problem number and some space -->
<!--        <xsl:text>\noindent\textbf{</xsl:text>
        <xsl:apply-templates select="." mode="origin-id" />
        <xsl:text>.}\quad{}</xsl:text>
        <xsl:if test="answer">
            <xsl:apply-templates select="answer" mode="backmatter" />
        </xsl:if>
    </xsl:if>
</xsl:template>
-->

<!-- GeoGebra HTML5-->
<!--
<xsl:template match="geogebra-html5">
    <xsl:text>{\textlangle}Use the online edition to explore a GeoGebra applet.\textrangle&#xa;</xsl:text> 
</xsl:template>
-->

<!-- Modifications to templates in mathbook-latex.xsl   -->
<!--                                                    -->


<!-- Put caption on top                             -->
<!-- A table is like a figure, centered, captioned  -->
<!-- The meat of the table is given by a tabular    -->
<!-- element, which may be used outside of a table  -->
<!-- Standard LaTeX table environment is redefined, -->
<!-- see preamble comments for details              -->

<xsl:template match="table">
    <xsl:apply-templates select="." mode="leave-vertical-mode" />
    <xsl:text>\begin{table}&#xa;</xsl:text>
    <xsl:text>\centering</xsl:text>
    <xsl:apply-templates select="caption" />
    <xsl:apply-templates select="*[not(self::caption)]" />
    <xsl:text>\end{table}&#xa;</xsl:text>
</xsl:template>

<!-- Prevent line breaks on inline math -->
<!-- Captions for Figures and Tables -->
<!-- xml:id is on parent, but LaTeX generates number with caption -->

<xsl:template match="caption">
    <xsl:choose>
      <xsl:when test="ancestor::sidebyside and ancestor::table and not(ancestor::sidebyside/caption)">
            <xsl:text>\captionof{table}{</xsl:text>
      </xsl:when>
      <xsl:when test="ancestor::sidebyside and ancestor::figure and not(ancestor::sidebyside/caption)">
            <xsl:text>\captionof{figure}{</xsl:text>
      </xsl:when>
      <xsl:otherwise>
          <xsl:text>\caption{</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>\binoppenalty=\maxdimen \relpenalty=\maxdimen </xsl:text>
    <xsl:apply-templates />
    <xsl:apply-templates select=".." mode="label" />
    <xsl:text>}&#xa;</xsl:text>
</xsl:template>

<!--<xsl:template match="exercises">-->
    <!-- Information to console for latex run -->
<!--    <xsl:text>\typeout{************************************************}&#xa;</xsl:text>
    <xsl:text>\typeout{Exercises}&#xa;</xsl:text>
    <xsl:text>\typeout{************************************************}&#xa;</xsl:text>
-->    <!-- Warn about paragraph deprecation -->
<!--    <xsl:text>\section*{Exercises}</xsl:text>
            <xsl:apply-templates select="." mode="label" />
            <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:if test="author">
        <xsl:text>\noindent{\Large\textbf{</xsl:text>
        <xsl:apply-templates select="author" mode="name-list"/>
        <xsl:text>}}\par\bigskip&#xa;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="introduction" />
-->    <!-- Process the remaining contents -->
<!--    <xsl:apply-templates select="*[not(self::title or self::author or self::introduction or self::conclusion)]"/>
    <xsl:apply-templates select="conclusion" />
</xsl:template>
-->



<!-- Introductions and conclusions get a \par at the end because otherwise there is occasional crowding-->

<xsl:template match="introduction|conclusion">
    <xsl:apply-templates />
    <xsl:text>\par&#xa;</xsl:text>
</xsl:template>


<!--Set the parskip in paragraphs manually to 0.5pc, which is what we've set for this document-->
<xsl:template match="paragraphs" mode="sidebyside">
    <!-- vertical alignment -->
    <xsl:apply-templates select="." mode="sidebyside-subitem-valign"/>
    <!-- horizontal alignment -->
    <xsl:apply-templates select="." mode="sidebyside-subitem-halign"/>
    <!-- paragraphs and p elements need wrapping in a parbox -->
    <xsl:text>\parbox{\textwidth}{%&#xa;</xsl:text>
    <!-- horizontal alignment (inside the parbox) -->
    <xsl:apply-templates select="." mode="sidebyside-subitem-halign"/>
    <xsl:text>\setlength{\parskip}{0.5pc}%&#xa;</xsl:text>
    <xsl:apply-templates />
    <!-- \parbox needs closing-->
    <xsl:text>}%&#xa;</xsl:text>
    <!-- end the body of the paragraph -->
    <xsl:text>}% end body &#xa;{</xsl:text>
    <!-- add empty caption -->
    <xsl:text>}% caption &#xa;</xsl:text>
</xsl:template>


<!-- make references to exercises just use the serial number, not full path number -->

<xsl:template match="exercises//exercise" mode="xref-number">
    <xsl:apply-templates select="." mode="serial-number" />
</xsl:template>


<!-- short titles -->

<xsl:template match="chapter[title='Functions, Derivatives, and Antiderivatives']" mode="title-simple">
    <xsl:text>Functions, Derivatives, Antiderivatives</xsl:text>
</xsl:template>
<xsl:template match="chapter[title='Critical Numbers and Graphing from Formulas']" mode="title-simple">
    <xsl:text>Critical Numbers and Graphing</xsl:text>
</xsl:template>
<xsl:template match="chapter/section[title='Sign Tables for the First Derivative']" mode="title-simple">
    <xsl:text>Sign Tables</xsl:text>
</xsl:template>
<xsl:template match="chapter/section[title='Formal Identification of Critical Numbers']" mode="title-simple">
    <xsl:text>Formal ID of Critical Numbers</xsl:text>
</xsl:template>
<xsl:template match="chapter/section[title='Product and Quotient Rules Together']" mode="title-simple">
    <xsl:text>Product, Quotient Rules Together</xsl:text>
</xsl:template>
<xsl:template match="chapter/section[title='Graphical Features from Derivatives']" mode="title-simple">
    <xsl:text>Graph Features from Derivatives</xsl:text>
</xsl:template>


<!-- Make theorems in appendix not be numbered -->
<xsl:template match="theorem">
    <xsl:text>\begin{theorem*}</xsl:text>
    <!-- optional argument to environment -->
    <!-- TODO: and/or credit              -->
    <xsl:text>[</xsl:text>
    <xsl:apply-templates select="." mode="title-full" />
    <xsl:text>]</xsl:text>
    <xsl:apply-templates select="." mode="label"/>
    <xsl:text>&#xa;</xsl:text>
    <!-- statement is required now, to be relaxed in DTD      -->
    <!-- explicitly ignore proof and pickup just for theorems -->
    <xsl:apply-templates select="*[not(self::proof)]" />
    <xsl:text>\end{theorem*}</xsl:text>
</xsl:template>


</xsl:stylesheet>

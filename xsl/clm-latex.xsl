<?xml version='1.0'?> <!-- As XML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Thin layer on MathBook XML -->
<xsl:import href="/Users/alexjordan/mathbook/xsl/mathbook-latex.xsl" />

<!-- Common thin layer                                                      -->
<xsl:import href="clm-common.xsl" />

<!-- Intend output for rendering by pdflatex -->
<xsl:output method="text" />

<!-- Templates added not existing in mathbook-latex.xsl -->
<!--                                                    -->

<!-- center the derivative formulas table -->
<!--
<xsl:template match="centerline">
    <xsl:text>\centerline{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
</xsl:template>
-->


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
        <!-- Lead with the problem number and some space -->
        <xsl:text>\noindent\textbf{</xsl:text>
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


<!-- Preface with numbers                                   -->
<!-- Exercise Group -->
<!-- We interrupt a description list with short commentary, -->
<!-- typically instructions for a list of similar exercises -->
<!-- Commentary goes in an introduction and/or conclusion   -->
<!-- When we point to these, we use custom hypertarget, etc -->
<!--
<xsl:template match="exercisegroup">
    <xsl:text>\textbf{</xsl:text>
    <xsl:apply-templates select="./exercise[1]" mode="serial-number" />
    <xsl:text>--</xsl:text>
    <xsl:apply-templates select="./exercise[last()]" mode="serial-number" />
    <xsl:text>. }</xsl:text>
    <xsl:apply-templates select="." mode="label" />
    <xsl:apply-templates select="introduction" />
    <xsl:apply-templates select="exercise|remark"/>
    <xsl:apply-templates select="conclusion" />
    <xsl:text>\par\smallskip\noindent&#xa;</xsl:text>
</xsl:template>
-->


<!-- Put caption on top                             -->
<!-- A table is like a figure, centered, captioned  -->
<!-- The meat of the table is given by a tabular    -->
<!-- element, which may be used outside of a table  -->
<!-- Standard LaTeX table environment is redefined, -->
<!-- see preamble comments for details              -->
<!--
<xsl:template match="table">
    <xsl:text>\begin{table}&#xa;</xsl:text>
    <xsl:text>\centering&#xa;</xsl:text>
    <xsl:apply-templates select="caption" />
    <xsl:apply-templates select="*[not(self::caption)]" />
    <xsl:text>\end{table}&#xa;</xsl:text>
</xsl:template>
-->

<!-- Prevent line breaks on inline math -->
<!-- Captions for Figures and Tables -->
<!-- xml:id is on parent, but LaTeX generates number with caption -->
<!--
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

<xsl:template match="exercises">
    <!-- Information to console for latex run -->
    <xsl:text>\typeout{************************************************}&#xa;</xsl:text>
    <xsl:text>\typeout{Exercises}&#xa;</xsl:text>
    <xsl:text>\typeout{************************************************}&#xa;</xsl:text>
    <!-- Warn about paragraph deprecation -->
    <xsl:text>\section*{Exercises}</xsl:text>
            <xsl:apply-templates select="." mode="label" />
            <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:if test="author">
        <xsl:text>\noindent{\Large\textbf{</xsl:text>
        <xsl:apply-templates select="author" mode="name-list"/>
        <xsl:text>}}\par\bigskip&#xa;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="introduction" />
    <!-- Process the remaining contents -->
    <xsl:apply-templates select="*[not(self::title or self::author or self::introduction or self::conclusion)]"/>
    <xsl:apply-templates select="conclusion" />
</xsl:template>
-->

<!-- This has now been commented out. It tried to reduce verbosity in exercise references, but ended up causing problems with table and figure references. Leaving it here rather than deleting for the time being. -->
<!-- Almost always, a \ref is good enough       -->
<!-- Hyperref construction:                     -->
<!-- \hyperref[a-label]{Section~\ref*{a-label}} -->
<!--<xsl:template match="*" mode="ref-id">
    <xsl:param name="autoname" />
    <xsl:variable name="prefix">
        <xsl:apply-templates select="." mode="ref-prefix">
            <xsl:with-param name="local" select="$autoname" />
        </xsl:apply-templates>
    </xsl:variable>
    <xsl:choose>
-->        <!-- No autonaming prefix: generic LaTeX cross-reference -->
<!--        <xsl:when test="$prefix=''">
            <xsl:text>\hyperref[</xsl:text>
            <xsl:apply-templates select="." mode="internal-id" />
            <xsl:text>]{</xsl:text>
            <xsl:apply-templates select="." mode="origin-id" />
            <xsl:text>}</xsl:text>
        </xsl:when>
        <xsl:when test="$prefix='Exercise' or $prefix='Exercises'">
            <xsl:text>\hyperref[</xsl:text>
            <xsl:apply-templates select="." mode="internal-id" />
            <xsl:text>]{</xsl:text>
            <xsl:value-of select="$prefix" />
            <xsl:text>~</xsl:text>
            <xsl:apply-templates select="." mode="origin-id" />
            <xsl:text>}</xsl:text>
        </xsl:when>
-->        <!-- Autonaming prefix: hyperref enhanced cross-reference -->
<!--        <xsl:otherwise>
            <xsl:text>\hyperref[</xsl:text>
            <xsl:apply-templates select="." mode="internal-id" />
            <xsl:text>]{</xsl:text>
            <xsl:value-of select="$prefix" />
            <xsl:text>~</xsl:text>
            <xsl:text>\ref*{</xsl:text>
            <xsl:apply-templates select="." mode="internal-id" />
            <xsl:text>}}</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>-->


<!-- Since we are using a tasks environment for exercisegroups, which doesn't fully use 
\textwidth, we need to adjust the widths that are used for sidebyside objects by subtracting
2.5em (the item-indent) divided by however many sidebyside panels there are from each panel
width. This hack will only work for one-column exercisegroups, but more-column exercisegroups
shouldn't have sidebysides in them anyway -->
<!-- When a figure is in a sidebyside, it could be in a minipage, and then the proportional width 
     needs to be changed from its global default. This is done at the end of thies template. -->
<!-- vertical alignment of objects inside sidebyside -->
<!--
<xsl:template match="*" mode="sidebyside-subitem-valign">
-->
    <!-- process the width attritbute -->
<!--
    <xsl:variable name="width">
-->
        <!-- the width of a <object/> inside a sidebyside is translated into
             a fraction of \textwidth
             we do this by stripping the % sign, and
             adding a leading .
             for example 50% is turned into .50\textwith
               -->
<!--        <xsl:choose>
            <xsl:when test="@width">
                <xsl:value-of select="substring-before(@width,'%')" />
            </xsl:when>
            <xsl:otherwise>
-->
              <!-- default width is calculated by computing 100/(number of figures)
                   for example, if there are 4 figures, the default width will be 25% -->
<!--              <xsl:call-template name="printWidth" select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="length" select="string-length($width)"/>
-->
    <!-- capture each element -->
<!--
    <xsl:text>\pushValignCaptionBottom</xsl:text>
-->
    <!-- specify the vertical alignment -->
<!--
    <xsl:choose>
        <xsl:when test="@valign='top'">
            <xsl:text>[t]</xsl:text>
        </xsl:when>
        <xsl:when test="@valign='middle'">
            <xsl:text>[c]</xsl:text>
        </xsl:when>
-->
        <!-- default value -->
<!--        <xsl:otherwise>
            <xsl:text>[b]</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
-->
    <!-- specify minipage, subfigure, or subtable -->
 <!--
   <xsl:text>{</xsl:text>
    <xsl:choose>
      <xsl:when test="self::figure and ancestor::sidebyside/caption">
            <xsl:text>subfigure</xsl:text>
      </xsl:when>
      <xsl:when test="self::table and ancestor::sidebyside/caption">
            <xsl:text>subtable</xsl:text>
      </xsl:when>
      <xsl:otherwise>
            <xsl:text>minipage</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}</xsl:text>
-->
    <!-- specify the text width -->
<!--
    <xsl:text>{.</xsl:text>
    <xsl:choose>
-->
        <!-- @width can contain a decimal, e.g 25.56%, in which
           case we need to remove the decimal -->
<!--
        <xsl:when test="contains($width,'.')">
            <xsl:value-of select="substring-before($width,'.')"/>
            <xsl:value-of select="substring-after($width,'.')"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$width"/>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>\textwidth</xsl:text>
    <xsl:if test="ancestor::exercisegroup">
        <xsl:text>-2.5em/</xsl:text>
        <xsl:value-of select="count(ancestor::sidebyside/*[not(self::caption)])"/>
    </xsl:if>
    <xsl:text>}{%&#xa;</xsl:text>
    <xsl:text>\pgfplotsset{every axis/.append style={width=0.9\linewidth}}%&#xa;</xsl:text>
</xsl:template>
-->


<!-- Introductions and conclusions get a \par at the end because otherwise there is occasional crowding-->
<!--
<xsl:template match="introduction|conclusion">
    <xsl:apply-templates />
    <xsl:text>\par&#xa;</xsl:text>
</xsl:template>
-->


<!-- Overwrite table parts to use booktabs.              -->
<!--
<xsl:template match="tabular[not(@left) or (count(./col[@halign]) &gt; count(./col[@halign='right']) + count(./col[@halign='center'])+ count(./col[@halign='left']))]">
-->
<!--<xsl:template match="tabular[(not(@left) and not(@right) and not(./col/@right) and not(./row/@left) and not(.//cell/@right)) or (count(./col[@halign]) &gt; count(./col[@halign='right']) + count(./col[@halign='center'])+ count(./col[@halign='left']))]">-->
<!--    <xsl:choose>
        <xsl:when test="*[not(ancestor::sidebyside)]">
            <xsl:text>\begin{tabular}{</xsl:text>
            <xsl:apply-templates select="col" mode="booktabs"/>
            <xsl:text>}&#xa;</xsl:text>
            <xsl:if test="@top='major' or @top='medium' or @top='minor'">
                <xsl:text>\toprule&#xa;</xsl:text>
            </xsl:if>
            <xsl:apply-templates select="row" mode="booktabs"/>
            <xsl:text>\end{tabular}&#xa;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="tabular" select="self()" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
<xsl:template match="tabular/col" mode="booktabs">
    <xsl:if test="@left='minor' or @left='medium' or @left='major'">
        <xsl:text>|</xsl:text>
    </xsl:if>
    <xsl:choose>
        <xsl:when test="@halign='center'">
            <xsl:text>c</xsl:text>
        </xsl:when>
        <xsl:when test="@halign='left'">
            <xsl:text>l</xsl:text>
        </xsl:when>
        <xsl:when test="@halign='right'">
            <xsl:text>r</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>p{</xsl:text>
            <xsl:value-of select="@halign"/>
            <xsl:text>}</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@right='minor' or @right='medium' or @right='major'">
        <xsl:text>|</xsl:text>
    </xsl:if>
</xsl:template>
<xsl:template match="tabular/row" mode="booktabs">
    <xsl:apply-templates select="cell" mode="booktabs"/>
    <xsl:choose>
        <xsl:when test="@bottom">
            <xsl:text>\\&#xa;</xsl:text>
            <xsl:choose>
                <xsl:when test="@bottom='medium' or @bottom='minor'">
                    <xsl:text>\midrule&#xa;</xsl:text>
                </xsl:when>
                <xsl:when test="@bottom='major'">
                    <xsl:text>\bottomrule&#xa;</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
            <xsl:if test="position()!=last()">
                <xsl:text>\\&#xa;</xsl:text>
            </xsl:if>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
<xsl:template match="row/cell" mode="booktabs">
    <xsl:if test="@halign">
        <xsl:text>\multicolumn{1}{</xsl:text>
        <xsl:choose>
            <xsl:when test="@halign='center'">
                <xsl:text>c}{</xsl:text>
            </xsl:when>
            <xsl:when test="@halign='left'">
                <xsl:text>l}{</xsl:text>
            </xsl:when>
            <xsl:when test="@halign='right'">
                <xsl:text>r}{</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:if>
    <xsl:apply-templates />
    <xsl:if test="@halign">
        <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:if test="position()!=last()">
        <xsl:text>&amp;</xsl:text>
    </xsl:if>
</xsl:template>
-->

<!--Set the parskip in paragraphs manually to 0.5pc, which is what we've set for this document-->
<!--<xsl:template match="paragraphs" mode="sidebyside">
-->    <!-- vertical alignment -->
<!--    <xsl:apply-templates select="." mode="sidebyside-subitem-valign"/>
-->    <!-- horizontal alignment -->
<!--    <xsl:apply-templates select="." mode="sidebyside-subitem-halign"/>
-->    <!-- paragraphs and p elements need wrapping in a parbox -->
<!--    <xsl:text>\parbox{\textwidth}{%&#xa;</xsl:text>
-->    <!-- horizontal alignment (inside the parbox) -->
<!--    <xsl:apply-templates select="." mode="sidebyside-subitem-halign"/>
    <xsl:text>\setlength{\parskip}{0.5pc}%&#xa;</xsl:text>
    <xsl:apply-templates />
-->    <!-- \parbox needs closing-->
<!--    <xsl:text>}%&#xa;</xsl:text>
-->    <!-- end the body of the paragraph -->
<!--    <xsl:text>}% end body &#xa;{</xsl:text>
-->    <!-- add empty caption -->
<!--    <xsl:text>}% caption &#xa;</xsl:text>
</xsl:template>
-->

<!-- make references to exercises just use the serial number, not full path number -->
<!--
<xsl:template match="exercises//exercise" mode="xref-number">
    <xsl:apply-templates select="." mode="serial-number" />
</xsl:template>
-->

<!-- short titles -->
<!--
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
-->

<!-- Make theorems in appendix not be numbered -->
<!--
<xsl:template match="appendix//theorem" mode="xref-number" />
-->

</xsl:stylesheet>

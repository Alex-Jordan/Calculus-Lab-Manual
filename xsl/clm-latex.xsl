<?xml version='1.0'?> <!-- As XML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Thin layer on MathBook XML -->
<xsl:import href="/Users/alexjordan/mathbook/xsl/mathbook-latex.xsl" />

<!-- Common thin layer                                                      -->
<xsl:import href="clm-common.xsl" />

<!-- LaTeX-specific parameters                                              -->
<xsl:param name="latex.geometry" select="'letterpaper,total={6.25in,9.0in}'" />
<xsl:param name="latex.font.size" select="'12pt'" />
<xsl:param name="latex.preamble.early" select="document('latex.preamble.xml')//latex-preamble-early" />
<xsl:param name="latex.preamble.late" select="document('latex.preamble.xml')//latex-preamble-late" />


<!-- Intend output for rendering by pdflatex -->
<xsl:output method="text" />

<!-- annotate, only defined for latex, not html; to be used after a math mode with \tikzmark in it -->
<!-- contents should use the \Annotate command, defined in image macros                            -->
<xsl:template match="annotate">
    <xsl:apply-templates />
</xsl:template>


<!-- A table is like a figure, centered, captioned  -->
<!-- The meat of the table is given by a tabular    -->
<!-- element, which may be used outside of a table  -->
<!-- Standard LaTeX table environment is redefined, -->
<!-- see preamble comments for details              -->
<xsl:template match="table">
    <xsl:text>\begin{table}&#xa;</xsl:text>
    <xsl:text>\centering&#xa;</xsl:text>
    <xsl:apply-templates select="caption" />
    <xsl:apply-templates select="*[not(self::caption)]" />
    <xsl:text>\end{table}&#xa;</xsl:text>
</xsl:template>

<!-- Authors, editors, full info for titlepage -->
<!-- http://stackoverflow.com/questions/2817664/xsl-how-to-tell-if-element-is-last-in-series -->
<xsl:template match="author">
    <xsl:apply-templates select="personname" />
    <xsl:if test = "department">
        <xsl:text>\\&#xa;</xsl:text>
        <xsl:apply-templates select="department" />
    </xsl:if>
    <xsl:if test = "institution">
        <xsl:text>\\&#xa;</xsl:text>
        <xsl:apply-templates select="institution" />
    </xsl:if>
    <xsl:if test = "email">
        <xsl:text>\\&#xa;</xsl:text>
        <xsl:apply-templates select="email" />
    </xsl:if>
    <xsl:if test="position() != last()" >
        <xsl:text>&#xa;\and</xsl:text>
    </xsl:if>
    <xsl:text>&#xa;</xsl:text>
</xsl:template>
<xsl:template match="editor">
    <xsl:if test="preceding-sibling::author">
        <xsl:text>\and&#xa;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="personname" />
    <xsl:text>, </xsl:text>
    <xsl:call-template name="type-name">
        <xsl:with-param name="string-id" select="'editor'" />
    </xsl:call-template>
    <xsl:if test = "department">
        <xsl:text>\\&#xa;</xsl:text>
        <xsl:apply-templates select="department" />
    </xsl:if>
    <xsl:if test = "institution">
        <xsl:text>\\&#xa;</xsl:text>
        <xsl:apply-templates select="institution" />
    </xsl:if>
    <xsl:if test = "email">
        <xsl:text>\\&#xa;</xsl:text>
        <xsl:apply-templates select="email" />
    </xsl:if>
    <xsl:if test="position() != last()" >
        <xsl:text>&#xa;\and</xsl:text>
    </xsl:if>
    <xsl:text>&#xa;</xsl:text>
</xsl:template>



<!-- Preface, etc within \frontmatter is usually handled correctly by LaTeX -->
<!-- Allow alternative titles, like "Preface to 2nd Edition"                -->
<!-- But we use starred version anyway, so chapter headings react properly  -->
<!-- TODO: add dedication, other frontmatter, move in title handling        -->
<!-- TODO: add to headers, currently just CONTENTS, check backmatter        -->
<xsl:template match="preface|acknowledgement">
    <xsl:variable name="preface-title">
        <xsl:choose>
            <xsl:when test="title">
                <xsl:apply-templates select="title" /> <!-- footnotes dangerous here -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="type-name" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:text>\chapter*{</xsl:text>
    <xsl:value-of select="$preface-title" />
    <xsl:text>}</xsl:text>
    <xsl:apply-templates select="." mode="label" />
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>\addcontentsline{toc}{chapter}{</xsl:text>
    <xsl:value-of select="$preface-title" />
    <xsl:text>}&#xa;</xsl:text>
    <xsl:apply-templates select="*[not(self::title)]"/>
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


<!-- Almost always, a \ref is good enough       -->
<!-- Hyperref construction:                     -->
<!-- \hyperref[a-label]{Section~\ref*{a-label}} -->
<xsl:template match="*" mode="ref-id">
    <xsl:param name="autoname" />
    <xsl:variable name="prefix">
        <xsl:apply-templates select="." mode="ref-prefix">
            <xsl:with-param name="local" select="$autoname" />
        </xsl:apply-templates>
    </xsl:variable>
    <xsl:choose>
        <!-- No autonaming prefix: generic LaTeX cross-reference -->
        <xsl:when test="$prefix=''">
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
        <!-- Autonaming prefix: hyperref enhanced cross-reference -->
        <xsl:otherwise>
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
</xsl:template>

<!-- When a figure is in a sidebyside, it could be in a minipage, and then the width needs to be changed
     from the value we have in docinfo -->
<!-- vertical alignment of objects inside sidebyside -->
<xsl:template match="*" mode="sidebyside-subitem-valign">
    <!-- process the width attritbute -->
    <xsl:variable name="width">
        <!-- the width of a <object/> inside a sidebyside is translated into
             a fraction of \textwidth
             we do this by stripping the % sign, and
             adding a leading .
             for example 50% is turned into .50\textwith
               -->
        <xsl:choose>
            <xsl:when test="@width">
                <xsl:value-of select="substring-before(@width,'%')" />
            </xsl:when>
            <xsl:otherwise>
              <!-- default width is calculated by computing 100/(number of figures)
                   for example, if there are 4 figures, the default width will be 25% -->
              <xsl:call-template name="printWidth" select="."/>
            </xsl:otherwise>
        </xsl:choose>    </xsl:variable>
    <xsl:variable name="length" select="string-length($width)"/>
    <!-- capture each element -->
    <xsl:text>\pushValignCaptionBottom</xsl:text>
    <!-- specify the vertical alignment -->
    <xsl:choose>
        <xsl:when test="@valign='top'">
            <xsl:text>[t]</xsl:text>
        </xsl:when>
        <xsl:when test="@valign='middle'">
            <xsl:text>[c]</xsl:text>
        </xsl:when>
        <!-- default value -->
        <xsl:otherwise>
            <xsl:text>[b]</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <!-- specify minipage, subfigure, or subtable -->
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
    <!-- specify the text width -->
    <xsl:text>{.</xsl:text>
    <xsl:choose>
        <!-- @width can contain a decimal, e.g 25.56%, in which
           case we need to remove the decimal -->
        <xsl:when test="contains($width,'.')">
            <xsl:value-of select="substring-before($width,'.')"/>
            <xsl:value-of select="substring-after($width,'.')"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$width"/>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>\textwidth}{%&#xa;</xsl:text>
    <xsl:text>\pgfplotsset{every axis/.append style={width=\linewidth}}%&#xa;</xsl:text>
</xsl:template>

<!-- For a long table -->
<!-- A table is like a figure, centered, captioned  -->
<!-- The meat of the table is given by a tabular    -->
<!-- element, which may be used outside of a table  -->
<!-- Standard LaTeX table environment is redefined, -->
<!-- see preamble comments for details              -->
<xsl:template match="table[@long='yes']">
    <xsl:apply-templates select="*[not(self::caption)]" />
</xsl:template>

<!-- Modify tabular to check for longtable -->
<!-- A tabular layout -->
<xsl:template match="tabular" name="tabular">
    <!-- Determine global, table-wide properties -->
    <!-- set defaults here if values not given   -->
    <xsl:variable name="table-top">
        <xsl:choose>
            <xsl:when test="@top">
                <xsl:value-of select="@top" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>none</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="table-left">
        <xsl:choose>
            <xsl:when test="@left">
                <xsl:value-of select="@left" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>none</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="table-bottom">
        <xsl:choose>
            <xsl:when test="@bottom">
                <xsl:value-of select="@bottom" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>none</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="table-right">
        <xsl:choose>
            <xsl:when test="@right">
                <xsl:value-of select="@right" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>none</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="table-halign">
        <xsl:choose>
            <xsl:when test="@halign">
                <xsl:value-of select="@halign" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>left</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="table-valign">
        <xsl:choose>
            <xsl:when test="@valign">
                <xsl:value-of select="@valign" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>middle</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- Build latex column specification                         -->
    <!--   vertical borders (left side, right side, three widths) -->
    <!--   horizontal alignment (left, center, right)             -->
    <xsl:choose>
        <xsl:when test="*[ancestor::table[@long='yes']]">
            <xsl:text>\begin{longtable}{</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\begin{tabular}{</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <!-- start with left vertical border -->
    <xsl:call-template name="vrule-specification">
        <xsl:with-param name="width" select="$table-left" />
    </xsl:call-template>
    <xsl:choose>
        <!-- Potential for individual column overrides    -->
        <!--   Deduce number of columns from col elements -->
        <!--   Employ individual column overrides,        -->
        <!--   or use global table-wide values            -->
        <!--   write alignment (mandatory)                -->
        <!--   follow with right border (optional)        -->
        <xsl:when test="col">
            <xsl:for-each select="col">
                <xsl:call-template name="halign-specification">
                    <xsl:with-param name="align">
                        <xsl:choose>
                            <xsl:when test="@halign">
                                <xsl:value-of select="@halign" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$table-halign" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="vrule-specification">
                    <xsl:with-param name="width">
                        <xsl:choose>
                            <xsl:when test="@right">
                                <xsl:value-of select="@right" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$table-right" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:when>
        <!-- All columns specified identically so far   -->
        <!--   so can repeat global, table-wide values  -->
        <!--   use first row to determine number        -->
        <!--   write alignment (mandatory)              -->
        <!--   follow with right border (optional)      -->
        <xsl:otherwise>
            <xsl:for-each select="row[1]/cell">
                <xsl:call-template name="halign-specification">
                    <xsl:with-param name="align" select="$table-halign" />
                </xsl:call-template>
                <xsl:call-template name="vrule-specification">
                    <xsl:with-param name="width" select="$table-right" />
                </xsl:call-template>
            </xsl:for-each>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}</xsl:text>
    <!-- column specification done -->
    <!-- insert caption for longtables -->
    <xsl:if test="*[ancestor::table[@long='yes']]">
        <xsl:apply-templates select="ancestor::longtable/caption"/>
        <xsl:text>\\&#xa;</xsl:text>
    </xsl:if>
    <!-- top horizontal rule is specified after column specification -->
    <xsl:choose>
        <!-- A col element might indicate top border customizations   -->
        <!-- so we walk the cols to build a cline-style specification -->
        <xsl:when test="col/@top">
            <xsl:call-template name="column-cols">
                <xsl:with-param name="the-col" select="col[1]" />
                <xsl:with-param name="col-number" select="1" />
                <xsl:with-param name="clines" select="''" />
                <xsl:with-param name="table-top" select="$table-top"/>
                <xsl:with-param name="prior-top" select="'undefined'" />
                <xsl:with-param name="start-run" select="1" />
            </xsl:call-template>
        </xsl:when>
        <!-- with no customization, we have one continuous rule (if at all) -->
        <!-- use global, table-wide value of top specification              -->
        <xsl:otherwise>
            <xsl:call-template name="hrule-specification">
                <xsl:with-param name="width" select="$table-top" />
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
    <!-- now ready to build rows -->
    <xsl:text>&#xa;</xsl:text>
    <!-- table-wide values are needed to reconstruct/determine overrides -->
    <xsl:apply-templates select="row">
        <xsl:with-param name="table-left" select="$table-left" />
        <xsl:with-param name="table-bottom" select="$table-bottom" />
        <xsl:with-param name="table-right" select="$table-right" />
        <xsl:with-param name="table-halign" select="$table-halign" />
    </xsl:apply-templates>
    <!-- mandatory finish, exclusive of any final row specifications -->
    <xsl:choose>
        <xsl:when test="*[ancestor::table[@long='yes']]">
            <xsl:text>\end{longtable}&#xa;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\end{tabular}&#xa;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    
</xsl:template>


</xsl:stylesheet>

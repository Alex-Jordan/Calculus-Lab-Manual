<?xml version='1.0'?> <!-- As XML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Common (to all LaTeX output modes) thin layer                      -->
<xsl:import href="clm-latex.xsl" />


<!-- LaTeX-specific parameters                                              -->
<!--<xsl:param name="latex.geometry" select="'letterpaper,total={6.3in,9.0in}'" />-->
<xsl:param name="exercise.backmatter.answer" select="'no'" />
<xsl:param name="exercise.backmatter.hint" select="'no'" />
<xsl:param name="exercise.text.hint" select="'no'" />
<xsl:param name="exercise.backmatter.solution" select="'no'" />
<xsl:param name="latex.preamble.early" select="concat(document('latex-preamble/latex.preamble.xml')//latex-preamble-early, document('latex-preamble/tex4htbrf.preamble.xml')//latex-preamble-early)" />
<xsl:param name="latex.preamble.late" select="concat(document('latex-preamble/latex.preamble.xml')//latex-preamble-late, document('latex-preamble/tex4htbrf.preamble.xml')//latex-preamble-late)" />
<xsl:param name="chunk.level" select="0" />


<!-- Ignore sidebyside for now -->
<xsl:template match="sidebyside"/>

<!-- Substitute description for image -->
<xsl:template match="image">
    <xsl:apply-templates select="description"/>
</xsl:template>


</xsl:stylesheet>

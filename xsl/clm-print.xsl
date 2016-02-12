<?xml version='1.0'?> <!-- As XML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Common (to all LaTeX output modes) thin layer                      -->
<xsl:import href="clm-latex.xsl" />


<!-- LaTeX-specific parameters                                              -->
<!--<xsl:param name="latex.geometry" select="'letterpaper,total={6.3in,9.0in}'" />-->
<xsl:param name="latex.font.size" select="'12pt'" />
<xsl:param name="exercise.backmatter.hint" select="'no'" />
<xsl:param name="exercise.backmatter.answer" select="'yes'" />
<xsl:param name="exercise.backmatter.solution" select="'no'" />
<xsl:param name="exercise.text.hint" select="'no'" />
<xsl:param name="exercise.text.answer" select="'no'" />
<xsl:param name="exercise.text.solution" select="'no'" />
<xsl:param name="latex.preamble.early" select="concat(document('latex-preamble/latex.preamble.xml')//latex-preamble-early, document('latex-preamble/print.preamble.xml')//latex-preamble-early)" />
<xsl:param name="latex.preamble.late" select="concat(document('latex-preamble/latex.preamble.xml')//latex-preamble-late, document('latex-preamble/print.preamble.xml')//latex-preamble-late)" />
<xsl:param name="chunk.level" select="0" />


<!--
<xsl:template match="backmatter/section[title='Solutions to Supplemental Exercises']" mode="title-full">
    <xsl:text>Answers to Supplemental Exercises (Full Solutions in Online Edition)</xsl:text>
</xsl:template>
<xsl:template match="backmatter/section[title='Solutions to Supplemental Exercises']" mode="title-simple">
    <xsl:text>Answers to Supplemental Exercises</xsl:text>
</xsl:template>
-->

</xsl:stylesheet>

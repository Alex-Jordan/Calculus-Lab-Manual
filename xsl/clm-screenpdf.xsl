<?xml version='1.0'?> <!-- As XML file -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Common (to all LaTeX output modes) thin layer                      -->
<xsl:import href="clm-latex.xsl" />


<!-- LaTeX-specific parameters                                              -->
<xsl:param name="latex.geometry" select="'paperheight=8in,paperwidth=6in,margin=0.50in'" />
<xsl:param name="latex.font.size" select="'10pt,oneside'" />
<xsl:param name="exercise.backmatter.hint" select="'no'" />
<xsl:param name="exercise.backmatter.answer" select="'no'" />
<xsl:param name="exercise.backmatter.solution" select="'yes'" />
<xsl:param name="exercise.text.hint" select="'no'" />
<xsl:param name="exercise.text.answer" select="'no'" />
<xsl:param name="exercise.text.solution" select="'no'" />
<xsl:param name="exercise.backmatter.solution" select="'no'" />
<xsl:param name="latex.preamble.early" select="concat(document('latex-preamble/latex.preamble.xml')//latex-preamble-early, document('latex-preamble/screenpdf.preamble.xml')//latex-preamble-early)" />
<xsl:param name="latex.preamble.late" select="concat(document('latex-preamble/latex.preamble.xml')//latex-preamble-late, document('latex-preamble/screenpdf.preamble.xml')//latex-preamble-late)" />
<xsl:param name="chunk.level" select="0" />


</xsl:stylesheet>

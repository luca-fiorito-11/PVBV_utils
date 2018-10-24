<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html> 

<body>
  <h2>Warning and error messages</h2>
  <table border="1">
    <tr>
      <th style="text-align:left">Type</th>
      <th style="text-align:left">Class</th>
      <th style="text-align:left">Module</th>
      <th style="text-align:left">Message</th>
    </tr>
    <xsl:for-each select="messages/message">
	  <xsl:choose>
	    <xsl:when test="type = 'warning'">
          <tr>
            <td><xsl:value-of select="type"/></td>
	        <td><xsl:value-of select="class"/></td>
            <td><xsl:value-of select="module"/></td>
            <td><xsl:value-of select="text"/></td>
          </tr>
		</xsl:when>
	    <xsl:when test="type = 'error'">
          <tr bgcolor="#EC7063">
            <td><xsl:value-of select="type"/></td>
	        <td><xsl:value-of select="class"/></td>
            <td><xsl:value-of select="module"/></td>
            <td><xsl:value-of select="text"/></td>
          </tr>
		</xsl:when>
	    <xsl:otherwise>
          <tr>
            <td><xsl:value-of select="type"/></td>
	        <td><xsl:value-of select="class"/></td>
            <td><xsl:value-of select="module"/></td>
            <td><xsl:value-of select="text"/></td>
          </tr>
		</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </table>
</body>

</html>
</xsl:template>
</xsl:stylesheet>

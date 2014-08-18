<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:s="http://feed.elasticstats.com/schema/hockey/schedule-v2.0.xsd"
                exclude-result-prefixes="s" version="1.0">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <style type="text/css">
                    .content, .header {
                        width:900px;
                        padding-left: 50px;
                    }
                    
                    .content table {
                        width: 100%;
                        clear:both;
                        line-height: 20px;
                        font-family: helvetica;
                        font-size:12;
                    }
                    .content th, .content td {
                        border-bottom: 1px dotted darkGray;
                    }
                    .content th {
                        text-align: center;
                        background-color: #E4E4E4;
                    }
                    .content th.date {
                        text-align: left;
                        background-color: #227a92;
                        color: #fff;
                        font-weight:bold;
                        font-size: 14;
                    }
                    .content .status, .content .coverage {text-align: center; }
                    .content .team { padding-left: 5px; }
                    .content .time { width: 90px; }
                </style>
            </head>
            <body>
                <div class="header">
                    <xsl:apply-templates select="s:league/s:season-schedule" mode="header"/>
                </div>
                <div class="content">
                    <xsl:apply-templates select="s:league/s:daily-schedule" mode="content"/>
                    <xsl:apply-templates select="s:league/s:season-schedule" mode="content"/>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="s:season-schedule" mode="header">
        <h4><xsl:value-of select="@year"/> - <xsl:value-of select="@type"/></h4>    
    </xsl:template>

    <xsl:template match="s:daily-schedule" mode="content">
        <table class="schedule">
            <tr class="date-header">
                <th class="date" colspan="6">
                    <xsl:value-of select="@date"/>
                </th>
            </tr>
            <tr class="header">
                <th class="time">Time</th>
                <th class="team">Away</th>
                <th class="team">Home</th>
                <th class="status">Status</th>
                <th class="coverage">Coverage</th>
                <th class="venue">Venue</th>
            </tr>
            
            <xsl:for-each select="s:games/s:game">
                <xsl:sort select="@scheduled"/>
                
                <xsl:apply-templates select="." mode="item" />
            </xsl:for-each>
            
        </table>
    </xsl:template>
    
    <xsl:template match="s:season-schedule" mode="content">
        <table class="schedule">
            <xsl:for-each select="s:games/s:game">
                <xsl:sort select="@scheduled"/>
                
                <xsl:variable name="prior_date">
                    <xsl:call-template name="date">
                        <xsl:with-param name="value">
                            <xsl:value-of select="preceding-sibling::*[1]/@scheduled"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:variable name="current_date">
                    <xsl:call-template name="date">
                        <xsl:with-param name="value">
                            <xsl:value-of select="@scheduled"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
               
                <xsl:if test="$prior_date != $current_date">
                    <tr class="date-header">
                        <th class="date" colspan="6">
                            <xsl:value-of select="$current_date"/>
                        </th>
                    </tr>
                    <tr class="header">
                        <th class="time">Time</th>
                        <th class="team">Away</th>
                        <th class="team">Home</th>
                        <th class="status">Status</th>
                        <th class="coverage">Coverage</th>
                        <th class="venue">Venue</th>
                    </tr>
                </xsl:if>
                <xsl:apply-templates select="." mode="item" />    
                
            </xsl:for-each>
        </table>
    </xsl:template>
    
    <xsl:template match="s:game" mode="item">
        <tr>
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <td class="time">
                <xsl:call-template name="time">
                    <xsl:with-param name="value"><xsl:value-of select="@scheduled"/></xsl:with-param>
                </xsl:call-template>
            </td>
            <td class="team"><xsl:value-of select="s:away/@name"/></td>
            <td class="team"><xsl:value-of select="s:home/@name"/></td>
            <td class="status"><xsl:value-of select="@status"/></td>
            <td class="status"><xsl:value-of select="@coverage"/></td>
            <td class="venue">
                <xsl:apply-templates select="s:venue" />
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="s:venue">
        <xsl:value-of select="@name"/>,&#160;<xsl:value-of select="@address"/>,&#160;<xsl:value-of select="@city"/>    
    </xsl:template>

    <xsl:template name="date">
        <xsl:param name="value" />
        
        <xsl:value-of select="substring-before($value, 'T')"/>
    </xsl:template>
    <xsl:template name="time">
        <xsl:param name="value" />
        
        <xsl:value-of select="substring-after($value, 'T')"/>
    </xsl:template>

</xsl:stylesheet>
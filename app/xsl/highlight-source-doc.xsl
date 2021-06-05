<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:f="internal"
    exclude-result-prefixes="#all"
    version="3.0">
 
    <xsl:import href="xmlspectrum.xsl"/>
    
    <xsl:param name="color-theme" select="'light'"/>
    
    <xsl:variable name="css-inline" select="'no'"/>
    
    <xsl:output method="xml" indent="yes" html-version="5"/>
    
    <xsl:template match="/" name="xsl:initial-template">
        <html>
            <head>
                <title>XMLSpectrum test</title>
            </head>
            <body>
                <h1>XMLSpectrum test</h1>
                <section>
                    <h2>Original XML spectrum</h2>
                    <pre><xsl:sequence select="f:render(serialize(.), 'xml', '')"/></pre>
                </section>
                <!--<section>
                    <h2>recursive XML spectrum</h2>
                    <pre><xsl:apply-templates mode="render" select="."/></pre>
                </section>-->
                <section>
                    <h2>emit XML spectrum spans</h2>
                    <pre><xsl:apply-templates mode="render-spans" select="."/></pre>
                </section>
            </body>
        </html>    
    </xsl:template>
    
    <xsl:mode name="render" on-no-match="shallow-skip"/>
    
    <xsl:template match="*" mode="render">
        <xsl:variable name="xml" select="serialize(.)"/>
        <xsl:variable name="start-tag" select="$xml => replace('>(.*$)', '>', 's')"/>
        <xsl:comment select="'start-tag', $start-tag"/>
        <xsl:sequence select="f:render($start-tag, 'xml', '')"/>
        
        <xsl:apply-templates mode="#current"/>
        
        <xsl:variable name="end-tag" select="$xml => replace('.*(&lt;/[^&lt;]+$)', '$1', 's')"/>
        
        <xsl:comment select="'end-tag', $end-tag"/>
        
        <xsl:sequence select="f:render($end-tag, 'xml', '')"/>
    </xsl:template>
    
    <xsl:template match="text() | comment() | processing-instruction()" mode="render">
        <xsl:sequence select="f:render(serialize(.), 'xml', '')"/>
    </xsl:template>
    
    <xsl:mode name="render-spans" on-no-match="shallow-skip"/>
    
    <xsl:template match="*" mode="render-spans" expand-text="yes">
        <xsl:variable name="xpath" select="path(.)"/>
        
        <span class="es" data-xpath="{$xpath}">&lt;</span>
        <span class="en" data-xpath="{$xpath}">{node-name()}</span>
        <span class="scx" data-xpath="{$xpath}">></span>
        
        <xsl:apply-templates mode="#current" select="@*"/>
        
        <xsl:choose>
            <xsl:when test="has-children(.)">
                <xsl:apply-templates mode="#current"/>
                <span class="ez" data-xpath="{$xpath}">&lt;/</span>
                <span class="en" data-xpath="{$xpath}">{node-name()}</span>
                <span class="ec" data-xpath="{$xpath}">></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="sz" data-xpath="{$xpath}">/></span>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="@*" mode="render-spans" expand-text="yes">
        <xsl:variable name="xpath" select="path(.)"/>
        <span class="z"> </span>
        <span class="atn" data-xpath="{$xpath}">{node-name()}</span>
        <span class="atneq" data-xpath="{$xpath}">=</span>
        <span class="z" data-xpath="{$xpath}">"</span>
        <span class="av" data-xpath="{$xpath}">{.}</span>
        <span class="z" data-xpath="{$xpath}">"</span>
    </xsl:template>
    
    <xsl:template match="text()" mode="render-spans" expand-text="yes">
        <span class="txt" data-xpath="{path(.)}">{.}</span>
    </xsl:template>
    
    <xsl:template match="comment()" mode="render-spans" expand-text="yes">
        <span class="cm" data-xpath="{path(.)}">{.}</span>
    </xsl:template>
    
    <xsl:template match="processing-instruction()" mode="render-spans">
        <span class="pi" data-xpath="{path(.)}">{.}</span>
    </xsl:template>
</xsl:stylesheet>
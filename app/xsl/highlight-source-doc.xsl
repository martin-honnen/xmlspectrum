<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
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
                <section>
                    <h1>Comparison</h1>
                    <section>
                        <xsl:variable name="xmlspectrum">
                            <xsl:apply-templates select="f:render(serialize(.), 'xml', '')" mode="strip-namespace"/>
                        </xsl:variable>
                        <xsl:variable name="tree-spans">
                            <xsl:apply-templates mode="render-spans" select="."/>
                        </xsl:variable>
                        <xsl:variable name="tree-spans-stripped-data">
                            <xsl:apply-templates select="$tree-spans/*:span" mode="remove-data-atts"/>
                        </xsl:variable>
                        <h2>Result: <code xsl:expand-text="yes">{deep-equal($xmlspectrum, $tree-spans-stripped-data)}</code></h2>
                        <code data-result="{deep-equal($xmlspectrum, $tree-spans-stripped-data)}" style="display: flex; flex-direction: row;">
                            <pre style="flex: 1;">
                                <xsl:sequence select="$xmlspectrum"/>
                            </pre>
                            <pre style="flex: 1;">
                                <xsl:sequence select="$tree-spans-stripped-data"/>
                            </pre>
                        </code>
                    </section>
                </section>
                <h1>XMLSpectrum test</h1>
                <section>
                    <h2>Original XML spectrum</h2>
                    <pre><xsl:sequence select="f:render(serialize(.), 'xml', '')"/></pre>
                </section>
                <section>
                    <h2>emit XML spectrum spans</h2>
                    <pre><xsl:apply-templates mode="render-spans" select="."/></pre>
                </section>
            </body>
        </html>    
    </xsl:template>

    <xsl:function name="f:render-tree" as="node()*">
        <xsl:param name="input-node" as="node()"/>
        <xsl:variable name="mark-up-spans" as="node()*">
            <xsl:apply-templates select="$input-node" mode="render-spans"/>
        </xsl:variable>
        <xsl:sequence
            select="if ($css-inline eq 'no') then $mark-up-spans else f:style-spans($mark-up-spans)"/>
    </xsl:function>
    
    <xsl:mode name="render-spans" on-no-match="shallow-skip"/>
    
    <xsl:template match="*" mode="render-spans" expand-text="yes">
        <xsl:param name="parent-in-scope-namespaces" tunnel="yes" as="map(xs:string, xs:string)*" select="()"/>
        <xsl:variable name="current-in-scope-namespaces" as="map(xs:string, xs:string)*" select="in-scope-prefixes(.)[. != 'xml']!map { . : namespace-uri-for-prefix(., current()) => string() }"/>
        <xsl:variable name="xpath" select="path(.)"/>
        
        <span class="es" data-xpath="{$xpath}">&lt;</span>
        <span class="en" data-xpath="{$xpath}">{node-name()}</span>

        <xsl:apply-templates select="namespace::*[not(. = 'http://www.w3.org/XML/1998/namespace')][not(some $ns in $parent-in-scope-namespaces satisfies deep-equal($ns, map { local-name() : string() }))]" mode="#current"/>

        <xsl:apply-templates mode="#current" select="@*"/>
        
        <xsl:choose>
            <xsl:when test="has-children(.)">
                <span class="scx" data-xpath="{$xpath}">></span>
                <xsl:apply-templates mode="#current">
                    <xsl:with-param name="parent-in-scope-namespaces" tunnel="yes" as="map(xs:string, xs:string)*" select="f:merge-namespaces($parent-in-scope-namespaces, $current-in-scope-namespaces)"/>
                </xsl:apply-templates>
                <span class="ez" data-xpath="{$xpath}">&lt;/</span>
                <span class="cl" data-xpath="{$xpath}">{node-name()}</span>
                <span class="ec" data-xpath="{$xpath}">></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="sz" data-xpath="{$xpath}">/></span>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="@*" mode="render-spans" expand-text="yes">
        <xsl:variable name="xpath" select="path(.)"/>
        <span class="z"><xsl:text> </xsl:text></span>
        <span class="atn" data-xpath="{$xpath}">{node-name()}</span>
        <span class="atneq" data-xpath="{$xpath}">=</span>
        <span class="z" data-xpath="{$xpath}">"</span>
        <span class="av" data-xpath="{$xpath}">{serialize(string(), map { 'method' : 'xml', 'omit-xml-declaration' : true(), 'indent' : false() })}</span>
        <span class="z" data-xpath="{$xpath}">"</span>
    </xsl:template>

    <xsl:template match="namespace-node()" mode="render-spans" expand-text="yes">
        <xsl:variable name="xpath" select="path(.)"/>
        <span class="z"><xsl:text> </xsl:text></span>
        <span class="atn" data-xpath="{$xpath}">{if (local-name() = '') then 'xmlns' else 'xmlns:' || node-name()}</span>
        <span class="atneq" data-xpath="{$xpath}">=</span>
        <span class="z" data-xpath="{$xpath}">"</span>
        <span class="av" data-xpath="{$xpath}">{.}</span>
        <span class="z" data-xpath="{$xpath}">"</span>
    </xsl:template>
    
    <xsl:template match="text()" mode="render-spans" expand-text="yes">
        <span class="txt" data-xpath="{path(.)}">{serialize(., map { 'method' : 'xml', 'omit-xml-declaration' : true(), 'indent' : false() })}</span>
    </xsl:template>
    
    <xsl:template match="comment()" mode="render-spans" expand-text="yes">
        <span class="z" data-xpath="{path(.)}">&lt;!--</span>
        <span class="cm" data-xpath="{path(.)}">{.}</span>
        <span class="z" data-xpath="{path(.)}">--&gt;</span>
    </xsl:template>
    
    <xsl:template match="processing-instruction()" mode="render-spans" expand-text="yes">
        <span class="z" data-xpath="{path(.)}">&lt;?</span>
        <span class="pi" data-xpath="{path(.)}">{node-name(), .}</span>
        <span class="z" data-xpath="{path(.)}">?&gt;</span>
    </xsl:template>

    <xsl:mode name="strip-namespace" on-no-match="shallow-copy"/>

    <xsl:template match="*" mode="strip-namespace">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:apply-templates  mode="#current"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*:span[@class = 'txt'][. = '']" mode="strip-namespace"/>

    <xsl:mode name="remove-data-atts" on-no-match="shallow-copy"/>

    <xsl:template match="*" mode="remove-data-atts">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*[not(starts-with(local-name(), 'data-'))]" mode="#current"/>
            <xsl:apply-templates  mode="#current"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*:span[@class = 'txt'][. = '']" mode="remove-data-atts"/>

    <xsl:function name="f:merge-namespaces" as="map(xs:string, xs:string)*">
        <xsl:param name="parent-in-scope-namespaces" as="map(xs:string, xs:string)*"/>
        <xsl:param name="current-in-scope-namespaces" as="map(xs:string, xs:string)*"/>
        <xsl:for-each-group select="$parent-in-scope-namespaces, $current-in-scope-namespaces" group-by="map:keys(.)">
            <xsl:sequence select="current-group()[last()]"/>
        </xsl:for-each-group>
    </xsl:function>
</xsl:stylesheet>
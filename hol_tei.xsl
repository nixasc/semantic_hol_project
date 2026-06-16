<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>



    <xsl:template match="/">
        <html>

            <head>
                <meta charset="UTF-8"/>
                <title>
                    <xsl:value-of select="//tei:titleStmt/tei:title"/>
                </title>

                <style>
                    body { font-family: "Times New Roman", serif; width: 80%; margin: 0 auto; padding: 2em; line-height: 1.5; }
                    header { border-bottom: 2px solid #ccc; margin-bottom: 1em; }
                    .meta { color: #555; font-size: 0.9em; }

                    .section { margin-top: 3em; border-bottom: 2px solid #ccc; }
                    h1, h2 { color: #222; text-align: center;}

                    .entity { text-decoration: underline; }
                    .bibl { text-decoration: underline; }
                    .term { text-decoration: underline; }
                    .org { text-decoration: underline; }
                    .place { text-decoration: underline; }

                    table { border-collapse: collapse; width: 80%; margin: 1em auto 2em auto; table-layout: fixed; }
                    td, th { border: 1px solid #ccc; padding: 6px; }
                </style>
            </head>


            <body>
                <header>
                    <h1>
                        <xsl:value-of select="//tei:titleStmt/tei:title"/>
                    </h1>
                    <div class="meta">
                        Author: <xsl:value-of select="//tei:titleStmt/tei:author"/><br/>
                        Annotated by: <xsl:value-of select="//tei:respStmt/tei:persName"/><br/>
                        Publisher: <xsl:value-of select="//tei:publicationStmt/tei:publisher"/><br/>
                        Place: <xsl:value-of select="//tei:publicationStmt/tei:pubPlace"/><br/>
                        Year: <xsl:value-of select="//tei:publicationStmt/tei:date"/>
                    </div>
                </header>


                <xsl:apply-templates select="//tei:text"/>
                <xsl:call-template name="entities"/>
            </body>
        
        </html>
    </xsl:template>



    <xsl:template match="tei:text">
        <div class="text">
            <xsl:apply-templates/>
        </div>
    </xsl:template>



    <xsl:template match="tei:div">
        <div class="section">
            <h2>
                <xsl:value-of select="tei:head"/>
            </h2>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:head"/>

    <xsl:template match="tei:persName">
        <span class="entity">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="tei:bibl">
        <span class="bibl">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="tei:term">
        <span class="term">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="tei:orgName">
        <span class="entity">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="tei:place">
        <span class="place">
             <xsl:value-of select="."/>
        </span>
    </xsl:template>



    <!-- ENTITIES -->

    <xsl:template name="entities">

        <h2>Persons</h2>
        <table>
            <tr>
                <th>Name</th>
                <th>Authority</th>
            </tr>
            <xsl:for-each select="//tei:listPerson/tei:person">
                <tr>
                    <td><xsl:value-of select=".//tei:persName[1]"/></td>
                    <td>
                        <xsl:if test="@sameAs">
                            <a href="{@sameAs}" target="_blank">Wikidata</a>
                         </xsl:if>
                    </td>
                </tr>
            </xsl:for-each>
        </table>

        <h2>Bibliography</h2>
        <table>
            <tr>
                <th>Work</th>
                <th>Authority</th>
            </tr>
            <xsl:for-each select="//tei:listBibl/tei:bibl">
                <tr>
                    <td><xsl:value-of select="."/></td>
                    <td>
                        <xsl:if test="@sameAs">
                            <a href="{@sameAs}" target="_blank">Wikidata</a>
                         </xsl:if>
                    </td>
                </tr>
            </xsl:for-each>
        </table>

        <h2>Concepts</h2>
        <table>
            <tr>
                <th>Term</th>
                <th>Authority</th>
            </tr>
            <xsl:for-each select="//tei:list/tei:item">
                <tr>
                    <td><xsl:value-of select=".//tei:term"/></td>
                    <td>
                        <xsl:if test="@sameAs">
                            <a href="{@sameAs}" target="_blank">Wikidata</a>
                         </xsl:if>
                    </td>
                </tr>
            </xsl:for-each>
        </table>

        <h2>Organizations</h2>
        <table>
            <tr>
                <th>Organizations</th>
                <th>Authority</th>
            </tr>
            <xsl:for-each select="//tei:listOrg/tei:org">
                <tr>
                    <td><xsl:value-of select=".//tei:orgName"/></td>
                    <td>
                        <xsl:if test="@sameAs">
                            <a href="{@sameAs}" target="_blank">Wikidata</a>
                         </xsl:if>
                    </td>
                </tr>
            </xsl:for-each>
        </table>

        <h2>Places</h2>
        <table>
            <tr>
                <th>Places</th>
                <th>Authority</th>
            </tr>
            <xsl:for-each select="//tei:listPlace/tei:place">
                <tr>
                    <td><xsl:value-of select=".//tei:placeName"/></td>
                    <td>
                        <xsl:if test="@sameAs">
                            <a href="{@sameAs}" target="_blank">Wikidata</a>
                         </xsl:if>
                    </td>
                </tr>
            </xsl:for-each>
        </table>

    </xsl:template>

</xsl:stylesheet>